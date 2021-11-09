import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../side menu.dart';

class Database extends StatelessWidget {
  Future<void> _displayTextInputDialog1(BuildContext context) async {
    // var dat;
    // var type = ["Cash", "Cheque"];
    // var _selectedItem = type[0];
    String iid = "";

    final _addformKey = GlobalKey<FormState>();
    // final dateController = TextEditingController();
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
                    "Enter user ID",
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
                      onChanged: (value4) {
                        setState(() {
                          iid = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: ""),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        clone(context, iid);
                      },
                      child: Text('Import'),
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

  Future<void> _displayTextInputDialog2(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Center(
                  child: Text(
                "Your user ID",
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
                  initialValue:
                      FirebaseAuth.instance.currentUser.uid.toString(),
                  onChanged: (value4) {
                    value4 = FirebaseAuth.instance.currentUser.uid.toString();
                  },
                  // controller: _TextFormFieldController,
                  decoration: InputDecoration(hintText: ""),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ]))),
              // actions: <Widget>[
              //   ElevatedButton(
              //     onPressed: () {},
              //     child: Text('Ok'),
              //     style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(3), // <-- Radius
              //         ),
              //         primary: Color(0xFF52595D)),
              //   ),
              // ],
            );
          }));
        });
  }

  Future<void> clone(BuildContext context, iid) async {
    var uid = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(iid)
        .get()
        .then((value) async => {
              print(value['categories']),
              await FirebaseFirestore.instance
                  .collection('Categories')
                  .doc(uid)
                  .set({'categories': value['categories']})
            });
    await FirebaseFirestore.instance
        .collection('subCategories')
        .doc(iid)
        .get()
        .then((value) async => {
              print(value['subcategories']),
              await FirebaseFirestore.instance
                  .collection('subCategories')
                  .doc(uid)
                  .set({'subcategories': value['subcategories']})
            });

    var value;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(iid)
        .collection('project')
        .get()
        .then((out) async => {value = out});
    for (var a in value.docs) {
      await FirebaseFirestore.instance
          .collection('Projects')
          .doc(uid)
          .collection('project')
          .doc(a.id)
          .set({
        "projectname": a['projectname'],
        "location": a['location'],
        "notes": a['notes'],
        "flats": a['flats'],
        "type": a['type'],
        "flatsdone": a['flatsdone'],
        "numberofflats": a['numberofflats'],
        "cateogries": a['cateogries'],
        "id": a.id
      });
      try {
        await FirebaseFirestore.instance
            .collection('Projects')
            .doc(iid)
            .collection('project')
            .doc(a.id)
            .collection('expenses')
            .get()
            .then((value) async => {
                  for (var b in value.docs)
                    {
                      await FirebaseFirestore.instance
                          .collection('Projects')
                          .doc(uid)
                          .collection('project')
                          .doc(a.id)
                          .collection('expenses')
                          .doc(b.id)
                          .set({
                        "date": b['date'],
                        "category": b['category'],
                        "subcategory": b['subcategory'],
                        "paidby": b['paidby'],
                        "description": b['description'],
                        "amount": b['amount'],
                        "type": b['type'],
                        "id": b.id
                      })
                    }
                });
      } catch (e) {
        print(e);
        print("no expense");
      }
      try {
        var vl;
        await FirebaseFirestore.instance
            .collection('Projects')
            .doc(iid)
            .collection('project')
            .doc(a.id)
            .collection('receipts')
            .get()
            .then((val) async => {vl = val});
        for (var b in vl.docs) {
          await FirebaseFirestore.instance
              .collection('Projects')
              .doc(uid)
              .collection('project')
              .doc(a.id)
              .collection('receipts')
              .doc(b.id)
              .set({
            "date": b['date'],
            "soldto": b['soldto'],
            "phonenumber": b['phonenumber'],
            "amount": b['amount'],
            "persqft": b['persqft'],
            "amenities": b['amenities'],
            "description": b['description'],
            "id": b.id,
          });
          try {
            await FirebaseFirestore.instance
                .collection('Projects')
                .doc(iid)
                .collection('project')
                .doc(a.id)
                .collection('receipts')
                .doc(b.id)
                .collection('flatexpenses')
                .get()
                .then((value) async => {
                      for (var c in value.docs)
                        {
                          await FirebaseFirestore.instance
                              .collection('Projects')
                              .doc(uid)
                              .collection('project')
                              .doc(a.id)
                              .collection('receipts')
                              .doc(b.id)
                              .collection('flatexpenses')
                              .doc(c.id)
                              .set({
                            "date": c['date'],
                            "type": c['type'],
                            "amount": c['amount'],
                            "id": c.id,
                          })
                        }
                    });
          } catch (e) {
            print("No flat expense found");
          }
        }
      } catch (e) {
        print("recipts not found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("DATABASE"),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.add_circle_rounded,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       // do something
          //     },
          //   )
          // ],
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _displayTextInputDialog1(context);
                                  },
                                  child: Text('Import'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            3), // <-- Radius
                                      ),
                                      primary: Color(0xFF52595D))))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _displayTextInputDialog2(context);
                                  },
                                  child: Text('Export'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            3), // <-- Radius
                                      ),
                                      primary: Color(0xFF52595D))))),
                    ]))));
  }
}
