import 'package:flutter/material.dart';
import 'http/httpRequest.dart';
import 'model/Login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'http/httpUtils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    HttpRequest.login(context, "12345678009", "123456").then((data){
      if(data != null){
        print("登录成功");
        Fluttertoast.showToast(msg: "登录成功");
      }
    });
  }

  getAppPath() async {
    try {
      print('临时目录: ' + (await getTemporaryDirectory()).path);
      //----/data/user/0/com.toly1994.toly/cache
      print('文档目录: ' + (await getApplicationDocumentsDirectory()).path);
      //----/data/user/0/com.toly1994.toly/app_flutter
      print('sd卡目录: ' + (await getExternalStorageDirectory()).path);
      //----/storage/emulated/0
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    getAppPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, semanticLabel: 'back',), onPressed: (){
          print('Click back');
        }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search, semanticLabel: 'search',), onPressed: (){
            print('Click Search');
            HttpRequest.getAppResource(context, "COMMON_CONFIG").then((data){
              print("获取静态资源成功");
              Fluttertoast.showToast(msg: "获取静态资源成功");
            });
            HttpUtils.cleanCookie();
          }),
          IconButton(icon: Icon(Icons.more, semanticLabel: 'more',), onPressed: (){
            print('Click More');
            HttpRequest.getAccountInfo(context).then((data){
              if(data == null){
                print("账户信息失败");
                Fluttertoast.showToast(msg: "账户信息失败");
                return;
              }
              print("-----获取账户信息成功-----");
              Fluttertoast.showToast(msg: "获取账户信息成功");
            });
          }),
          IconButton(icon: Icon(Icons.tune, semanticLabel: 'tune',), onPressed: (){
            print('Click Tune');
            ///post请求
            HttpRequest.checkPhone(context, '18872660007').then((data){
              print("检查手机号");
              Fluttertoast.showToast(msg: "检查手机号");
              if(data == null){
                print("检查手机号失败");
                Fluttertoast.showToast(msg: "检查手机号失败");
                return;
              }
              Login login = Login.fromJson(data);
              print(login.returnCode);
              print(login.result);
              print(login.needRegister);

              print(HttpUtils.getCookie());
            });
          }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times :',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
