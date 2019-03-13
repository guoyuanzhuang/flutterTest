import 'dart:io';

abstract class PostResponseHandler{
  String sequence;

  void onSuccess(HttpHeaders headers);

  void onFail(HttpHeaders headers);
}