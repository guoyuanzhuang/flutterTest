import 'dart:isolate';
import 'package:dio/dio.dart';

void main(){
//  getHttp();

  Map map = {"content":"enenen", "aaa":"bbb"};
  map["aaa"] = "ccc";
  map["ddd"] = "eee";
  print(map);
}

getHttp() async{
  try {
    Response response = await Dio().get("http://www.toly1994.com:8089/api/android/note");
    return print(response);
  }catch(e){
    return print(e);
  }
}

postHttp() async{
  return await Dio().post('https://www.baidu.com');
}