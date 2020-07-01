import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/cart_model.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/homepage_view.dart';
import 'package:shoppingapp2/widgets/mydrawer.dart';
//import 'package:shoppingapp2/widgets/cart_card.dart';
import 'package:shoppingapp2/widgets/prod_list_widget.dart';

class ShoppingCart extends StatefulWidget {
  static String id = 'cart';
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  num _subTotal = 0.00;

  getAllPrice(QuerySnapshot snapshot) async {
    var docs = await snapshot.documents;
    List list =
        docs.map((document) => Favourites.fromSnapshot(document)).toList();
    list.forEach((document) {
      Favourites fav = document;
      setState(() {
        _subTotal = _subTotal + double.parse(fav.price);
      });
    });
    // product_map = Map.fromIterable(docs,
    //     key: (doc) => doc.documentID,
    //     value: (doc) => Product.fromSnapshot(doc));
  }

  getSubTotal() async {
    final prod_snapshots = await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.sarees))
        .getDocuments();
    getAllPrice(prod_snapshots);
  }

  @override
  void initState() {
    super.initState();
    getSubTotal();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.grey.shade300,
            iconTheme: new IconThemeData(color: Colors.black38),
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 40.0),
                IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.pushNamed(context, HomePage.id);
                    }),
                SizedBox(width: 40.0),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final names = await AuthService().getProds();
                      showSearch(
                          context: context, delegate: ProductSearch(names));
                    }),
                SizedBox(width: 40.0),
              ],
            )),
        endDrawer: MyDrawer(),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Bag',
                  style: TextStyle(
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ))),
            Expanded(
              flex: 6,
              child: MyProdListView(
                uid: Provider.of<AppUser>(context).uid,
                viewType: ViewTypes.listView,
                collection: EnumToString.parse(CollectionTypes.user_cart),
                model: Cart,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.white,
          height: 150.0,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'SubTotal:',
                      style: TextStyle(
                          fontFamily: 'Nexa',
                          color: Colors.black45,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      ' Rs $_subTotal',
                      style: TextStyle(
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black45),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  child: Material(
                    elevation: 5.0,
                    color: Color(myyellow),
                    borderRadius: BorderRadius.circular(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                              fontFamily: 'Nexa',
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
