import 'package:flutter/material.dart';

void main() => runApp(new ShopCar());

//有状态的Widget
class ShopCar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'The Flutter App',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('The Flutter App'),
          leading: new IconButton(icon: new Icon(Icons.menu), onPressed: null, tooltip: 'Navigation Menu',),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.search), onPressed: null, tooltip: 'Search',)
          ],
        ),
        body: new ShoppingList(
          products: <Product>[
            new Product(name: 'Eggs'),
            new Product(name: 'Flour'),
            new Product(name: 'Chocolate chips'),
            new Product(name: 'Eggs'),
            new Product(name: 'Flour'),
            new Product(name: 'Chocolate chips'),
            new Product(name: 'Eggs'),
            new Product(name: 'Flour'),
            new Product(name: 'Chocolate chips'),
            new Product(name: 'Eggs'),
            new Product(name: 'Flour'),
            new Product(name: 'Chocolate chips'),
            new Product(name: 'Eggs'),
            new Product(name: 'Flour'),
            new Product(name: 'Chocolate chips'),
          ],
        ),
        floatingActionButton: new FloatingActionButton(onPressed: null, child: new Icon(Icons.add),),
      ),
    );
  }
}


class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, inCart, onCartChanged})
      : product = product,
        inCart = inCart,
        onCartChanged = onCartChanged;
//        super(key: new ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        onCartChanged(product, !inCart);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(product.name[0]),
      ),
      title: new Text(product.name, style: _getTextStyle(context)),
    );
  }
}



class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => new _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When user changes what is in the cart, we need to change _shoppingCart
      // inside a setState call to trigger a rebuild. The framework then calls
      // build, below, which updates the visual appearance of the app.

      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Shopping List'),
//      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return new ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}




