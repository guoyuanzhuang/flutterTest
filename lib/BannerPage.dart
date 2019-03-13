import 'package:flutter/material.dart';
import './widget/BannerView.dart';

//void main(){
//  runApp(BannerPage());
//}

class BannerPage extends StatefulWidget {
  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {

  PageController controller = PageController();

  var images = [
    "assets/page_guide_one.png",
    "assets/page_guide_two.png",
    "assets/page_guide_three.png",
    "assets/page_guide_four.png"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'banner',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Banner"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              BannerView(
                data: images,
                buildLoopView: (index, data){
                  return Image.asset(images[index], fit: BoxFit.cover);
                },
                onItemClickListener: (index, data){
                  print("index>>>$index" + ", data>>>$data");
                },
              ),
            ],
          ),
        ),

        /*PageView.builder(
          controller: controller,
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index)=> _rendRow(context, index),
        )*/
      ),
    );
  }

  _rendRow(BuildContext context, int index){
    return GestureDetector(
      child: Material(
        elevation: 5.0,
        child: Image.asset(images[index], fit: BoxFit.cover),
      ),
      onTap: (){
        print("onClick>>>$index");
      },
    );
  }
}
