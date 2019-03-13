import 'dart:math';
import '../model/Bicycle.dart';

abstract class Shape{
  num get area;  //抽象方法 => java: public num area();

  factory Shape(String type) {
    if (type == 'circle') return Circle(2);
    if (type == 'square') return Square(2);
    throw 'Can\'t create $type.';
  }
}

class Circle implements Shape{
  num radius;
  Circle(this.radius);

  @override
  num get area => pi * pow(radius, 2);

  @override
  String toString() => 'radius: $radius';
}

//接口实现
class CircleMock implements Circle {
  @override
  num radius;

  @override
  num get area => null;
}

//Shape shapeFactory(String type) {
//  if (type == 'circle') return Circle(2);
//  if (type == 'square') return Square(2);
//  throw 'Can\'t create $type.';
//}

class Square implements Shape{
  num side;
  Square(this.side);

  @override
  num get area => pow(side, 2);

  @override
  String toString() => 'side: $side';
}

String scream(int length) => "A${'a' * length}h!";

void main(){
  print('factory model');

//  final values = [1, 2, 3, 5, 10, 50];
//  for (var length in values) {
//    print(scream(length));
//  }
//  values.map(scream).forEach(print);
//  values.skip(3).take(3).map(scream).forEach(print);

  var circle = Circle(2);
  var square = Square(2);

  print(circle.area);
  print(square.area);

//  print(shapeFactory('circle'));
//  print(shapeFactory('square'));

  var circle_ = Shape('circle');
  var square_ = Shape('square');
  print(circle_.area);
  print(square_.area);

  //测试私有方法
  var bicycle = Bicycle(10, 20);
  bicycle.setTest(30);
  print(bicycle.test);
}




