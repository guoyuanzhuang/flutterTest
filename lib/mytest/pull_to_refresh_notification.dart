import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// The signature for a function that's called when the user has dragged a
/// [PullToRefreshNotification] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [PullToRefreshNotification.onRefresh].
typedef RefreshCallback = Future<bool> Function();

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum RefreshIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
  error, //refresh failed
}

class PullToRefreshNotification extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  const PullToRefreshNotification({
    Key key,
    @required this.child,
    @required this.onRefresh,
    this.color,
    this.pullBackOnRefresh: false,
    this.maxDragOffset,
    this.notificationPredicate = defaultNotificationPredicate,
    this.armedDragUpCancel = true,
  })  : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        super(key: key);

  //Dragged far enough that an up event will run the onRefresh callback.
  //when use drag up,whether should cancel refresh
  final bool armedDragUpCancel;

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The progress indicator's foreground color. The current theme's
  /// /// [ThemeData.accentColor] by default. only for android
  final Color color;

  //whether start pull back animation when refresh.
  final bool pullBackOnRefresh;

  //the max drag offset
  final double maxDragOffset;

  //use in case much ScrollNotification from child
  final bool Function(ScrollNotification notification) notificationPredicate;

  @override
  PullToRefreshNotificationState createState() =>
      PullToRefreshNotificationState();
}

/// Contains the state for a [PullToRefreshNotification]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class PullToRefreshNotificationState extends State<PullToRefreshNotification>
    with TickerProviderStateMixin<PullToRefreshNotification> {
  final _onNoticed =
      new StreamController<PullToRefreshScrollNotificationInfo>.broadcast();
  Stream<PullToRefreshScrollNotificationInfo> get onNoticed =>
      _onNoticed.stream;

  AnimationController _positionController;
  AnimationController _scaleController;
  Animation<double> _scaleFactor;
  Animation<double> _value;
  Animation<Color> _valueColor;

  AnimationController _pullBackController;
  Animation<double> _pullBackFactor;

  RefreshIndicatorMode _mode;
  RefreshIndicatorMode get _refreshIndicatorMode => _mode;
  set _refreshIndicatorMode(value) {
    if (_mode != value) {
      _mode = value;
      _onInnerNoticed();
    }
  }

  Future<void> _pendingRefreshFuture;
  bool _isIndicatorAtTop;
  double _dragOffset;
  double get _notificationDragOffset => _dragOffset;
  set _notificationDragOffset(double value) {
    if (value != null) {
      value = math.max(
          0.0, math.min(value, widget.maxDragOffset ?? double.maxFinite));
    }
    if (_dragOffset != value) {
      _dragOffset = value;
      _onInnerNoticed();
    }
  }

  static final Animatable<double> _threeQuarterTween =
      Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);

    _value = _positionController.drive(
        _threeQuarterTween); // The "value" of the circular progress indicator during a drag.

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);

    _pullBackController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
              begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
              end: (widget.color ?? theme.accentColor).withOpacity(1.0))
          .chain(CurveTween(
              curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    _pullBackController.dispose();
    _onNoticed.close();
    super.dispose();
  }

  double maxContainerExtent = 0.0;

  ///处理滑动通知
  bool _handleScrollNotification(ScrollNotification notification) {
    print("_handleScrollNotification");
    var result = _innerhandleScrollNotification(notification);
    return result;
  }

  ///内部处理滑动通知?
  bool _innerhandleScrollNotification(ScrollNotification notification) {
//    print("_innerhandleScrollNotification");
    if (!widget.notificationPredicate(notification)) return false;
    if (notification.depth != 0) {
      maxContainerExtent = math.max(
          notification.metrics.viewportDimension, this.maxContainerExtent);
      print("maxContainerExtent>>>$maxContainerExtent");
    }
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _refreshIndicatorMode == null &&
        _start(notification.metrics.axisDirection)) {
      _mode = RefreshIndicatorMode.drag;
      print("ScrollStartNotification");
      return false;
    }
    bool indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
//      print("indicatorAtTopNow != _isIndicatorAtTop");
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed)
        _dismiss(RefreshIndicatorMode.canceled);
    } else if (notification is ScrollUpdateNotification) {
      print("ScrollUpdateNotification");
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          if (_refreshIndicatorMode == RefreshIndicatorMode.armed &&
              !widget.armedDragUpCancel) {
            _show();
          } else {
            _dismiss(RefreshIndicatorMode.canceled);
          }
        } else {
          _notificationDragOffset -= notification.scrollDelta;
          _checkDragOffset(maxContainerExtent);
        }
      }
      if (_refreshIndicatorMode == RefreshIndicatorMode.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      print("_refreshIndicatorMode>>>$_refreshIndicatorMode");
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed) {
        print("notification.overscroll>>>${notification.overscroll}");
        _notificationDragOffset -= notification.overscroll / 2.0;
        print("OverscrollNotification>>>$_notificationDragOffset");
        print("maxContainerExtent>>>$maxContainerExtent");
        _checkDragOffset(maxContainerExtent);
      }

    } else if (notification is ScrollEndNotification) {
      print("ScrollEndNotification");
      switch (_refreshIndicatorMode) {
        case RefreshIndicatorMode.armed:
          _show();
          break;
        case RefreshIndicatorMode.drag:
          _dismiss(RefreshIndicatorMode.canceled);
          break;
        default:
          // do nothing
          break;
      }
    }
    return false;
  }

  ///处理overscroll下拉光晕不显示
  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
