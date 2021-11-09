import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../methods/categories_methods.dart';
import '../models/categories_model.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import '../side menu.dart';

class Categories extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  Categor createState() => Categor();
}

class Categor extends State<Categories> {
  // List<dynamic> categories;
  Widget chipBuilder({String title, Function onTap}) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF52595D),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.clear,
                color: Colors.teal,
                size: 30,
              ),
            ),
            SizedBox(width: 4),
            Text(
              title ?? "data",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  final _addformKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _addformKey,
              child: AlertDialog(
                title: Text(
                  "Add a Category",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                ),
                content: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  // controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Category"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      // if (valueText.length < 1) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("ERROR: Category cannot be empty"),
                      //   ));
                      //   Navigator.pop(context);
                      // } else {
                      if (_addformKey.currentState.validate()) {
                        categories[this.valueText] = [];
                        Category cat = Category(categories: categories);
                        // print(cat);
                        print(
                            await CagetoryMethods().addCategory(category: cat));

                        Navigator.pop(context);
                      }
                    },
                    child: Text('ADD'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3), // <-- Radius
                        ),
                        primary: Color(0xFF52595D)),
                  ),
                ],
              ));
        });
  }

  final _editformKey = GlobalKey<FormState>();
  final TextEditingController _input = TextEditingController();
  Future<void> _editDisplayTextInputDialog(BuildContext context, name) async {
    List subcat = categories[name];
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _editformKey,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text(
                    "Add SubCategories",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                  content: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // input field
                        TextField(
                          controller: _input,
                          // onEditingComplete: () {},
                          decoration: InputDecoration(
                            hintText: "Subcategory",
                            suffixIcon: IconButton(
                              onPressed: () => {
                                setState(() {
                                  subcat.add(_input.text);
                                  print(subcat);
                                  _input.clear();
                                })

                                // print(flats)
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // inrests
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: subcat.length == 0
                              ? Text(
                                  "no data",
                                  style: TextStyle(color: Colors.blueGrey),
                                  textAlign: TextAlign.center,
                                )
                              : Wrap(
                                  runSpacing: 6,
                                  spacing: 6,
                                  children:
                                      List.from(subcat.map((e) => chipBuilder(
                                            onTap: () {
                                              setState(() {
                                                subcat.remove(e);
                                              });
                                            },
                                            title: e,
                                          ))),
                                ),
                        ),

                        // empty list btn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  subcat.clear();
                                });
                              },
                              child: Text(
                                "Empty List",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )

                  // onChanged: (value) {
                  //   setState(() {
                  //     valueText = value;
                  //   });
                  // },
                  // controller: _textFieldController,
                  // decoration: InputDecoration(hintText: valueText),
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter some text';
                  //   }
                  //   return null;
                  // },
                  ,
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        // if (_editformKey.currentState.validate()) {
                        // categories[name] = this.valueText;
                        categories.removeWhere((key, value) => key == name);
                        categories[name] = subcat;
                        Category cat = Category(categories: categories);
                        print(
                            await CagetoryMethods().addCategory(category: cat));

                        Navigator.pop(context);
                        // }
                      },
                      child: Text('Update'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(3), // <-- Radius
                          ),
                          primary: Color(0xFF52595D)),
                    ),
                  ],
                );
              }));
        });
  }

  String codeDialog = '';
  String valueText = '';
  int indexOfSelectedText;
  List ogcat = [
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
  Map categories = {
    "Advance": [],
    "Goodwill": [],
    "Agent Commission": [],
    "Permission": [],
    "Borewell and Motor": [],
    "Electrical (Govt)": [],
    "Earthwork - excavation (pits)": [],
    "PCC": [],
    "40mm-Metal": [],
    "Sand (river)": [],
    "Sand (Robo)": [],
    "20mm-Metal": [],
    "Steel": [],
    "Cement": [],
    "Bricks": [],
    "Centering payment": [],
    "Civil mason payment": [],
    "Wood (frames)": [],
    "UPVC-windows": [],
    "Grills": [],
    "Paints": [],
    "Painter": [],
    "Carpenter": [],
    "Tiles": [],
    "Tiles (labour)": [],
    "Main door shutters": [],
    "Internal door shutters": [],
    "Hardware": [],
    "CP fittings": [],
    "Ceramic": [],
    "Electrical wiring": [],
    "Electrical switches": [],
    "Electrician": [],
    "Plumber": [],
    "Sanitary": [],
    "PVC fittings": [],
    "Granite & labour": [],
    "Water proofing": [],
    "Lift": [],
    "Genarator": [],
    "Water supply": [],
    "Transformers": [],
    "CC cameras": [],
    "Solar systems": [],
    "Ballies": [],
    "Govathallu": [],
    "Miscellaneous": [],
    "Stilt flooring (tiles or VDR)": [],
    "Engineer salary": [],
    "Watchman salary": [],
    "Consultant charges": []
  };

// class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("CATEGORIES"),
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
                .collection('Categories')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              try {
                categories = snapshot.data['categories'];
              } catch (e) {}

              // categories['Aa'].add("shfklshfl");

              // print(snapshot.data['categories']);

              // categories = snapshot.data['categories'];
              List aya = categories.keys.toList();
              aya.sort((a, b) {
                return a.toLowerCase().compareTo(b.toLowerCase());
              });
              return ListView.separated(
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: (BuildContext context, int position) {
                    var name = aya[position];
                    return ListTile(
                        title: Text(name),
                        trailing: ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () async => {
                                        this.valueText = aya[position],
                                        this.indexOfSelectedText = position,
                                        await _editDisplayTextInputDialog(
                                            context, aya[position])
                                      }),
                              IconButton(
                                icon: (ogcat.contains(name))
                                    ? Icon(Icons.delete_outline)
                                    : Icon(Icons.delete),
                                onPressed: () async => {
                                  if (ogcat.contains(name))
                                    {}
                                  else
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              title: Text('Please Confirm'),
                                              content: Text(
                                                  'Are you sure to delete the category?'),
                                              actions: [
                                                // The "Yes" button
                                                TextButton(
                                                    onPressed: () async {
                                                      // Remove the box
                                                      categories.removeWhere(
                                                          (key, value) =>
                                                              key == name);
                                                      await CagetoryMethods()
                                                          .addCategory(
                                                              category: Category(
                                                                  categories:
                                                                      categories));

                                                      // Close the dialog
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      // Close the dialog
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('No'))
                                              ],
                                            );
                                          })
                                    },
                                },
                              ),
                            ]));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: categories.length);
            }));
  }
}
