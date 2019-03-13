import 'package:flutter/material.dart';

///Banner指示器
class IndicatorWidget extends StatelessWidget {
  final Widget indicatorNormal;
  final Widget indicatorSelected;
  final double indicatorMargin;
  final int size;
  final int currentIndex;

  IndicatorWidget({
    Key key,
    this.size,
    this.currentIndex,
    this.indicatorNormal,
    this.indicatorSelected,
    this.indicatorMargin = 5.0,
  })  : assert(indicatorMargin != null),
        assert(size != null && size > 0),
        assert(currentIndex != null && currentIndex >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return this._renderIndicator(context);
  }

  ///indicator container
  Widget _renderIndicator(BuildContext context) {
    Widget smallContainer = new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: _renderIndicatorTag(),
      ),
    );

    ///default implement
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Opacity(
        opacity: 0.5,
        child: new Container(
          height: 25,
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.black45,
          alignment: Alignment.center,
          child: smallContainer,
        ),
      ),
    );
  }

  ///generate every indicator item
  List<Widget> _renderIndicatorTag() {
    List<Widget> indicators = [];
    final int len = this.size;
    Widget selected = this.indicatorSelected ?? generateIndicatorItem(normal: false);
    Widget normal = this.indicatorNormal ?? generateIndicatorItem(normal: true);

    for (var index = 0; index < len; index++) {
      indicators.add(index == this.currentIndex ? selected : normal);
      if (index != len - 1) {
        indicators.add(new SizedBox(
          width: this.indicatorMargin,
        ));
      }
    }
    return indicators;
  }

  Widget generateIndicatorItem({bool normal = true, double indicatorSize = 8.0}) {
    return new Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: normal ? Colors.white : Colors.red,
      ),
    );
  }
}
