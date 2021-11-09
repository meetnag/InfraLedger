import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:inframobileapp/screens/expenses.dart';
import '../side menu.dart';
import '../utils.dart' as utl;
import 'utils.dart';

class Flatexpense extends StatelessWidget {
  //////////////////////////////////////////////////
  Future<void> _displayTextInputDialog(BuildContext context) async {
    var dat;
    var type = ["Cash", "Cheque"];
    var _selectedItem = type[0];

    String amount = "";

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
                    "Receipt of Money",
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
                        Text("Payment Mode:    ", textAlign: TextAlign.left),
                        DropdownButton(
                            value: _selectedItem,
                            items: type
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
                          return 'Please enter valid amount';
                        }
                        return null;
                      },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_addformKey.currentState.validate()) {
                          // codeDialog = valueText;
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id)
                                  .collection('receipts')
                                  .doc(name)
                                  .collection("flatexpenses")
                                  .doc();
                          documentReference.set({
                            "date": dat,
                            "type": _selectedItem,
                            "amount": amount,
                            "id": documentReference.id.toString(),
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

  Future<void> _editdisplayTextInputDialog(BuildContext context, exp) async {
    print(exp);
    var dat = exp['date'];
    var type = ["Cash", "Cheque"];
    var _selectedItem = exp['type'];

    String amount = exp['amount'].toString();

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
                    "Receipt of Money",
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
                      // initialValue: dat,
                      controller: dateController,
                      decoration: InputDecoration(hintText: dat),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Payment Mode:    ", textAlign: TextAlign.left),
                        DropdownButton(
                            value: _selectedItem,
                            items: type
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
                    TextFormField(
                      // initialValue: amount,
                      onChanged: (value4) {
                        setState(() {
                          amount = value4;
                        });
                      },
                      // controller: _TextFormFieldController,
                      decoration: InputDecoration(hintText: amount),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the amount';
                        } else if (!isFloat(value)) {
                          return 'Please enter valid amount';
                        }
                        return null;
                      },
                    ),
                  ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_addformKey.currentState.validate()) {
                          // codeDialog = valueText;
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id)
                                  .collection('receipts')
                                  .doc(name)
                                  .collection("flatexpenses")
                                  .doc(exp['id']);
                          documentReference.update({
                            "date": dat,
                            "type": _selectedItem,
                            "amount": amount,
                            "id": documentReference.id.toString(),
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

  /////////////////
  ///String _buyername = "";
  final id;
  final name;
  final amenities;
  final amount;
  final buyername;
  final flatnumber;
  final notes;
  final persqft;
  final phoneno;

  Flatexpense(
      {this.id,
      this.name,
      this.amenities,
      this.amount,
      this.buyername,
      this.flatnumber,
      this.notes,
      this.persqft,
      this.phoneno});

  List flats = [];
  List expenses = [];

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  // static const IconData delete = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);

  List<DataRow> getRows(context, List users) => users.map((user) {
        // static const IconData delete = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);
        var da = (user['date']).toString().split("-");
        var d =
            da[2].toString() + "-" + da[1].toString() + "-" + da[0].toString();
        final cells = [
          d,
          user['type'],
          utl.Utils.formatExpense(int.parse(user['amount'])),
          "",
          // '🗑️'
          Icon(Icons.delete)
        ];
        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 3;

            if (index == 4) {
              return DataCell(
                Icon(Icons.delete),
                showEditIcon: showEditIcon,

                // showDeleteIcon: showDeleteIcon,
                onTap: () {
                  switch (index) {
                    case 4:
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Text('Please Confirm'),
                              content:
                                  Text('Are you sure to delete the expense?'),
                              actions: [
                                // The "Yes" button
                                TextButton(
                                    onPressed: () async {
                                      // Remove the box
                                      FirebaseFirestore.instance
                                          .collection('Projects')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .collection('project')
                                          .doc(id)
                                          .collection('receipts')
                                          .doc(name)
                                          .collection("flatexpenses")
                                          .doc(user['id'])
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
                          });
                      break;
                  }
                },
              );
            } else {
              return DataCell(
                Text('$cell'),

                showEditIcon: showEditIcon,

                // showDeleteIcon: showDeleteIcon,
                onTap: () {
                  switch (index) {
                    case 3:
                      _editdisplayTextInputDialog(context, user);

                      break;
                    case 4:
                      FirebaseFirestore.instance
                          .collection('Projects')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('project')
                          .doc(id)
                          .collection('expenses')
                          .doc(user['id'])
                          .delete();
                      break;
                  }
                },
              );
            }
          }),
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(name),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _displayTextInputDialog(context);
              },
            )
          ],
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Projects')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('project')
                      .doc(id)
                      .collection('receipts')
                      .doc(name)
                      .collection("flatexpenses")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');

                    var allData;
                    var total = 0.0;
                    print(snapshot.data);
                    try {
                      allData =
                          snapshot.data.docs.map((doc) => doc.data()).toList();

                      // print(allData);
                      // print(snapshot.data);
                      expenses = [];

                      for (var i = 0; i < allData.length; i++) {
                        expenses.add(allData[i]);
                        total += double.parse(allData[i]['amount']);
                      }
                      // print(expenses);
                    } catch (e) {
                      print(e);
                      expenses = [];
                    }
                    // print(snapshot.data['categories']);
                    // print(total);
                    var tot = utl.Utils.formatExpense(total.round());
                    final columns = [
                      'Date',
                      'Mode',
                      'Amount',
                      'Edit',
                      'Delete'
                    ];
                    var amo =
                        utl.Utils.formatExpense(int.parse(amount).round());

                    return Column(
                      children: [
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
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                      )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Total receipts as of today: $tot",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Flat number: $flatnumber",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Buyer name: $buyername",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Phone Number: $phoneno",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Amount: $amo",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Per square feet: $persqft",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Amenities: $amenities    ",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Notes: $notes",
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        FittedBox(
                            child: DataTable(
                          columnSpacing: 20,
                          columns: getColumns(columns),
                          rows: getRows(context, expenses),
                        ))
                      ],
                    );
                  }));
        }));
  }
}
