import 'package:flutter/material.dart';
import './IndicatorWidget.dart';
import 'dart:async';

typedef void OnItemClickListener<T>(int index, T itemData);
typedef Widget BuildLoopView<T>(int index, T itemData);

class BannerView<T> extends StatefulWidget {

  final int delayTime; //间隔时间
  final double height; //banner高度
  final List<T> data;

  final OnItemClickListener<T> onItemClickListener;
  final BuildLoopView<T> buildLoopView;

  BannerView({
    Key key,
    @required this.data,
    @required this.buildLoopView,
    this.onItemClickListener,
    this.delayTime = 2000,
    this.height = 200.0
  }) :super(key: key);

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  PageController controller = PageController();
  Timer timer;
  int _index = 0; //当前真实索引

  @override
  void initState() {
    super.initState();
    resetTimer();
  }

  ///重置计时器
  void resetTimer() {
    clearTimer();
    timer = new Timer.periodic(new Duration(milliseconds: widget.delayTime), (Timer timer) {
      if(widget.data.length > 0 && controller != null && controller.page != null) {
        int page = controller.page.toInt() + 1;
//        print("page>>>$page");
        controller.animateToPage(
            page,
            duration: new Duration(milliseconds: 300),
            curve: Curves.linear
        );
      }
    });
  }

  ///清除计时器
  clearTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildBanner(),
        Align(
          alignment: Alignment.bottomCenter,
          child: _renderIndicator(),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return new SizedBox(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      child: new GestureDetector(
        onTapDown: (details) {
          print("onTapDown");
          clearTimer();
        },
        onTapUp: (details) {
          print("onTapUp");
          resetTimer();
        },
        onTapCancel: () {
          print("onTapCancel");
          resetTimer();
        },
        onTap: (){
          print("onTap");
          widget.onItemClickListener(_index, widget.data[_index]);
        },
        child: new PageView.builder(
          controller: controller,
          physics: const PageScrollPhysics(parent: const ClampingScrollPhysics()),
          itemBuilder: (BuildContext context, int index) {
            int position = index % widget.data.length;
//            print("itemBuilder>>>$position");
            return widget.buildLoopView(
                position, widget.data[position]);
          },
          itemCount: 0x7fffffff,
          onPageChanged: (index) {
            setState(() {
              _index = index % widget.data.length;
              print("onPageChanged>>>$_index");
            });
          },
        ),
      ),
    );
  }

  /// indicator widget
  Widget _renderIndicator() {
    return new IndicatorWidget(
      size: widget.data.length,
      currentIndex: _index,
    );
  }

  @override
  void dispose() {
    clearTimer();
    super.dispose();
  }
}
