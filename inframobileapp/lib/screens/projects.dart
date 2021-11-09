import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:empty_widget/empty_widget.dart';
import '../side menu.dart';
import 'expenses.dart';
import 'receipts.dart';

class Projects extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  Project createState() => Project();
}

class Project extends State<Projects> {
// chips helper
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
                color: Colors.white,
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

  List<String> flats = [];

  Future<void> _displayTextInputDialog(BuildContext context) async {
    // number_of_flats = '0';
    final _addformKey = GlobalKey<FormState>();
    final TextEditingController _input = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _addformKey,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(left: 25, right: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                      child: Text(
                    "Add a Project ",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  )),
                  content: Container(
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                    TextFormField(
                      onChanged: (value1) {
                        setState(() {
                          project_name = value1;
                        });
                      },
                      decoration: InputDecoration(hintText: "Project Name"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the project name';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Project Type:-    ",
                        //   textAlign: TextAlign.left,
                        //   // style: TextStyle(
                        //   //     fontWeight: FontWeight.bold, fontSize: 20),
                        // ),
                        DropdownButton(
                            value: _selectedItem,
                            items: _dropdownMenuItems
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem = value;
                              });
                            }),
                      ],
                    ),
                    (_selectedItem == "Apartment")
                        ? Column(children: <Widget>[
                            TextFormField(
                              onChanged: (value2) {
                                setState(() {
                                  number_of_flats = value2;
                                });
                              },
                              // controller: _textFormFieldController,
                              decoration:
                                  InputDecoration(hintText: "Number of Flats"),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  try {
                                    int.parse(value);
                                    return null;
                                  } catch (e) {
                                    return 'Please enter valid number of flats';
                                  }
                                } else {
                                  return 'Please enter the number of flats';
                                }
                              },
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // input field
                                  TextFormField(
                                    controller: _input,
                                    decoration: InputDecoration(
                                      hintText: "Enter your flat numbers",
                                      suffixIcon: IconButton(
                                        onPressed: () => {
                                          if (_input.text.isNotEmpty &&
                                              flats.length !=
                                                  int.parse(number_of_flats))
                                            {
                                              setState(() {
                                                flats.add(_input.text);
                                                _input.clear();
                                              })
                                            }
                                          else
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '$number_of_flats flat numbers added')))
                                            },
                                          // print(flats)
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (flats.length >
                                          int.parse(number_of_flats)) {
                                        return 'More flats were added';
                                      }

                                      return null;
                                    },
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
                                    child: flats.length == 0
                                        ? Text(
                                            "no data",
                                            style: TextStyle(
                                                color: Colors.blueGrey),
                                            textAlign: TextAlign.center,
                                          )
                                        : Wrap(
                                            runSpacing: 6,
                                            spacing: 6,
                                            children: List.from(
                                                flats.map((e) => chipBuilder(
                                                      onTap: () {
                                                        setState(() {
                                                          flats.remove(e);
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
                                              flats.clear();
                                            });
                                          },
                                          child: (flats.length > 0)
                                              ? Text(
                                                  "Empty List",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Text("")),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ])
                        : Container(),
                    TextFormField(
                      onChanged: (value3) {
                        setState(() {
                          location = value3;
                        });
                      },
                      // controller: _textFormFieldController,
                      decoration: InputDecoration(hintText: "Location"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the location';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value4) {
                        setState(() {
                          notes = value4;
                        });
                      },
                      // controller: _textFormFieldController,
                      decoration: InputDecoration(hintText: "Notes"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter notes';
                        }
                        return null;
                      },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // codeDialog = valueText;
                        if (_addformKey.currentState.validate()) {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc();
                          documentReference.set({
                            "projectname": project_name,
                            "location": location,
                            "notes": notes,
                            "flats": flats,
                            "type": _selectedItem,
                            "flatsdone": [],
                            "numberofflats": number_of_flats,
                            "cateogries": cate_list,
                            "id": documentReference.id.toString()
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text('ADD'),
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

  Future<void> _displayExitTextInputDialog(BuildContext context, proj) async {
    var flats1;
    setState(() {
      project_name = proj['projectname'];
      number_of_flats = proj['numberofflats'];
      notes = proj['notes'];
      location = proj['location'];
      _selectedItem = proj['type'];
      flats1 = proj['flats'];
    });
    final _editformKey = GlobalKey<FormState>();
    final TextEditingController _input = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _editformKey,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(left: 25, right: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                      child: Text(
                    "Edit Project ",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  )),
                  content: Container(
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                    TextFormField(
                      initialValue: project_name,
                      onChanged: (value1) {
                        setState(() {
                          project_name = value1;
                        });
                      },
                      decoration: InputDecoration(hintText: project_name),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the project name';
                        }
                        return null;
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text("Project Type:-    ", textAlign: TextAlign.left),
                    //     DropdownButton(
                    //         value: _selectedItem,
                    //         items: _dropdownMenuItems
                    //             .map((String item) => DropdownMenuItem<String>(
                    //                 child: Text(item), value: item))
                    //             .toList(),
                    //         onChanged: (value) async {
                    //           await setState(() {
                    //             print(value);
                    //             _selectedItem = value;
                    //           });
                    //         }),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Project Type:-    ", textAlign: TextAlign.left),
                        DropdownButton(
                            value: _selectedItem,
                            items: _dropdownMenuItems
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem = value;
                              });
                            }),
                      ],
                    ),
                    (_selectedItem == "Apartment")
                        ? Column(children: <Widget>[
                            TextFormField(
                              initialValue: number_of_flats,
                              onChanged: (value2) {
                                setState(() {
                                  number_of_flats = value2;
                                });
                              },
                              // controller: _textFormFieldController,
                              decoration:
                                  InputDecoration(hintText: "Number of Flats"),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  try {
                                    int.parse(value);
                                    return null;
                                  } catch (e) {
                                    return 'Please enter valid number of flats';
                                  }
                                } else {
                                  return 'Please enter number of flats';
                                }
                              },
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // input field
                                  TextFormField(
                                    controller: _input,
                                    // onEditingComplete: () {},
                                    decoration: InputDecoration(
                                      hintText: "Enter your flat numbers",
                                      suffixIcon: IconButton(
                                        onPressed: () => {
                                          if (_input.text.isNotEmpty &&
                                              flats1.length !=
                                                  int.parse(number_of_flats))
                                            {
                                              setState(() {
                                                flats1.add(_input.text);
                                                _input.clear();
                                              })
                                            }
                                          else
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '$number_of_flats flat numbers added')))
                                            },
                                          // print(flats)
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ),
                                    validator: (value) {
                                      // print(number_of_flats);
                                      // print(flats1);
                                      if (flats1.length >
                                          int.parse(number_of_flats)) {
                                        return 'More flats were added';
                                      }

                                      return null;
                                    },
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
                                    child: flats1.length == 0
                                        ? Text(
                                            "no data",
                                            style: TextStyle(
                                                color: Colors.blueGrey),
                                            textAlign: TextAlign.center,
                                          )
                                        : Wrap(
                                            runSpacing: 6,
                                            spacing: 6,
                                            children: List.from(
                                                flats1.map((e) => chipBuilder(
                                                      onTap: () {
                                                        setState(() {
                                                          flats1.remove(e);
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
                                              flats1.clear();
                                            });
                                          },
                                          child: (flats.length > 0)
                                              ? Text(
                                                  "Empty List",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Text("")),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ])
                        : Container(),
                    TextFormField(
                      initialValue: location,
                      onChanged: (value3) {
                        setState(() {
                          location = value3;
                        });
                      },
                      // controller: _textFormFieldController,
                      decoration: InputDecoration(hintText: location),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the location';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: notes,
                      onChanged: (value4) {
                        setState(() {
                          notes = value4;
                        });
                      },
                      // controller: _textFormFieldController,
                      decoration: InputDecoration(hintText: notes),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter notes';
                        }
                        return null;
                      },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await _addcatdisplayTextInputDialog(
                            context, proj['id']);
                        Navigator.pop(context);
                      },
                      child: Text('Add Categories'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(3), // <-- Radius
                          ),
                          primary: Color(0xFF52595D)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // codeDialog = valueText;
                        if (_editformKey.currentState.validate()) {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(proj['id']);
                          documentReference.update({
                            "projectname": project_name,
                            "location": location,
                            "notes": notes,
                            "type": _selectedItem,
                            "numberofflats": number_of_flats,
                            "cateogries": cate_list,
                            "id": documentReference.id.toString(),
                            "flats": flats1
                          });
                          Navigator.pop(context);
                        }
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

  Future<void> _addcatdisplayTextInputDialog(BuildContext context, id) async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    var cat;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(uid)
        .collection('project')
        .doc(id)
        .get()
        .then((val) {
      if (val.data().length > 0) {
        cat = (val.data()['cateogries']);
        // print(val.data()['projectname']);
      } else {
        print("Not Found");
      }
    });
    List<String> cat_list = [];
    for (int i = 0; i < cat.length; i += 1) {
      cat_list.add(cat[i].toString());
    }
    Map mycat;
    List<String> mycat_list = [];
    var _selectedItem;
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(uid)
          .get()
          .then((val) async {
        if (val.data().length > 0) {
          mycat = val.data()['categories'];
          // print(val.data()['projectname']);
        } else {
          print("Not Found");
        }
      });
      for (int i = 0; i < mycat.length; i += 1) {
        if (!ogcat.contains(mycat.keys.toList()[i].toString())) {
          mycat_list.add(mycat.keys.toList()[i].toString());
        }
      }
      mycat_list.sort((a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      });
      _selectedItem = mycat_list[0];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("First add some categories"),
      ));
      return null;
    }
    final _addformKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _addformKey,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(left: 25, right: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                      child: Text(
                    "Add Category",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  )),
                  content: DropdownButton(
                      value: _selectedItem,
                      items: mycat_list
                          .map((String item) => DropdownMenuItem<String>(
                              child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) async {
                        setState(() {
                          print(value);
                          _selectedItem = value;
                        });
                      }),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        bool yes = true;
                        for (int i = 0; i < cat_list.length; i++) {
                          if (cat_list[i] == _selectedItem) {
                            yes = false;
                          }
                        }
                        if (_addformKey.currentState.validate() && yes) {
                          cat_list.add(_selectedItem);
                          // codeDialog = valueText;
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id);

                          documentReference.update({
                            "cateogries": cat_list,
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Text('ADD'),
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

  Future<void> getTotal(id) async {
    total = 0;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var vl;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(uid)
        .collection('project')
        .doc(id)
        .collection('receipts')
        .get()
        .then((val) async => {vl = val});
    for (var b in vl.docs) {
      await FirebaseFirestore.instance
          .collection('Projects')
          .doc(uid)
          .collection('project')
          .doc(id)
          .collection('receipts')
          .doc(b.id)
          .collection('flatexpenses')
          .get()
          .then((value) async => {
                for (var c in value.docs) {total += int.parse(c['amount'])}
              });
    }
    print("hel");
    print(total);
  }

  // String codeDialog = '';
  // ignore: non_constant_identifier_names
  String project_name = '';
  String number_of_flats = '0';
  String location = '';
  String notes = '';
  var total = 0;
  List<String> _dropdownMenuItems = [
    "Apartment",
    "Independent",
    "House",
    "Plots"
  ];
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
  List projects = [];
  var _selectedItem = "Apartment";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          // leading: Icons.menu,
          title: Text("PROJECTS"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                // print("hello");
                await _displayTextInputDialog(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Projects')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('project')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');

              try {
                final allData =
                    snapshot.data.docs.map((doc) => doc.data()).toList();

                // print(allData);
                // print(snapshot.data);
                projects = [];

                for (var i = 0; i < allData.length; i++) {
                  projects.add(allData[i]);
                }
                // print(projects);
              } catch (e) {
                // print(e);
                projects = [];
              }
              // print(snapshot.data['categories']);

              // categories = snapshot.data['categories'];
              return ListView.separated(
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: (BuildContext context, int position) {
                    var name = projects[position]['projectname'];
                    var id = projects[position]['id'];
                    var type = projects[position]['type'];
                    return ListTile(
                        title: Text(name),
                        trailing: ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // IconButton(
                              //   icon: Icon(Icons.edit),
                              //   onPressed: () => {
                              //     _displayExitTextInputDialog(
                              //         context, projects[position])
                              //   },
                              // ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => {
                                  _displayExitTextInputDialog(
                                      context, projects[position])
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: Text('Please Confirm'),
                                          content: Text(
                                              'Are you sure to delete the project?'),
                                          actions: [
                                            // The "Yes" button
                                            TextButton(
                                                onPressed: () async {
                                                  // Remove the box
                                                  FirebaseFirestore.instance
                                                      .collection('Projects')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.uid)
                                                      .collection('project')
                                                      .doc(id)
                                                      .delete();
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Yes')),
                                            TextButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No'))
                                          ],
                                        );
                                      }),
                                },
                              ),
                              IconButton(
                                icon: Text(
                                  "\u20B9",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Expenses(
                                                id: id,
                                                name: name,
                                              )))
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.receipt_long),
                                onPressed: () async => {
                                  await getTotal(id),
                                  if (type == "Apartment")
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Receipts(
                                                    id: id,
                                                    name: name,
                                                    total: total,
                                                  )))
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Receipts are avaliable for appartments only"),
                                      ))
                                    }
                                },
                              ),
                            ]));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: projects.length);
            }));
  }
}
