import 'package:cloud_firestore/cloud_firestore.dart';

class Favourites {
  String name;
  String description;
  String price;
  String discount;
  List<dynamic> imageList;
  String category;
  DocumentReference refernce;

  Favourites({
    this.name, 
    this.description,
    this.price,
    this.discount,
    this.imageList,
    this.category
    });

  Favourites.fromMap(Map<String, dynamic> map, {this.refernce})
      : name = map['name'],
        description = map['description'],
        price = map['price'],
        discount = map['discount'],
        category = map['category'],
        imageList = map['imagelist'];

  Favourites.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, refernce: snapshot.reference);
}
