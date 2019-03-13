
///网络请求结果
///by guoyuanzhuang@ddsoucai.cn
class BaseEntity {
  bool success;
  String returnCode;
  Map<String, dynamic> result ;


  BaseEntity.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    returnCode = json['returnCode'];
    result = json['result'];
  }
}
