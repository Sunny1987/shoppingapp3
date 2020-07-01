import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/views/homepage_view.dart';
import 'package:shoppingapp2/views/product_pic_closeup.dart';
import 'package:shoppingapp2/widgets/mydrawer.dart';

class ProductDetailsPage extends StatefulWidget {
  static String id = 'productdetails';

  final List<dynamic> imageList;
  final String name;
  final String price;
  final bool isFav;
  final String description;
  final String discount;
  final MainService model;
  final AppUser user;
  final Map<String, Favourites> map;
  final String docID;
  final String category;
  final Map<String, Product> prod_map;

  ProductDetailsPage(
      {this.imageList,
      this.name,
      this.price,
      this.isFav,
      this.description,
      this.model,
      this.user,
      this.map,
      this.docID,
      this.category,
      this.prod_map,
      this.discount});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> tween;
  int _quantity = 0;
  bool _isFav;
  String docId = '';
  num _count = 0;
  bool _status = false;
  bool _isUploading = false;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFav;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    CurvedAnimation _curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    tween = Tween<double>(begin: 300, end: 0).animate(_curve)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getUserCartCount(
    QuerySnapshot snapshot,
    AppUser user,
  ) async {
    var docs = await snapshot.documents;
    List list =
        docs.map((document) => Favourites.fromSnapshot(document)).toList();
    return list.length;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    AppUser user = Provider.of<AppUser>(context);
    final snapshot = await Firestore.instance
        .collection('user_cart')
        .where('id', isEqualTo: '${user.uid}')
        .getDocuments();
    num count = await getUserCartCount(snapshot, user);
    setState(() {
      _count = count;
    });
    print('cart count: $_count');
  }

  @override
  Widget build(BuildContext context) {
    // _isFav = widget.isFav;
    //EnumToString.parse(Categories.Top)
    pages = [
      Container(),
    ];
    AppUser user = Provider.of<AppUser>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey.shade300,
          iconTheme: new IconThemeData(color: Colors.black38),
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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

              Stack(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.pushNamed(context, ShoppingCart.id);
                      }),
                  Positioned(
                    right: 7,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Color(myyellow),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_count',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Nexa',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )

              // IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
              //    Navigator.pushNamed(context, ShoppingCart.id);
              // }),
            ],
          ),

          //IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ),
        endDrawer: MyDrawer(),
        body: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductCloseUp()));
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageList[0]),
                          fit: BoxFit.cover),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          // SizedBox(
                          //   height: 20,
                          // ),

                          Container(
                            width: double.infinity,
                            height: 300.0,
                            child: Carousel(
                              boxFit: BoxFit.cover,
                              autoplay: false,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1000),
                              dotSize: 4.0,
                              dotIncreasedColor: Color(myyellow),
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.bottomCenter,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,
                              images: widget.imageList
                                  .map((url) => Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                      ))
                                  .toList(),
                            ),
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 300.0,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         image: NetworkImage(widget.imageList[0]),
                          //         fit: BoxFit.cover),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: <Widget>[
                          //       Padding(
                          //         padding: const EdgeInsets.only(right: 20.0),
                          //         child: Material(
                          //           elevation: 8.0,
                          //           borderRadius: BorderRadius.circular(30.0),
                          //           child:
                          //IconButton(
                          //               icon: _isFav
                          //                   ? Icon(
                          //                       Icons.favorite,
                          //                       color: Color(myyellow),
                          //                     )
                          //                   : Icon(
                          //                       Icons.favorite_border,
                          //                       color: Color(myyellow),
                          //                     ),
                          //               onPressed: () {
                          //                 // setState(() {
                          //                 //   _isFav = !_isFav;
                          //                 //   widget.map.forEach((key, value) {
                          //                 //     if (value.image == widget.image) {
                          //                 //       docId = key;
                          //                 //     }
                          //                 //   });

                          //                 //   widget.model.firestoreAction(
                          //                 //       _isFav,
                          //                 //       docId,
                          //                 //       widget.user.uid,
                          //                 //       widget.name,
                          //                 //       widget.description,
                          //                 //       widget.price,
                          //                 //       widget.discount,
                          //                 //       widget.image);
                          //                 // });
                          //               }),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 100,
                          // ),
                          Expanded(
                            //flex: 4,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: tween.value,
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(80.0),
                                          //topRight: Radius.circular(20.0)
                                        )),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text('${widget.name}',
                                                    style: TextStyle(
                                                        fontFamily: 'Nexa',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text('${widget.price}',
                                                    style: TextStyle(
                                                        fontFamily: 'Nexa',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Material(
                                                    elevation: 8.0,
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    child: IconButton(
                                                        icon: Icon(
                                                          _isFav
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color:
                                                              Color(myyellow),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isFav = !_isFav;
                                                            if (widget.map !=
                                                                null) {
                                                              widget.map
                                                                  .forEach((key,
                                                                      value) {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget.imageList[
                                                                        0]) {
                                                                  docId = key;
                                                                }
                                                              });
                                                            }
                                                            if (widget.map ==
                                                                null) {
                                                              widget.prod_map
                                                                  .forEach((key,
                                                                      value) {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget.imageList[
                                                                        0]) {
                                                                  docId = key;
                                                                }
                                                              });
                                                            }
                                                          });
                                                          widget.model
                                                              .firestoreAction(
                                                                  _isFav,
                                                                  docId,
                                                                  widget
                                                                      .user.uid,
                                                                  widget.name,
                                                                  widget
                                                                      .description,
                                                                  widget.price,
                                                                  widget
                                                                      .discount,
                                                                  widget
                                                                      .imageList);
                                                        }))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '${widget.description}',
                                                  style: TextStyle(
                                                    fontFamily: 'Nexa',
                                                    fontSize: 8,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                // SizedBox(
                                                //   width: 40,
                                                // ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text('Size',
                                                    style: TextStyle(
                                                        fontFamily: 'Nexa',
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            (widget.category ==
                                                        '${EnumToString.parse(Categories.Top)}') ||
                                                    (widget.category ==
                                                        '${EnumToString.parse(Categories.Trouser)}')
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Material(
                                                            elevation: 5.0,
                                                            color: Colors
                                                                .redAccent
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'S',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Material(
                                                            elevation: 5.0,
                                                            color: Colors
                                                                .blueAccent
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'M',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Material(
                                                            elevation: 5.0,
                                                            color: Colors
                                                                .greenAccent
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'L',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Material(
                                                            elevation: 5.0,
                                                            color: Colors
                                                                .orangeAccent
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'XL',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      InkWell(
                                                        onTap: null,
                                                        child: Material(
                                                            elevation: 0.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'S',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: null,
                                                        child: Material(
                                                            elevation: 0.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'M',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: null,
                                                        child: Material(
                                                            elevation: 0.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'L',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: null,
                                                        child: Material(
                                                            elevation: 0.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                'XL',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Nexa'),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text('Quantity',
                                                    style: TextStyle(
                                                        fontFamily: 'Nexa',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Material(
                                                    elevation: 5.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    child: IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () {
                                                          setState(() {
                                                            _quantity++;
                                                          });
                                                        })),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Text(
                                                  '$_quantity',
                                                  style: TextStyle(
                                                      fontFamily: 'Nexa',
                                                      fontSize: 18.0),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Material(
                                                    elevation: 5.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    child: IconButton(
                                                        icon:
                                                            Icon(Icons.remove),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (_quantity > 0) {
                                                              _quantity--;
                                                            }
                                                          });
                                                        }))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            // SizedBox(
                                            //   width: 20,
                                            // ),
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _isUploading = true;
                                                });

                                                bool _stat = await widget.model
                                                    .uploadUserCart(
                                                        user.uid,
                                                        widget.name,
                                                        widget.description,
                                                        widget.price,
                                                        widget.discount,
                                                        _quantity == 0
                                                            ? '1'
                                                            : '$_quantity',
                                                        //docId,
                                                        widget.imageList);
                                                setState(() {
                                                  _isUploading = false;
                                                });

                                                setState(() {
                                                  // _status = _stat;
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: 60,
                                                child: Material(
                                                  elevation: 5.0,
                                                  color: Color(myyellow),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.shopping_basket,
                                                        color: Colors.white60,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      //_status?
                                                      _isUploading
                                                          ? SpinKitRing(
                                                              lineWidth: 2,
                                                              size: 18,
                                                              color:
                                                                  Colors.white,
                                                              //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                                                            )
                                                          : Text(
                                                              'Add to Cart',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  color: Colors
                                                                      .white60,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
