import 'package:flutter/material.dart';
import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:intl/intl.dart';
import 'theme/colors.dart';

void main() => runApp(new HomePage());

ThemeData _buildThemeData(){
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
  );
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: _buildThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
//          leading: IconButton(icon: Icon(Icons.menu, semanticLabel: 'menu',), onPressed: (){
//            print('Click Menu');
//          }),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, semanticLabel: 'back',), onPressed: (){
            print('Click back');
            Navigator.pop(context);
          }),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search, semanticLabel: 'search',), onPressed: (){
              print('Click Search');
            }),
            IconButton(icon: Icon(Icons.more, semanticLabel: 'more',), onPressed: (){
              print('Click More');
            }),
            IconButton(icon: Icon(Icons.tune, semanticLabel: 'tune',), onPressed: (){
              print('Click Tune');
            }),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 10.0 / 11.0,
          children: _buildProductCard(context),//_buildCards(10),
        ),
      ),
    );
  }


  List<Card> _buildCards(int count){
    List<Card> cards = List.generate(count, (int index) => Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 10.0 / 6.0,
            child: Image.asset('packages/shrine_images/0-0.jpg'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Title'),
                SizedBox(height: 8.0),
                Text('Secondary Text'),
              ],
            ),
          ),
        ],
      ),
    ));
    return cards;
  }

  List<Card> _buildProductCard(BuildContext context){
    List<Product> products = ProductsRepository.loadProducts(Category.all);
    if(products == null || products.isEmpty){
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());
//    foreach(Product product : products){ }
    //相当于java foreach
    return products.map((product){
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 10.0 / 6.0,
              child: Image.asset(product.assetName, package: product.assetPackage, fit: BoxFit.fitWidth,),  //
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text( product.name, style: theme.textTheme.title, maxLines: 1,),
                  SizedBox(height: 8.0),
                  Text(formatter.format(product.price), style: theme.textTheme.body2,),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();

  }

}