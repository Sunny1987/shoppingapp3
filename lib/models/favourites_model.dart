import 'package:cloud_firestore/cloud_firestore.dart';

class Favourites {
  String name;
  String description;
  num price;
  num discount;
  List<dynamic> imageList;
  String category;
  //String quantity;
  DocumentReference refernce;

  Favourites({
    this.name, 
    this.description,
    this.price,
    this.discount,
    this.imageList,
    this.category,
    //this.quantity
    });

  Favourites.fromMap(Map<String, dynamic> map, {this.refernce})
      : name = map['name'],
        description = map['description'],
        price = map['price'],
        discount = map['discount'],
        category = map['category'],
        imageList = map['imagelist']
        //quantity = map['quantity']
        ;

  Favourites.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, refernce: snapshot.reference);
}
