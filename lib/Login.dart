import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'theme/colors.dart';

//void main() => runApp(Login());

//登录页面
class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new LoginPage(),
      theme: _buildThemeData(),
    );
  }
}

ThemeData _buildThemeData(){
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink300,
    buttonTheme: ButtonThemeData(
      buttonColor: kShrinePink300
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
  );

}

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0,),
            Column(
              children: <Widget>[
                Image.asset('assets/logo.png'),
                SizedBox(height: 16.0),
                Text('点点搜财'),
              ],
            ),
            SizedBox(height: 120.0),
            TextField(
              decoration: InputDecoration(
//                filled: true,
                labelText: 'Username',
              ),
              controller: _usernameController,
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Password'
              ),
              obscureText: true,
              controller: _passwordController,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: (){
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('LOGIN'),
                  elevation: 8.0,
                  onPressed: (){
//                    Navigator.pop(context);
                    Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) {
                        return new HomePage();
                      }),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}