import 'package:flutter/material.dart';

//void main() => runApp(new MyApp());

/**
* flutter widget 采用现代响应式框架，用widget构建ui。
* widget 描述了他们的视图再给定其当前配置和状态时应该看起来想什么。
* 当widget的状态发生变化时，widget 会重新构建ui，flutter 会对比前后发生的不同，已确定底层渲染树从一个状态到
* 下一个状态所需的最小更改
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new Text(
              'Hello World',
            textDirection: TextDirection.ltr,

          ),
        ),
      ),
    );
  }
}


class MyAppBar extends StatelessWidget {
  MyAppBar({this.title});

  // widget 子类中的字段往往都会定义为 final

final Widget title;

@override
  Widget build(BuildContext context) {
  return new Container(
    height: 88.0,// 单位是逻辑上的像素
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: new BoxDecoration(color: Colors.blue[500]),
    // row 是水平方向的线性布局
    child: new Row(
      // 列表项的类型是 <Widget>
      children: <Widget>[
        new IconButton(icon: new Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null,//null 会 禁用button
        ),
        new Expanded(
            child: title,
        ),
        new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'search',
            onPressed: null
        ),
      ],

    ),
  );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // material 是 ui 呈现的一张纸
    return new Material(
      // column is 垂直方向的线性布局
      child: new Column(
        children: <Widget>[
          new MyAppBar(
          title: new Text(
            'Example title',
            style: Theme.of(context).primaryTextTheme.title,
          ),
      ),
          new Expanded(
              child: new Center(
                child: new Text('Hello , world!'),
              ),
          ),
        ],
      ),
    );
  }
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // scaffold 是material 中主要的布局组件
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.menu), 
            tooltip: 'Navigation menu',
            onPressed: null,
        ),
        title: new Text('Example title'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null,
          )
        ],
      ),
      body: new Center(
//        child: new Text('hello, world! longge'),
        child: new MyButton(),

      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: 'Add',
          child: new Icon(Icons.add),
          onPressed: null,
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        print('myButton was tapped!');
      },
      child: new Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: new Center(
          child: new Text('Engage'),
        ),
      ),
    );
  }
}

class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallBack(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
  : product = product,
  super(key: new ObjectKey(product));
  
  final Product product;
  final bool inCart;
  final CartChangedCallBack onCartChanged;
  
  Color _getColor(BuildContext context) {
    return inCart ? Colors.black45 : Theme.of(context).primaryColor;
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
      onTap: (){
        onCartChanged(product, !inCart);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(product.name[0]),
      ),
      title: new Text(product.name, style: _getTextStyle(context),),
    );
  }
}

class ShoppingList extends StatefulWidget {

  ShoppingList({Key key, this.products}) : super(key: key);
  final List<Product> products;

  @override
  _ShoppingListState createState() => _ShoppingListState();

}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();
  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping list'),
      ),
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


//void main() {
//  runApp(new MaterialApp(
//    title: 'My app',
//    home: new TutorialHome(),
//
//  ));
//}

void main() {
  runApp(new MaterialApp(
    title: 'Shopping App',
    home: new Stack(
      children: <Widget>[
        new ShoppingList(
          products: <Product>[
            new Product(name: 'Eggs'),
            new Product(name: 'fFloure'),
            new Product(name: 'Chocolate chipsss'),
          ],
        ),
        new Center(child: new CircularProgressIndicator()),
        new Center(
          child: new Image.network(
            'https://github.com/flutter/plugins/raw/master/packages/video_player/doc/demo_ipod.gif?raw=true',
          ),
        ),
      ],
    ),
  ));
}
