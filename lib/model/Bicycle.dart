import 'dart:math';

//自行车
class Bicycle{
 /* java
 Bicycle(int cadence, int speed, int gear){
    this.cadence = cadence;
    this.speed = speed;
    this.gear = gear;
  }*/

  Bicycle(this.cadence, this.speed);
//  Bicycle({this.cadence = 0, this.speed = 0});

  int cadence;
  int speed;
  int gear;
  int _test;
  int get test => _test;
  void setTest(int test){
    this._test = test;
  }

  @override
  String toString() => 'Bicycle: $cadence, $speed, $gear mph';
}

//矩形
class Rectangle {

  Rectangle({this.origin = const Point(0, 0), this.width = 0, this.height = 0});

  int width;
  int height;
  Point origin;

  @override
  String toString() => 'Origin: (${origin.x}, ${origin.y}), width: $width, height: $height';
}


void main(){
  var bike = Bicycle(1, 2);
  print(bike);

  var rectangle = new Rectangle(origin: const Point(100, 100));

  print(Rectangle(origin: const Point(10, 20), width: 100, height: 200));
  print(Rectangle(origin: const Point(10, 10)));
  print(Rectangle(width: 200));
  print(Rectangle());

  print(rectangle);

}