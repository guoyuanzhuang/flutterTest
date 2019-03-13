import 'package:flutter/material.dart';

void main() => runApp(new CPage());

//手势处理
class CPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'The Flutter App',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('The Flutter App'),
          leading: new IconButton(icon: new Icon(Icons.menu), onPressed: null, tooltip: 'Navigation Menu',),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.search), onPressed: null, tooltip: 'Search',)
          ],
        ),
        body: new Center(
            child: new MyButton(),
        ),
        floatingActionButton: new FloatingActionButton(onPressed: null, child: new Icon(Icons.add),),
      ),
    );
  }
}

class MyButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          color: Colors.blue[500],
          borderRadius: new BorderRadius.circular(5.0)
        ),
        child: new Center(
          child: new Text('Button'),
        ),
      ),
      onTap: (){
        print('点击');
      },
      onLongPress: (){
        print('长按');
      },
      onDoubleTap: (){
        print('双击');
      },
    );
  }
  
}