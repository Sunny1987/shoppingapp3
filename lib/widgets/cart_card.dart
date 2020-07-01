import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';

class CartCard extends StatefulWidget {
  final String name;
  final String price;
  final String quantity;
  final String image;
  final String description;
  final String discount;
  CartCard(
      {this.image,
      this.price,
      this.quantity,
      this.name,
      this.description,
      this.discount});

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  //String quan = quantity;
  num _quantity;
  num _price;

  @override
  void initState() {
    super.initState();
    String quan = widget.quantity;
    _quantity = int.parse(quan);
    String pr = widget.price;
    _price = int.parse(pr);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 5.0,
        color: Color(mywhite1),
        child: Slidable(
          actionPane: IconButton(icon: Icon(Icons.delete), onPressed: null),
          child: Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                    image: DecorationImage(
                        image: NetworkImage(widget.image), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.name}',
                      style: TextStyle(
                        fontFamily: 'Nexa',
                      ),
                    ),
                    Text(
                      'Size: XS',
                      style: TextStyle(
                        fontFamily: 'Nexa',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${_price * _quantity}',
                      style: TextStyle(
                          fontFamily: 'Nexa',
                          color: Color(myyellow),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 50.0),
                Column(
                  children: <Widget>[
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            // print(_quantity);
                            setState(() {
                              _quantity++;
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '${_quantity}',
                      style: TextStyle(
                        fontFamily: 'Nexa',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_quantity > 0) {
                                _quantity--;
                              }
                            });
                          },
                          child: Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
