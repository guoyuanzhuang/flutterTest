
void main(){
  print('test print \n' * 2);

  var list = [1, 5, 2, 4, 3];
  list.sort();
  print(list.toString());

  String a = "aaa";
  print(a ?? 'bbb') ;

  renderSome();

}

///模拟等待两秒，返回OK
request() async {
  await Future.delayed(Duration(seconds: 1));
  return "ok!";
}

///得到"ok!"后，将"ok!"修改为"ok from request"
doSomeThing() async {
  String data = await request();
  data = "ok from request";
  return data;
}

///打印结果
renderSome() {
  doSomeThing().then((value) {
    print(value);
    ///输出ok from request
  });
}