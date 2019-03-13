import 'package:flutter/material.dart';
import 'BannerPage.dart';
import 'Login.dart';
import 'CustomWidget.dart';
import 'HomePage.dart';
void main(){
  runApp(BottomNavigationPage());
}

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> pages = List<Widget>();

  @override
  void initState() {
    super.initState();
    pages
      ..add(new BannerPage())
      ..add(new Login())
      ..add(new CustomWidget())
      ..add(new HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNavigation',
      home: Scaffold(
        appBar: AppBar(
          title: Text("BottomNavigation"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _bottomNavigationColor),
              title: Text("Home", style: TextStyle(color: _bottomNavigationColor)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.email, color: _bottomNavigationColor),
              title: Text("Email", style: TextStyle(color: _bottomNavigationColor)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages, color: _bottomNavigationColor),
              title: Text("Pages", style: TextStyle(color: _bottomNavigationColor)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airplay, color: _bottomNavigationColor),
              title: Text("Airplay", style: TextStyle(color: _bottomNavigationColor)),
            ),
          ],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,

          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: pages[_currentIndex],
      ),
    );
  }
}
