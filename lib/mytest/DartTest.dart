import 'dart:math';

void main(){
  var list = List<String>();
  list.add("aa");
  list.add("bb");
  list.add("cc");

  print(list);

  ///list转换
  Iterable iterable = list.map((str){
      return str + "_add";
    });
  List newList = list.map((str){
    return str + "_add";
  }).toList();//.toList()
  print(newList);

  ///循环遍历
  for (var value in list) {
    print(value);
  }
  for (int i = 0; i < list.length; i++) {
    print(list[i]);
  }
  list.forEach((str){
    print(str);
  });
}
