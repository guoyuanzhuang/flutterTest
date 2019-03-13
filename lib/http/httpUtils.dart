import 'package:dio/dio.dart';
import 'dart:io';
import 'AESUtil.dart';
import 'RSAUtil.dart';
import '../utils/stringUtils.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/strings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/// * 192.168.3.194 开发服务
/// * 192.168.3.193 测试服务
/// * docker.ddsoucai.com https 预发
/// * gwserv.ddsoucai.com https 线上
/// * sqserv.ddsoucai.com https
///
class HttpUtils{
  static final isDebug = true;  //调试模式

  static final host = 'http://192.168.3.193';
  static final apiBaseUrl = host + '/ddsc-app/';
  static final h5BaseUrl = host + '/ddsc-html/';

  static final httpTimeout = 7 * 1000;

  static final httpCookie = "cookie";

  ///初始化Dio
  static final Dio _dio = Dio(Options(
    connectTimeout: httpTimeout,
    receiveTimeout: httpTimeout,
    baseUrl: apiBaseUrl,
    followRedirects: true,
    headers: _getHttpHeader(),
  ));

  ///设置请求头
  static _getHttpHeader(){
    Map<String, dynamic> header = {
      'platform':'Android',
      'terminalModel':'PRA-AL00',
      'OSVersion':'7.0',
      'appVersion':'4.2.1',
      'appVersionCode':'4210',
      'campaignChannel':'guanwang',
      'terminalId':'032296e3-4661-451d-a11c-7d04c6c5810d',
    };
    print("init HttpHeader>>>$header");
    return header;
  }

  /*///Cookie持久化--------手动实现
  static void _setPersistCookie(HttpHeaders header) async{
    String cookie = header.value("Set-Cookie");
    if(isNotEmpty(cookie)){
      print("persist Cookie>>>$cookie");
      _dio.options.headers[httpCookie] = cookie;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(httpCookie, cookie);
    }
  }

  ///删除cookie
  static void cleanCookie() async{
    print("del Cookie");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(httpCookie, "");
    _dio.options.headers.remove(httpCookie);
  }

  ///获取Cookie
  static Future<String> getCookie() async {
    print("get Cookie");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(httpCookie);
  }-----------手动实现*/

  ///自签名证书SSL验证
  static void _setSSLCertificate(){
    final publicKeyFile = File('raw/ddsoucai.pem');
    String pem = publicKeyFile.readAsStringSync();
    _dio.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback=(X509Certificate cert, String host, int port){
        if(cert.pem == pem){
          print('Verify the certificate');
          return true;
        }
        return false;
      };
    };
  }

  /// 测试阶段设置代理 方便接口调试
  static void _setProxy() {
    _dio.onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) {
        return "PROXY 192.168.3.20:8888";
      };
    };
  }

  ///切换RSA证书
  static _switchPublicKey() {
    if(isDebug){
      return "assets/ddsc_debug_public_key.pem";
    }else{
      return "assets/ddsc_release_public_key.pem";
    }
  }

  ///持久化cookie
  static void _setPersistCookie() async{
    print("persist Cookie");
    var appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    PersistCookieJar cookieJar = new PersistCookieJar(appDocPath);
    _dio.cookieJar = cookieJar;
  }

  ///删除cookie
  static void cleanCookie() {
    print("delete Cookie");
    PersistCookieJar cookieJar = _dio.cookieJar;
    cookieJar.deleteAll();
  }

  ///获取cookie
  static List<Cookie> getCookie(){
    PersistCookieJar cookieJar = _dio.cookieJar;
    Uri uri = Uri.parse(host).normalizePath();
    return cookieJar.loadForRequest(uri);
  }

  ///GET 请求
  static get(BuildContext context, String path, {Map<String, dynamic> map}) async{
//    _setProxy();
    print("GET Request Url>>>>${apiBaseUrl + path}");
    print("GET Request Body>>>>$map");
    _dio.options.responseType = ResponseType.JSON;
    _setPersistCookie();
    Response response;
    try{
      response = await _dio.get(path, data: map);
      print("GET Result>>>>${response.data}");
      return response.data;
    } on DioError catch(e){
      print("Http Exception>>>$e");
//      ToastView.showMessageShort("亲，网络不给力喔");  //这里提示用户
      if(e.response != null && e.response.statusCode == 401){
        _loginAuthFail(context);
      }
    }
  }

  ///POST 请求
  static post(BuildContext context, String path, {Map<String, dynamic> map}) async{
//    _setProxy();
    if(map == null){
      new Map();
    }
    print("POST Url>>>>${apiBaseUrl + path}");
    String jsonParams = json.encode(map);
    print("POST Body>>>>$jsonParams");

    String sequence = StringUtils.getRandomString(16);
//    print("POST AES Key>>>>$sequence");
    String encryptRequest = AESUtil.encrypt2Base64(sequence, jsonParams);  //json.encode(jsonParams)
//    print("POST AES Encrypt >>>>$encryptRequest");
    String pem = await DefaultAssetBundle.of(context).loadString(_switchPublicKey());
    RSAUtil rsaUtil = RSAUtil.getInstance(pem, null);
    String encryptSequence = rsaUtil.encrypt(sequence);
//    print("POST RSA Encrypt>>>>$encryptSequence");
    _dio.options.headers["sequence"] = encryptSequence;
    _dio.options.responseType = ResponseType.PLAIN;
    _setPersistCookie();
    Response response;
    try{
      response = await _dio.post(path, data: {"body": encryptRequest});
      String result = AESUtil.decrypt2Base64(sequence, response.data);
      print("POST Result>>>>$result");
      return json.decode(result);
    } on DioError catch(e){
      print("Http Exception>>>$e");
//      ToastView.showMessageShort("亲，网络不给力喔");  //这里提示用户
      if(e.response != null && e.response.statusCode == 401){
        _loginAuthFail(context);
      }
    }
  }

  ///登录授权过期
  static void _loginAuthFail(BuildContext context){
    print("-----登录授权过期-----");
    cleanCookie();
    //ToastView.showMessageShort("登录授权过期，请重新登录");
    //AppContext.exitLogin();
    //UIHelper.gotoMain(AppContext.getInstance(), HomeRootFragment.class.getSimpleName(), Intent.FLAG_ACTIVITY_NEW_TASK);
    //UIHelper.gotoLRPhoneActivity(AppContext.getInstance(), Intent.FLAG_ACTIVITY_NEW_TASK);
  }
}

