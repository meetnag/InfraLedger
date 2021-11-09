import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:inframobileapp/screens/categories.dart';
import '../utils.dart' as utl;
import 'package:validators/validators.dart';
import '../side menu.dart';
import 'utils.dart';

class Expenses extends StatelessWidget {
  final id;
  final name;

  Expenses({this.id, this.name});

  Future<void> _displayTextInputDialog(BuildContext context) async {
    var cat;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(FirebaseAuth.instance.currentUser.uid)
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

    cat_list.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    var _selectedItem = cat[0];
    var _selectedItem1 = _dropdownMenuItems[0];
    var _selectedItem2 = 'none';
    final _addformKey = GlobalKey<FormState>();
    final dateController = TextEditingController();
    List<String> subcat_list = ["none"];
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
                    "Add an Expense",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"),
                  )),
                  content: Container(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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

                            dateController.text =
                                date.toString().substring(0, 10);
                            dat = date.toString().substring(0, 10);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please pick a date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // Align(
                        // alignment: Alignment.centerLeft,
                        Text(
                          "Category    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        // )
                        DropdownButton(
                            value: _selectedItem,
                            items: cat_list
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              Map subcat;

                              try {
                                subcat_list = ["none"];
                                await FirebaseFirestore.instance
                                    .collection('Categories')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .get()
                                    .then((val) {
                                  if (val.data().length > 0) {
                                    subcat = (val.data()['categories']);
                                    // print(val.data()['projectname']);
                                  } else {
                                    print("Not Found");
                                  }
                                });
                                for (int i = 0;
                                    i < subcat[value].length;
                                    i += 1) {
                                  // ignore: await_only_futures
                                  await subcat_list
                                      .add(subcat[value][i].toString());
                                }
                                print(subcat_list);
                              } catch (e) {}
                              setState(() {
                                print(value);
                                _selectedItem = value;
                              });
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Sub-Category    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        DropdownButton(
                            value: _selectedItem2,
                            items: subcat_list
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem2 = value;
                              });
                            }),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: "description"),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                        ),
                        TextFormField(
                          onChanged: (value3) {
                            setState(() {
                              amount = value3;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter amount';
                            } else if (!isFloat(value)) {
                              return 'Please enter a number';
                            }
                            return null;
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: "Amount"),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Mode of payment    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        DropdownButton(
                            value: _selectedItem1,
                            items: _dropdownMenuItems
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem1 = value;
                              });
                            }),
                        TextFormField(
                          onChanged: (value4) {
                            setState(() {
                              paidby = value4;
                            });
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: "Paid By"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter paid by';
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
                                  .collection('expenses')
                                  .doc();
                          documentReference.set({
                            "date": dat,
                            "category": _selectedItem,
                            "subcategory": _selectedItem2,
                            "paidby": paidby,
                            "description": description,
                            "amount": amount,
                            "type": _selectedItem1,
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

  Future<void> _displayTextInputDialogedit(BuildContext context, exp) async {
    var cat;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(FirebaseAuth.instance.currentUser.uid)
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
    cat_list.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    List<String> subcat_list = [exp["subcategory"]];

    // var _selectedItem = cat[0];
    // var _selectedItem1 = _dropdownMenuItems[0];

    final dateController = TextEditingController();
    dateController.text = exp['date'];
    dat = exp['date'];
    var _selectedItem = exp['category'];
    var _selectedItem1 = exp["type"];
    var _selectedItem2 = exp["subcategory"];
    amount = exp['amount'];
    paidby = exp["paidby"];
    description = exp["description"];
    try {
      Map subcat;
      subcat_list = ['none'];
      _selectedItem2 = subcat_list[0];
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((val) {
        if (val.data().length > 0) {
          subcat = (val.data()['categories']);
          // print(val.data()['projectname']);
        } else {
          print("Not Found");
        }
      });
      for (int i = 0; i < subcat[_selectedItem].length; i += 1) {
        subcat_list.add(subcat[_selectedItem][i].toString());
      }
    } catch (e) {}
    final _editformKey = GlobalKey<FormState>();
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
                    "Edit Expense ",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"),
                  )),
                  content: Container(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                        TextFormField(
                          readOnly: true,
                          // initialValue: date(da,
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

                            dateController.text =
                                date.toString().substring(0, 10);
                            dat = date.toString().substring(0, 10);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please pick a date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Category    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        DropdownButton(
                            value: _selectedItem,
                            items: cat_list
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              try {
                                Map subcat;
                                subcat_list = ['none'];
                                _selectedItem2 = subcat_list[0];
                                await FirebaseFirestore.instance
                                    .collection('Categories')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .get()
                                    .then((val) {
                                  if (val.data().length > 0) {
                                    subcat = (val.data()['categories']);
                                    // print(val.data()['projectname']);
                                  } else {
                                    print("Not Found");
                                  }
                                });
                                for (int i = 0;
                                    i < subcat[value].length;
                                    i += 1) {
                                  subcat_list.add(subcat[value][i].toString());
                                }
                              } catch (e) {}
                              setState(() {
                                print(value);
                                _selectedItem = value;
                              });
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Sub-Category    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        DropdownButton(
                            value: _selectedItem2,
                            items: subcat_list
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem2 = value;
                              });
                            }),
                        TextFormField(
                          initialValue: description,
                          onChanged: (value2) {
                            setState(() {
                              description = value2;
                            });
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: description),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                        ),
                        TextFormField(
                          initialValue: amount,
                          onChanged: (value3) {
                            setState(() {
                              amount = value3;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter amount';
                            } else if (!isFloat(value)) {
                              return 'Please enter a number';
                            }
                            return null;
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: amount),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Mode of payment    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        DropdownButton(
                            value: _selectedItem1,
                            items: _dropdownMenuItems
                                .map((String item) => DropdownMenuItem<String>(
                                    child: Text(item), value: item))
                                .toList(),
                            onChanged: (value) async {
                              await setState(() {
                                print(value);
                                _selectedItem1 = value;
                              });
                            }),
                        TextFormField(
                          initialValue: paidby,
                          onChanged: (value4) {
                            setState(() {
                              paidby = value4;
                            });
                          },
                          // controller: _TextFormFieldController,
                          decoration: InputDecoration(hintText: paidby),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter paidby';
                            }
                            return null;
                          },
                        ),
                      ]))),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_editformKey.currentState.validate()) {
                          // codeDialog = valueText;
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Projects')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('project')
                                  .doc(id)
                                  .collection('expenses')
                                  .doc(exp["id"]);
                          documentReference.set({
                            "date": dat,
                            "category": _selectedItem,
                            "subcategory": _selectedItem2,
                            "paidby": paidby,
                            "description": description,
                            "amount": amount,
                            "type": _selectedItem1,
                            "id": documentReference.id.toString()
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

  // Future<void> _addcatdisplayTextInputDialog(BuildContext context) async {
  //   var uid = FirebaseAuth.instance.currentUser.uid;
  //   var cat;
  //   await FirebaseFirestore.instance
  //       .collection('Projects')
  //       .doc(uid)
  //       .collection('project')
  //       .doc(id)
  //       .get()
  //       .then((val) {
  //     if (val.data().length > 0) {
  //       cat = (val.data()['cateogries']);
  //       // print(val.data()['projectname']);
  //     } else {
  //       print("Not Found");
  //     }
  //   });
  //   List<String> cat_list = [];
  //   for (int i = 0; i < cat.length; i += 1) {
  //     cat_list.add(cat[i].toString());
  //   }
  //   var mycat;
  //   List<String> mycat_list = [];
  //   var _selectedItem;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('Categories')
  //         .doc(uid)
  //         .get()
  //         .then((val) async {
  //       if (val.data().length > 0) {
  //         mycat = val.data()['categories'];
  //         // print(val.data()['projectname']);
  //       } else {
  //         print("Not Found");
  //       }
  //     });
  //     for (int i = 0; i < mycat.length; i += 1) {
  //       mycat_list.add(mycat[i].toString());
  //     }
  //     _selectedItem = mycat_list[0];
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("First add some categories"),
  //     ));
  //     return null;
  //   }
  //   final _addformKey = GlobalKey<FormState>();
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Form(
  //             key: _addformKey,
  //             child: StatefulBuilder(builder: (context, setState) {
  //               return AlertDialog(
  //                 contentPadding: EdgeInsets.only(left: 25, right: 25),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //                 title: Center(
  //                     child: Text(
  //                   "Add Category",
  //                   style: TextStyle(
  //                       fontSize: 25.0,
  //                       color: Colors.black,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily: "Roboto"),
  //                 )),
  //                 content: DropdownButton(
  //                     value: _selectedItem,
  //                     items: mycat_list
  //                         .map((String item) => DropdownMenuItem<String>(
  //                             child: Text(item), value: item))
  //                         .toList(),
  //                     onChanged: (value) async {
  //                       setState(() {
  //                         print(value);
  //                         _selectedItem = value;
  //                       });
  //                     }),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       bool yes = true;
  //                       for (int i = 0; i < cat_list.length; i++) {
  //                         if (cat_list[i] == _selectedItem) {
  //                           yes = false;
  //                         }
  //                       }
  //                       if (_addformKey.currentState.validate() && yes) {
  //                         cat_list.add(_selectedItem);
  //                         // codeDialog = valueText;
  //                         DocumentReference documentReference =
  //                             FirebaseFirestore.instance
  //                                 .collection('Projects')
  //                                 .doc(FirebaseAuth.instance.currentUser.uid)
  //                                 .collection('project')
  //                                 .doc(id);

  //                         documentReference.update({
  //                           "cateogries": cat_list,
  //                         });
  //                       }
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('ADD'),
  //                     style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius:
  //                               BorderRadius.circular(3), // <-- Radius
  //                         ),
  //                         primary: Color(0xFF52595D)),
  //                   ),
  //                 ],
  //               );
  //             }));
  //       });
  // }

  String dat = '';
  String description = '';
  String amount = '';
  String paidby = '';
  List<String> _dropdownMenuItems = ["Cash", "Cheque"];
  List expenses = [];

  //   return DataTable(
  //     columns: getColumns(columns),
  //     rows: getRows(users),
  //   );
  // }

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
          user['category'],
          d,
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
                                          .collection('expenses')
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
                      _displayTextInputDialogedit(context, user);

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
          title: Text('Expenses'),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(
            //     Icons.add,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     _addcatdisplayTextInputDialog(context);
            //   },
            // ),
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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Projects')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('project')
                    .doc(id)
                    .collection('expenses')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  var allData;
                  var total = 0.0;
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
                  print(total);
                  final columns = [
                    'Expense Name',
                    'Date',
                    'Amount',
                    'Edit',
                    'Delete'
                  ];
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
                  String ex = "Total expense as of $d : $tot";

                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(name,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"))),
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
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text(
                                            ex,
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 18),
                                            // textAlign: TextAlign.center,
                                          )))),
                              // ],
                            ],
                          ),
                        ),
                      ),
                      FittedBox(
                          child: DataTable(
                        columnSpacing: 13,
                        columns: getColumns(columns),
                        rows: getRows(context, expenses),
                      ))
                    ],
                  );
                })));
  }
}
