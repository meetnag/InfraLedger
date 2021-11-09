import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../side menu.dart';
import 'flatexpense.dart';
import '../utils.dart' as utl;

class Receipts extends StatelessWidget {
  //////////////////////////////////////////////////
  Future<void> _displayTextInputDialog(BuildContext context, flatno) async {
    var dat;
    String soldto = "";
    String phoneno = "";
    String amount = "";
    String persqft = "";
    String amenities = "";
    String description = "";

    final _addformKey = GlobalKey<FormState>();
    final dateController = TextEditingController();
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
                    "Add Details",
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
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(hintText: 'Pick Date'),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        if (date.isAfter(DateTime.now())) {
                          return 'Please pick a valid date';
                        }

                        dateController.text = date.toString().substring(0, 10);
                        dat = date.toString().substring(0, 10);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please pick a date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          soldto = value;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Sold to"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter sold to';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value3) {
                        setState(() {
                          phoneno = value3;
                        });
                      },
                      validator: (value) {
                        if (!isNumeric(value)) {
                          // if (value) {
                          return 'Please enter the phone number';
                        }
                        return null;
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Phone number"),
                    ),
                    TextFormField(
                      onChanged: (value4) {
                        setState(() {
                          amount = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Amount"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the amount';
                        } else if (!isFloat(value)) {
                          // if (value) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value4) {
                        setState(() {
                          persqft = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Per square feet"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter per square feet';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value4) {
                        setState(() {
                          amenities = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Amenities"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter amenities';
                        }
                        if (!isInt(value)) {
                          return 'Please enter valid amenities';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value4) {
                        setState(() {
                          description = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: "Description"),
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter some description';
                      //   }
                      //   return null;
                      // },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        if (_addformKey.currentState.validate()) {
                          // codeDialog = valueText;
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id)
                                  .collection('receipts')
                                  .doc(flatno.toString());
                          documentReference.set({
                            "date": dat,
                            "soldto": soldto,
                            "phonenumber": phoneno,
                            "amount": amount,
                            "persqft": persqft,
                            "amenities": amenities,
                            "description": description,
                            "id": documentReference.id.toString(),
                          });
                          DocumentReference documentReference2 =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id);

                          var doneflats;
                          await FirebaseFirestore.instance
                              .collection('Projects')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('project')
                              .doc(id)
                              .get()
                              .then((val) {
                            if (val.data().length > 0) {
                              doneflats = (val.data()['flatsdone']);
                              // print(val.data()['projectname']);
                            } else {
                              print("Not Found");
                            }
                          });
                          List<String> doneflats_list = [flatno.toString()];
                          try {
                            for (int i = 0; i < doneflats.length; i += 1) {
                              doneflats_list.add(doneflats[i].toString());
                            }
                          } catch (e) {}

                          documentReference2
                              .update({"flatsdone": doneflats_list});

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

  /////////////////
  final id;
  final name;
  final total;

  Receipts({this.id, this.name, this.total});

  List flats = [];
  List flatsdone = [];
  var _amenities;
  var _amount;
  var _buyername;
  var _flatnumber;
  var _persqft;
  var _notes;
  var _phoneno;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(name),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.add_circle_rounded,
          //       color: Colors.white,
          //     ),
          //     onPressed: () => {},
          //   )
          // ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Projects')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('project')
                .doc(id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              // var total = 0;

              try {
                // print("234");
                // print(snapshot.data['flats']);
                // final allData =
                //     snapshot.data.map((doc) => doc.data()).toList();

                // // print(allData);
                // // print(snapshot.data);
                flats = [];
                flatsdone = [];
                flats = snapshot.data['flats'];
                flatsdone = snapshot.data['flatsdone'];

                // print(allData["flats"]);

                // for (var i = 0; i < allData["flats"].length; i++) {
                //   flats.add(allData["flats"][i]);
                // }
                // print(flats);
                flats = flats.toSet().toList();
              } catch (e) {
                // print(e);
                flats = [];
              }
              DateTime now = new DateTime.now();
              String today = new DateTime(now.year, now.month, now.day)
                  .toString()
                  .split(" ")[0]
                  .toString();
              var da = (today).toString().split("-");
              var d = da[2].toString() +
                  "-" +
                  da[1].toString() +
                  "-" +
                  da[0].toString();
              var tot = utl.Utils.formatExpense(total.round());
              String ex = "Total receipts as of $d : $tot";
              // print(snapshot.data['categories']);

              // categories = snapshot.data['categories'];
              return Column(children: [
                Card(
                  // color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[800], width: 1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              // width: 50.0,
                              // isExpanded: true,
                              // width: (MediaQuery.of(context).size.width),
                              height: 50.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                              )),
                        ),

                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // children: <Widget>[
                        Center(
                            child: Container(
                                // alignment: Alignment.center,
                                child: Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      ex,
                                      style: TextStyle(fontSize: 18),
                                      // textAlign: TextAlign.center,
                                    )))),
                        // ],
                      ],
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * .7,
                    child: ListView.separated(
                        padding: EdgeInsets.only(top: 20),
                        itemBuilder: (BuildContext context, int position) {
                          var fname = flats[position];

                          // var id = projects[position]['id'];
                          return ListTile(
                              title: (flatsdone.contains(fname))
                                  ? Text(
                                      fname,
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    )
                                  : Text(
                                      fname,
                                      style: TextStyle(
                                          // color: Colors.green,
                                          ),
                                    ),
                              onTap: () async => {
                                    if (flatsdone.contains(fname))
                                      {
                                        await FirebaseFirestore.instance
                                            .collection('Projects')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection('project')
                                            .doc(id)
                                            .collection('receipts')
                                            .doc(fname)
                                            .get()
                                            .then((value) => {
                                                  _amenities = value
                                                      .data()['amenities']
                                                      .toString(),
                                                  _amount = value
                                                      .data()['amount']
                                                      .toString(),
                                                  _buyername = value
                                                      .data()['soldto']
                                                      .toString(),
                                                  _flatnumber =
                                                      fname.toString(),
                                                  _notes = value
                                                      .data()['description']
                                                      .toString(),
                                                  _persqft = value
                                                      .data()['persqft']
                                                      .toString(),
                                                  _phoneno = value
                                                      .data()['phonenumber']
                                                      .toString()
                                                }),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Flatexpense(
                                                      id: id,
                                                      name: fname,
                                                      amenities: _amenities,
                                                      amount: _amount,
                                                      buyername: _buyername,
                                                      flatnumber: _flatnumber,
                                                      notes: _notes,
                                                      persqft: _persqft,
                                                      phoneno: _phoneno,
                                                    )))
                                      }
                                    else
                                      {_displayTextInputDialog(context, fname)}
                                  },
                              trailing: ButtonBar(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: (flatsdone.contains(fname))
                                          ? Icon(Icons.check_box_rounded,
                                              color: Colors.green)
                                          : Icon(Icons.check),
                                      onPressed: () async => {
                                        if (flatsdone.contains(fname))
                                          {
                                            await FirebaseFirestore.instance
                                                .collection('Projects')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection('project')
                                                .doc(id)
                                                .collection('receipts')
                                                .doc(fname)
                                                .get()
                                                .then((value) => {
                                                      _amenities = value
                                                          .data()['amenities']
                                                          .toString(),
                                                      _amount = value
                                                          .data()['amount']
                                                          .toString(),
                                                      _buyername = value
                                                          .data()['soldto']
                                                          .toString(),
                                                      _flatnumber =
                                                          fname.toString(),
                                                      _notes = value
                                                          .data()['description']
                                                          .toString(),
                                                      _persqft = value
                                                          .data()['persqft']
                                                          .toString(),
                                                      _phoneno = value
                                                          .data()['phonenumber']
                                                          .toString()
                                                    }),
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Flatexpense(
                                                          id: id,
                                                          name: fname,
                                                          amenities: _amenities,
                                                          amount: _amount,
                                                          buyername: _buyername,
                                                          flatnumber:
                                                              _flatnumber,
                                                          notes: _notes,
                                                          persqft: _persqft,
                                                          phoneno: _phoneno,
                                                        )))
                                          }
                                        else
                                          {
                                            _displayTextInputDialog(
                                                context, fname)
                                          }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async => {
                                        if (flatsdone.contains(fname))
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                /////////////////////
                                                return AlertDialog(
                                                  title: Text('Please Confirm'),
                                                  content: Text(
                                                      'Are you sure to clear the flat details?'),
                                                  actions: [
                                                    // The "Yes" button
                                                    TextButton(
                                                        onPressed: () async {
                                                          flatsdone
                                                              .remove(fname);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Projects')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid)
                                                              .collection(
                                                                  'project')
                                                              .doc(id)
                                                              .update({
                                                            "flatsdone":
                                                                flatsdone
                                                          });
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Projects')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid)
                                                              .collection(
                                                                  'project')
                                                              .doc(id)
                                                              .collection(
                                                                  'receipts')
                                                              .doc(fname)
                                                              .delete();
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
                                              }) ////////////////////
                                        // flatsdone.remove(fname),
                                        // FirebaseFirestore.instance
                                        //     .collection('Projects')
                                        //     .doc(FirebaseAuth
                                        //         .instance.currentUser.uid)
                                        //     .collection('project')
                                        //     .doc(id)
                                        //     .update({"flatsdone": flatsdone}),
                                        // await FirebaseFirestore.instance
                                        //     .collection('Projects')
                                        //     .doc(FirebaseAuth
                                        //         .instance.currentUser.uid)
                                        //     .collection('project')
                                        //     .doc(id)
                                        //     .collection('receipts')
                                        //     .doc(fname)
                                        //     .delete()
                                      },
                                    ),
                                  ]));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: flats.length))
              ]);
            })
        // FittedBox(
        //     child: DataTable(
        //   columnSpacing: 13,
        //   columns: getColumns(columns),
        //   rows: getRows(context, expenses),
        // ))
        //   ],
        // )))
        );
  }
}
