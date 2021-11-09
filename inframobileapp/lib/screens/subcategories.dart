import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../methods/subcategories_methods.dart';
import '../models/subcategories_model.dart';
import '../side menu.dart';

class Subcategories extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  subCategor createState() => subCategor();
}

// ignore: camel_case_types
class subCategor extends State<Subcategories> {
  List<dynamic> subcategories;
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add a subCategory",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "subCategory"),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  ////////////////////////////////////////////////////////////////////////////////
                  /// uncomment this
                  /// ////////////////////////////////////////////////////////////////////////////
                  ///
                  subcategories.add(this.valueText);
                  subCategory cat = subCategory(subcategories: subcategories);
                  // print(cat);
                  print(await subCategoryMethods()
                      .addsubCategory(subcategory: cat));

                  Navigator.pop(context);
                },
                child: Text('ADD'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // <-- Radius
                    ),
                    primary: Color(0xFF52595D)),
              ),
            ],
          );
        });
  }

  Future<void> _editDisplayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Edit subCategory",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: valueText),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  subcategories[this.indexOfSelectedText] = this.valueText;
                  ;
                  subCategory cat = subCategory(subcategories: subcategories);
                  // print(cat);
                  print(await subCategoryMethods()
                      .addsubCategory(subcategory: cat));

                  Navigator.pop(context);
                },
                child: Text('EDIT'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // <-- Radius
                    ),
                    primary: Color(0xFF52595D)),
              ),
            ],
          );
        });
  }

  String codeDialog = '';
  String valueText = '';
  int indexOfSelectedText;

  var cate_list = [
    "Advance",
    "Goodwill",
    "Agent Commission",
    "Permission",
    "Borewell and Motor",
    "Electrical (Govt)",
    "Earthwork - excavation (pits)",
    "PCC",
    "40mm-Metal",
    "Sand (river)",
    "Sand (Robo)",
    "20mm-Metal",
    "Steel",
    "Cement",
    "Bricks",
    "Centering payment",
    "Civil mason payment",
    "Wood (frames)",
    "UPVC-windows",
    "Grills",
    "Paints",
    "Painter",
    "Carpenter",
    "Tiles",
    "Tiles (labour)",
    "Main door shutters",
    "Internal door shutters",
    "Hardware",
    "CP fittings",
    "Ceramic",
    "Electrical wiring",
    "Electrical switches",
    "Electrician",
    "Plumber",
    "Sanitary",
    "PVC fittings",
    "Granite & labour",
    "Water proofing",
    "Lift",
    "Genarator",
    "Water supply",
    "Transformers",
    "CC cameras",
    "Solar systems",
    "Ballies",
    "Govathallu",
    "Miscellaneous",
    "Stilt flooring (tiles or VDR)",
    "Engineer salary",
    "Watchman salary",
    "Consultant charges"
  ];
  Map sonu = {
    'Jack': [23, 23, 234, 234, 234, 234],
    'Adam': 27,
    'Katherin': 25
  };

// class subCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("SUB CATEGORIES"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                await _displayTextInputDialog(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('subCategories')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              // if (!snapshot) return const Text('Loading...');

              // FirebaseFirestore.instance
              //     .collection("subCategories")
              //     .doc(uid)
              //     .get()
              //     .then((value) {
              //   print(value.data());
              // });

              print(sonu['Jack']);
              try {
                subcategories = snapshot.data['subcategories'];
              } catch (e) {
                subcategories = [];
              }
              // print(snapshot.data["subcategories"]);
              print("####edd####");

              // subcategories = snapshot.data['subcategories'];
              // subcategories = ["sad", "asda"];
              return ListView.separated(
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: (BuildContext context, int position) {
                    var name = subcategories[position];
                    return ListTile(
                        title: Text(name),
                        trailing: ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async => {
                                        this.valueText =
                                            subcategories[position],
                                        this.indexOfSelectedText = position,
                                        await _editDisplayTextInputDialog(
                                            context)
                                      }),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async => {
                                  subcategories.remove(subcategories[position]),
                                  await subCategoryMethods().addsubCategory(
                                      subcategory: subCategory(
                                          subcategories: subcategories))
                                },
                              ),
                            ]));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: subcategories.length);
            }));
  }
}
