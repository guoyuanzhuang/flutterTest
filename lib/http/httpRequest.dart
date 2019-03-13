import 'httpUtils.dart';
import 'package:flutter/widgets.dart';
import '../utils/MD5Util.dart';
///http接口请求
class HttpRequest{
  ///获取公共配置
  static Future<Map<String, dynamic>> getAppResource(BuildContext context, String keys) async {
    return await HttpUtils.get(context, "app/resource", map:{'keys': keys});
  }

  ///检查手机号
  static Future<Map<String, dynamic>> checkPhone(BuildContext context, String mobile) async {
    return await HttpUtils.post(context, "account/check", map:{"mobile": mobile});
  }

  ///登录
  static Future<Map<String, dynamic>> login(BuildContext context, String mobile, String loginPassword) async {
    return await HttpUtils.post(context, "account/login", map:{"mobile": mobile, "loginPassword": MD5Util.getLoginMD5(loginPassword)});
  }

  ///获取账户信息
  static Future<Map<String, dynamic>> getAccountInfo(BuildContext context) async {
    return await HttpUtils.get(context, "account/info");
  }


}