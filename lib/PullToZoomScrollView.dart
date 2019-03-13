import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(PullToZoomScrollView());
}

class PullToZoomScrollView extends StatefulWidget {
  @override
  _PullToZoomScrollViewState createState() => _PullToZoomScrollViewState();
}

class _PullToZoomScrollViewState extends State<PullToZoomScrollView> with TickerProviderStateMixin{

  ScrollController scrollController = ScrollController();
  double imageHeight = 200.0;

  //图片回弹动画
  AnimationController controller;
  Animation<double> animation;

  AnimationController rotateController;

  //下拉指示器透明度
  double opacity = 0.0;

  ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  Timer timer;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
    });
    controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    rotateController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PullToZoomScrollView",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              key: _key,
              onNotification: _handleScrollNotification,
              child: NotificationListener<OverscrollIndicatorNotification>(
                /*onNotification: (notification){
                  notification.disallowGlow();
                  return true;
                },*/
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        getViewList(),
                      ),
                    ),
                  ],
//                  controller: scrollController,
//                  physics: scrollPhysics,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Opacity(
                opacity: opacity,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(rotateController),
                  child: Image.asset("assets/ic_loading_sun.png", fit: BoxFit.cover, width: 32.0, height: 32.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    print("_handleScrollNotification");
    if(notification is ScrollStartNotification){
      print("ScrollStartNotification");
    }
    if(notification is ScrollUpdateNotification){
      print("ScrollUpdateNotification>>>${notification.scrollDelta}");
      if(imageHeight > 200){
        imageHeight -= notification.scrollDelta;
        if(imageHeight <= 200.0){
          imageHeight = 200.0;
        }
        setState(() {

        });
      }
    }
    if(notification is ScrollEndNotification){
      print("ScrollEndNotification>>>$imageHeight");
      if(imageHeight >= 250.0){
        setState(() {
          scrollPhysics = NeverScrollableScrollPhysics();
          rotateController.repeat();
        });

        timer = Timer.periodic(Duration(milliseconds: 2000), (timer){
          print("异步回调");
          if (timer != null) {
            timer.cancel();
            timer = null;
          }
          setState(() {
            scrollPhysics = ClampingScrollPhysics();
            rotateController.reset();
          });

          animation = new Tween(begin: imageHeight, end: 200.0).animate(controller)
            ..addListener((){
              setState(() {
                imageHeight = animation.value;
                opacity = 0.0;
              });
            });
          controller.reset();
          controller.forward();
        });
        return false;
      }
      if(imageHeight > 200.0){
        animation = new Tween(begin: imageHeight, end: 200.0).animate(controller)
          ..addStatusListener((state){
            print("$state");
          })
          ..addListener((){
            setState(() {
              imageHeight = animation.value;
              opacity = 0.0;
            });
          });
        controller.reset();
        controller.forward();
      }
      
    }
    if(notification is OverscrollNotification){
      print("OverscrollNotification>>>$imageHeight");
      print("notification.overscroll>>>${notification.overscroll}");
      if(notification.overscroll < 0){
        if(imageHeight <= 250.0){
          imageHeight += notification.overscroll.abs();
          opacity = (imageHeight - 200.0) / 50.0;
          if(opacity >= 1.0){
            opacity = 1.0;
          }
          print("opacity>>>$opacity");
          setState(() {

          });
        }
      }
    }
    return false;
  }

  getViewList() {
    List<Widget> widgets = List<Widget>();
    final Container container = Container(
      height: imageHeight,
      child: Stack(
        children: <Widget>[
          Image.asset("assets/scroll_header.png", fit: BoxFit.cover, height: double.infinity),
          Column(
            children: <Widget>[
              Text("header text", style: TextStyle(fontSize: 40.0),),
              Text("header text", style: TextStyle(fontSize: 40.0),),
              Text("header text", style: TextStyle(fontSize: 40.0),),
              Text("header text", style: TextStyle(fontSize: 40.0),),
            ],
          ),
        ],
      ),  //height: imageHeight
    );

    widgets.add(container);
    for (int i = 0; i < 10; i++) {
      widgets.add(Text("Text $i"));
    }

    return widgets;
  }
}