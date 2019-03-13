import 'package:flutter/material.dart';

void main() => runApp(new DPage());

//有状态的Widget
class DPage extends StatelessWidget{
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
            child: new Counter(),
        ),
        floatingActionButton: new FloatingActionButton(onPressed: null, child: new Icon(Icons.add),),
      ),
    );
  }
}

class Counter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new CounterState();
  }
}

class CounterState extends State<Counter>{

  int count = 0;

  void autoAdd(){
    setState(() {
      count++;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new RaisedButton(
          onPressed: autoAdd,
          child: new Text('自增'),
        ),
        new Text('Count: $count')
      ],
    );
  }

}



