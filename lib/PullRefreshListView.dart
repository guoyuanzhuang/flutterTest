import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
  title: 'PullRefresh ListView',
  home: new PullRefreshListView(),
));

class PullRefreshListView extends StatefulWidget {
  @override
  _PullRefreshListViewState createState() => _PullRefreshListViewState();
}

class _PullRefreshListViewState extends State<PullRefreshListView> {
  int pageSize = 15;
  int pageNO = 0;
  bool isLoadingMore = true;  //是否加载更多
  bool isLoading = false;  //是否加载中
  bool isLoadMoreEnd = false;  //是否加载完毕

  List<int> items = List.generate(15, (int index) => index);//生成20个数字，index索引，=>索引对应的值
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        print('滑动到底部了');
        if(pageNO == 3){
          setState(() {
            isLoadMoreEnd = true;
          });
          return;
        }
        _getLoadMore();
      }
    });
  }

  ///加载更多数据
  _getLoadMore() async {
    print('加载更多数据');
    if(!isLoading){
      ///build 加载更多布局
      setState(() {
        pageNO++;
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 3), (){
        List<int> datas = startHttpRequest(pageSize, pageNO);
        setState(() {
          items.addAll(datas);
          isLoading = false;
        });
      });
    }
  }

  ///模拟http请求数据
  startHttpRequest(int pageSize, int pageNO){
    print('pageSize>>$pageSize, pageNO>>$pageNO');
    List<int> datas = List.generate(pageSize, (int index) => index);
    return datas;
  }

  ///加载更多布局
  Widget _buildLoadText(String text) {
    return Container(child:  Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Text(text),
      ),
    ),color: Colors.white70,);
  }

  ///加载更多布局
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoadingMore ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PullRefresh ListView'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Colors.deepOrange,
        backgroundColor: Colors.amber,
        child: ListView.builder(
          controller: scrollController,
          itemCount: items.length + 1,  ///新增坑位留给更多布局
          itemBuilder: (context, index){
//            if (index.isOdd) return new Divider();
            int newIndex = index + 1;
            if(index == items.length){
              if(isLoadMoreEnd){
                return _buildLoadText('没有更多数据');
              }else{
                return _buildProgressIndicator();
              }
            }else{
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('item $newIndex'),
                  ),
                  Divider(),
                ],
              );
            }
          },
        ),
        onRefresh: _onRefreshData,
      )
    );
  }

  ///下拉刷新数据
  Future<Null> _onRefreshData() async{
    await Future.delayed(Duration(seconds: 2), (){
      print('onRefresh');
      setState(() {
        items.clear();
        items = List.generate(30, (i) => i);
      });
      return null;
    });
  }
}
