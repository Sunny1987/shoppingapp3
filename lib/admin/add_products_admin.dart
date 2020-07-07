import 'dart:io';
import 'dart:async';
//import 'package:provider/provider.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
//import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/admin/image_capture.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
//import 'package:shoppingapp2/services/authservice.dart';
//import 'package:testapp1/admin/image_capture.dart';
//import 'package:shoppingapp2/services/main_service.dart';
import 'package:shoppingapp2/services/mainservice.dart';

class AddProduct extends StatefulWidget {
  static const String id = 'AddProduct';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String name, description, category = 'Saree';
  // price, 
  // discount, category = 'Saree';
  num price,discount;

  GlobalKey<FormState> _globalFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  bool _isUploading = false;
  //List<Asset> _images;
  Map<int, Asset> map;
  Map<int, File> filemap;
  Asset img;
  var image;
  String path;
  File file;
  List<File> imageFiles;
  bool _uploadstatus = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainService>(
      builder: (BuildContext context, Widget child, MainService model) {
        print(model.imageFileList);
        imageFiles = model.imageFileList;
        return SafeArea(
          child: Scaffold(
            key: _scaffoldStateKey,
            body: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 130.0,
                    ),
                    Text(
                      'Add Product',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Form(
                      key: _globalFormKey,
                      child: ListView(
                        children: <Widget>[
                          ScopedModelDescendant<MainService>(
                            builder: (BuildContext context, Widget child,
                                MainService model) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, ImageCapture.id);
                                },
                                child: imageFiles.length == 0
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 90.0),
                                        height: 190.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                              image: AssetImage(camera),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        height: 190.0,
                                        width: double.infinity,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageFiles.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                child: Container(
                                                  height: 190.0,
                                                  width: 190,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            imageFiles[index]),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  //child: Text('data'),
                                                ),
                                              );
                                            }),
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
                          _buildTextField(
                            'Saree Name',
                          ),
                          _buildTextField(
                            'Saree Description',
                          ),
                          _dropDownData(),
                          _buildTextField(
                            'Saree price',
                          ),
                          _buildTextField(
                            'Saree discount',
                          ),
                          SizedBox(height: 20.0),
                          ScopedModelDescendant<MainService>(
                            builder: (BuildContext context, Widget child,
                                MainService model) {
                              return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _isUploading = true;
                                    });
                                    bool _status =
                                        await onSubmitUpload(model, context);

                                    setState(() {
                                      _uploadstatus = _status;
                                    });

                                    setState(() {
                                      _isUploading = false;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Color(myyellow)),
                                    child: Center(
                                        child: _isUploading
                                            ?
                                            // _uploadstatus
                                            //     ? Icon(
                                            //         Icons.check_circle_outline,
                                            //         color: Colors.white,
                                            //       )

                                            SpinKitRing(
                                                lineWidth: 2,
                                                size: 18,
                                                color: Colors.white,
                                                //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                                              )
                                            : Text(
                                                'Upload Product',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontFamily: 'Nexa',
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )),
                                  )

                                  // UploadButton(
                                  //   bText: 'Upload',
                                  //   isUploading: _isUploading,
                                  // ),

                                  );
                            },
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> onSubmitUpload(MainService model, BuildContext context) async {
    bool status = false;
    if (_globalFormKey.currentState.validate()) {
      _globalFormKey.currentState.save();
      print('Name: $name');
      print('Description: $description');
      print('price: $price');
      print('discount: $discount');
      print('upload pressed');
      print('category: $category');

      //call the firebase method
      status = await model.uploadAllProductDataToFirebase(
          model.imageFileList, name, description, price, discount, category);
    }
    return status;
  }

  Widget _buildTextField(String sareeText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: sareeText,
        ),
        maxLines: 1,
        keyboardType:
            (sareeText == 'Saree price') || (sareeText == 'Saree discount')
                ? TextInputType.number
                : TextInputType.text,
        validator: (String value) {
          //var errorMsg = '';
          if (value.isEmpty && sareeText == 'Saree Name') {
            return 'Saree name cannot be empty';
          }
          if (value.isEmpty && sareeText == 'Saree Description') {
            return 'Saree Description cannot be empty';
          }
          if (value.isEmpty && sareeText == 'Saree price') {
            return 'Saree price cannot be empty';
          }
          //return errorMsg;
        },
        onSaved: (String value) {
          if (sareeText == 'Saree Name') {
            name = value.trim();
          }
          if (sareeText == 'Saree Description') {
            description = value.trim();
          }
          if (sareeText == 'Saree price') {
            price = num.parse(value.trim());
          }
          if (sareeText == 'Saree discount') {
            discount = num.parse(value.trim());
          }
        },
      ),
    );
  }

  Widget _dropDownData() {
    //String category1 = 'Sarees';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: DropdownButton<String>(
          value: category,
          items: <String>['Saree', 'Blouse', 'Trouser', 'Top']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          icon: Icon(Icons.arrow_downward),
          iconSize: 20.0,
          elevation: 10,
          style: TextStyle(color: Colors.black54, fontSize: 18.0),
          //   underline: Container(
          //   height: 2,
          //   color: Colors.grey,
          // ),
          onChanged: (String newvalue) {
            setState(() {
              category = newvalue;
            });
          }),
    );
  }
}

class UploadButton extends StatefulWidget {
  final String bText;
  final bool isUploading;
  UploadButton({this.bText, this.isUploading});

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      height: 60.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Color(myyellow)),
      child: Center(
          child: widget.isUploading
              ? SpinKitRing(
                  lineWidth: 2,
                  size: 18,
                  color: Colors.white,
                  //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                )
              : Text(
                  widget.bText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold),
                )),
    );
  }
}
