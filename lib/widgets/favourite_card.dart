import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/views/product_details.dart';

class FavouriteCard extends StatefulWidget {
  final Favourites fav;

  FavouriteCard({this.fav});

  @override
  _FavouriteCardState createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  bool _isFav = false;
  Map<String, Favourites> map;
  String docId = '';
  // Map<String, Product> product_map;
  // // String image = widget.imageList[0];

  // getFav(
  //   QuerySnapshot snapshot,
  //   AppUser user,
  // ) async {
  //   //var snapshot = await model.getFavourites(user);

  //   var docs = await snapshot.documents;
  //   List list =
  //       docs.map((document) => Favourites.fromSnapshot(document)).toList();

  //   map = Map.fromIterable(docs,
  //       key: (doc) => doc.documentID,
  //       value: (doc) => Favourites.fromSnapshot(doc));

  //   list.forEach((document) {
  //     Favourites fav = document;
  //     if (mounted) {
  //       if (widget.imageList[0] == fav.imageList[0]) {
  //         setState(() {
  //           _isFav = true;
  //         });
  //         // } else {
  //         //   setState(() {
  //         //     _isFav = false;
  //         //   });
  //       }
  //     }
  //   });
  // }

  // getAllDocIds(QuerySnapshot snapshot) async {
  //   var docs = await snapshot.documents;

  //   product_map = Map.fromIterable(docs,
  //       key: (doc) => doc.documentID,
  //       value: (doc) => Product.fromSnapshot(doc));
  // }

  // callFav(BuildContext context) async {
  //   AppUser user = Provider.of<AppUser>(context);
  //   final snapshot = await Firestore.instance
  //       .collection(EnumToString.parse(CollectionTypes.user_favourites))
  //       //.collection('user_favourites')
  //       .where('id', isEqualTo: '${user.uid}')
  //       .getDocuments();
  //   await getFav(snapshot, user);
  //   final prod_snapshots = await Firestore.instance
  //       .collection(EnumToString.parse(CollectionTypes.sarees))
  //       .getDocuments();

  //   await getAllDocIds(prod_snapshots);
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    //callFav(context);
    //print(widget.imageList[0]);

    return ScopedModelDescendant<MainService>(
      builder: (BuildContext context, Widget child, MainService model) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                      fav: widget.fav,
                      isFav: _isFav,
                      model: model,
                      user: user,
                      //map: map,
                      //prod_map: product_map,
                    )));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            //padding: EdgeInsets.only(right: 10.0),
            height: 200,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                  image: NetworkImage(widget.fav.imageList[0]
                      //widget.imageList[0]
                      ),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 60.0,
                  decoration:
                      BoxDecoration(color: Colors.white38.withOpacity(0.9)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '${widget.fav.name}',
                        style: TextStyle(
                            fontFamily: 'Nexa', color: Color(myyellow)),
                      ),
                      Text(
                        '${widget.fav.price}',
                        style: TextStyle(
                            fontFamily: 'Nexa', color: Color(myyellow)),
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        child: IconButton(
                            icon: _isFav
                                ? Icon(
                                    Icons.favorite,
                                    color: Color(myyellow),
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Color(myyellow),
                                  ),
                            onPressed: () {
                              setState(() {
                                _isFav = !_isFav;
                                // if (map != null) {
                                // map.forEach((key, value) {
                                //   if (value.imageList[0] ==
                                //       widget.imageList[0]) {
                                //     docId = key;
                                //   }
                                // });
                                // }
                                // if (map == null) {
                                //   product_map.forEach((key, value) {
                                //     if (value.imageList[0] ==
                                //         widget.imageList[0]) {
                                //       docId = key;
                                //     }
                                //   });
                                // }
                              });

                              // model.firestoreAction(
                              //     _isFav,
                              //     docId,
                              //     user.uid,
                              //     widget.name,
                              //     widget.description,
                              //     widget.price,
                              //     widget.discount,
                              //     widget.imageList);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      //child: ,
    );
  }
}
