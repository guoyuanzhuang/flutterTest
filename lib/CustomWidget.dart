import 'package:flutter/material.dart';

//void main() => runApp(new CustomWidget());


class CustomWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //自定义页面效果
    /*return new MaterialApp(
      title: 'My Flutter App',
      home: new MyScaffold(),
    );*/
    //系统页面效果
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
        body:
        new Center(
            child: new Text('Hello World'),
        ),
        /*new Column(
          //主轴居中,即是竖直向居中
          mainAxisAlignment: MainAxisAlignment.center,
          //大小按照最小显示
          mainAxisSize : MainAxisSize.max,
          //横向也居中
          crossAxisAlignment : CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Button'),
            ),
            //flex默认为1
            new Expanded(
              child: RaisedButton(
                child: Text('Button'),
                color: Colors.blue,
              ),
              flex: 2,
            ),
            new Expanded(
              child: RaisedButton(
                child: Text('Button'),
                color: Colors.blue,
              ),
            ),
          ],
        ),*/
        floatingActionButton: new FloatingActionButton(onPressed: null, child: new Icon(Icons.add),),
      ),
    );
  }
}

//自定义AppBar
class MyAppBar extends StatelessWidget{

  final Widget title;

  MyAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 56.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: new BoxDecoration(color: Colors.deepOrange),
      child: new Row(   //水平方向布局
        children: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: null, tooltip: 'Navigation Menu',),
          new Expanded(child: new Center(child: title,),),
          new IconButton(icon: new Icon(Icons.search), onPressed: null, tooltip: 'Search',),
        ],
      ),
    );
  }

}

//自定义页面框架
class MyScaffold extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //原料 画布
    return new Material(
      child: new Column(
        children: <Widget>[
          new MyAppBar(
            title: new Text(
              'MyAppBar Title Title',
              style: Theme.of(context).primaryTextTheme.title,
              maxLines: 1,
            ),
          ),
          new Expanded(
            child: new Center(
              child: new Text('Hello World !!!'),
            ),
          )
        ],
      ),
    );
  }

}