//    print("_handleGlowNotification");
    if (notification.depth != 0 || !notification.leading) return false;
    if (_refreshIndicatorMode == RefreshIndicatorMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  ///开始拖动？
  bool _start(AxisDirection direction) {
    assert(_refreshIndicatorMode == null);
    assert(_isIndicatorAtTop == null);
    assert(_notificationDragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    print("drag start>>>$_isIndicatorAtTop");
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    _pullBackFactor?.removeListener(pullBackListener);
    _pullBackController.reset();
    return true;
  }

  ///检查拖动偏移量
  void _checkDragOffset(double containerExtent) {
    assert(_refreshIndicatorMode == RefreshIndicatorMode.drag ||
        _refreshIndicatorMode == RefreshIndicatorMode.armed);
    double newValue = _notificationDragOffset /
        (containerExtent * _kDragContainerExtentPercentage);
    if (widget.maxDragOffset != null) {
      newValue = _notificationDragOffset / widget.maxDragOffset;
    }
    if (_refreshIndicatorMode == RefreshIndicatorMode.armed)
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    _positionController.value =
        newValue.clamp(0.0, 1.0); // this triggers various rebuilds

    if (_refreshIndicatorMode == RefreshIndicatorMode.drag &&
        _valueColor.value.alpha == 0xFF)
      _refreshIndicatorMode = RefreshIndicatorMode.armed;
  }

  /// 隐藏刷新指示器
  Future<void> _dismiss(RefreshIndicatorMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == RefreshIndicatorMode.canceled ||
        newMode == RefreshIndicatorMode.done);
    _refreshIndicatorMode = newMode;
    switch (_refreshIndicatorMode) {
      case RefreshIndicatorMode.done:
        await _scaleController.animateTo(1.0,
            duration: _kIndicatorScaleDuration);
        break;
      case RefreshIndicatorMode.canceled:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _refreshIndicatorMode == newMode) {
      _notificationDragOffset = null;
      _isIndicatorAtTop = null;
      _refreshIndicatorMode = null;
    }
  }

  ///显示刷新进度指示器
  void _show() {
    assert(_refreshIndicatorMode != RefreshIndicatorMode.refresh);
    assert(_refreshIndicatorMode != RefreshIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _refreshIndicatorMode = RefreshIndicatorMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _refreshIndicatorMode == RefreshIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        // Show the indeterminate progress indicator.
        _refreshIndicatorMode = RefreshIndicatorMode.refresh;

        final Future<bool> refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.then((bool success) {
          if (mounted &&
              _refreshIndicatorMode == RefreshIndicatorMode.refresh) {
            completer.complete();
            if (success) {
              _dismiss(RefreshIndicatorMode.done);
            } else
              _refreshIndicatorMode = RefreshIndicatorMode.error;
          }
        });
      }
    });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [PullToRefreshNotification] with a [GlobalKey<RefreshIndicatorState>]
  /// makes it possible to refer to the [PullToRefreshNotificationState].
  ///
  /// The future returned from this method completes when the
  /// [PullToRefreshNotification.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of any
  /// actual scroll view. It defaults to showing the indicator at the top. To
  /// show it at the bottom, set `atTop` to false.
  Future<void> show({bool atTop = true}) {
    if (_refreshIndicatorMode != RefreshIndicatorMode.refresh &&
        _refreshIndicatorMode != RefreshIndicatorMode.snap) {
      if (_refreshIndicatorMode == null)
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );
    return child;
  }

  ///内部通知？
  void _onInnerNoticed() {
    if ((_dragOffset != null && _dragOffset > 0.0) &&
        ((_refreshIndicatorMode == RefreshIndicatorMode.done &&
                !widget.pullBackOnRefresh) ||
            (_refreshIndicatorMode == RefreshIndicatorMode.refresh &&
                widget.pullBackOnRefresh) ||
            _refreshIndicatorMode == RefreshIndicatorMode.canceled)) {
      _pullBack();
      return;
    }

    if (_pullBackController.isAnimating) {
      pullBackListener();
    } else {
      _onNoticed.add(PullToRefreshScrollNotificationInfo(_refreshIndicatorMode,
          _notificationDragOffset,this));  // _getRefreshWidget(),
    }
  }

  ///下拉回弹监听
  void pullBackListener() {
    //print(_pullBackFactor.value);
    if (_dragOffset != _pullBackFactor.value) {
      _dragOffset = _pullBackFactor.value;
      _onNoticed.add(PullToRefreshScrollNotificationInfo(
          _refreshIndicatorMode, _dragOffset, this));  // _getRefreshWidget(),
      if (_dragOffset == 0.0) {
        _dragOffset = null;
      }
    }
  }

  ///下拉回弹
  void _pullBack() {
    final Animatable<double> _pullBackTween =
        Tween<double>(begin: _notificationDragOffset ?? 0.0, end: 0.0);
    _pullBackFactor?.removeListener(pullBackListener);
    _pullBackController.reset();
    _pullBackFactor = _pullBackController.drive(_pullBackTween);
    _pullBackFactor.addListener(pullBackListener);
    _pullBackController.animateTo(1.0,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }
}

//return true so that we can handle inner scroll notification
bool defaultNotificationPredicate(ScrollNotification notification) {
  return true;
}

class PullToRefreshContainer extends StatefulWidget {
  final PullToRefreshContainerBuilder builder;
  PullToRefreshContainer(this.builder);
  @override
  _PullToRefreshContainerState createState() => _PullToRefreshContainerState();
}

class _PullToRefreshContainerState extends State<PullToRefreshContainer> {
  @override
  Widget build(BuildContext context) {
    PullToRefreshNotificationState ss = context
        .ancestorStateOfType(TypeMatcher<PullToRefreshNotificationState>());
    return StreamBuilder<PullToRefreshScrollNotificationInfo>(
      builder: (c, s) {
        return widget.builder(s.data);
      },
      stream: ss?.onNoticed,
    );
  }
}

typedef PullToRefreshContainerBuilder = Widget Function(
    PullToRefreshScrollNotificationInfo info);

class PullToRefreshScrollNotificationInfo {
  final RefreshIndicatorMode mode;
  final double dragOffset;
  final PullToRefreshNotificationState pullToRefreshNotificationState;
  PullToRefreshScrollNotificationInfo(this.mode, this.dragOffset, this.pullToRefreshNotificationState);  // this.refreshWiget,
}