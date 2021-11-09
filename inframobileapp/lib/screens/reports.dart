import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
// import '../main.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../side menu.dart';

class Reports extends StatelessWidget {
  List<InvoiceItem> exp = [];
  List<FlatInvoiceItem> exp_flats = [];
  getExpenseItems(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => new InvoiceItem(
            category: (doc["category"]).toString(),
            subcategory: (doc["subcategory"]).toString(),
            date: DateTime.parse(doc["date"]),
            type: doc["type"].toString(),
            paidby: doc["paidby"].toString(),
            amount: double.parse(doc["amount"].toString())))
        .toList();
  }

  getFlatExpenseItems(QuerySnapshot<Map<String, dynamic>> snapshot, flat) {
    return snapshot.docs
        .map((doc) => new FlatInvoiceItem(
            flat: flat,
            date: DateTime.parse(doc["date"]),
            type: doc["type"].toString(),
            amount: double.parse(doc["amount"].toString())))
        .toList();
  }

  Future<List> getdata(
      BuildContext context, id, DateTime startDate, DateTime endDate) async {
    // ignore: await_only_futures
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('project')
        .doc(id)
        .collection('expenses')
        .get()
        .then((value) => exp = getExpenseItems(value));
    var ex;
    List<InvoiceItem> e = [];

    for (ex in exp) {
      // print("object");
      if (ex.date.compareTo(startDate) >= 0 &&
          ex.date.compareTo(endDate) <= 0) {
        // print("o1bject");
        // print(ex.date);
        e.add(ex);
      }
    }
    e.sort((a, b) => b.date.compareTo(a.date));
    return e;
  }

  Future<List> getdata_flats(
      BuildContext context, id, DateTime startDate, DateTime endDate) async {
    // ignore: await_only_futures
    var ex;
    await FirebaseFirestore.instance
        .collection('Projects')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('project')
        .doc(id)
        .get()
        .then((value) => ex = value.data()["flatsdone"]);
    print(ex);
    print("object");
    List<FlatInvoiceItem> e = [];
    for (var ee in ex) {
      await FirebaseFirestore.instance
          .collection('Projects')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('project')
          .doc(id)
          .collection('receipts')
          .doc(ee.toString())
          .collection('flatexpenses')
          .get()
          .then(
              (value) => exp_flats = getFlatExpenseItems(value, ee.toString()));

      for (var eex in exp_flats) {
        // print("object");
        // if (eex.date.compareTo(startDate) >= 0 &&
        //     eex.date.compareTo(endDate) <= 0) {
        // print("o1bject");
        print(eex.date);
        e.add(eex);
        // }
      }
    }
    // print(e[0]);
    e.sort((a, b) => b.date.compareTo(a.date));
    e.sort((a, b) => b.flat.compareTo(a.flat));

    return e;
  }

  Future<void> gen(BuildContext context, id, name, address, des,
      DateTime startDate, DateTime endDate) async {
    print(startDate);
    print(endDate);
    // await getdata(context, id);
    List<InvoiceItem> expenses = await getdata(context, id, startDate, endDate);
    List<FlatInvoiceItem> flatexpenses =
        await getdata_flats(context, id, startDate, endDate);
    if (expenses.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No expense between the given dates"),
      ));
      return;
    }
    // await Future.delayed(Duration(seconds: 3));
    print(flatexpenses);
    // var allData;
    // var total = 0;
    // var expenses;
    // var exp;
    // new
    // print(expenses[0]);
    // var ddd = {"category": "sdfsdf", "amount": "2342", "date": "2021-07-20"};
    // exp = (ddd as List).map((data) => new InvoiceItem.fromJson(data)).toList();
    // print("builder");
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: name,
        address: address,
        // paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      // customer: Customer(
      //   name: 'Apple Inc.',
      //   address: 'Apple Street, Cupertino, CA 95014',
      // ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: des,
        number: '${DateTime.now().year}-9999',
      ),
      items: expenses,
      flatitems: flatexpenses,
      // items: [
      //   InvoiceItem(
      //     description: 'Coffee',
      //     date: DateTime.now(),
      //     quantity: 3,
      //     vat: 0.19,
      //     unitPrice: 5.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Water',
      //     date: DateTime.now(),
      //     quantity: 8,
      //     vat: 0.19,
      //     unitPrice: 0.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Orange',
      //     date: DateTime.now(),
      //     quantity: 3,
      //     vat: 0.19,
      //     unitPrice: 2.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Apple',
      //     date: DateTime.now(),
      //     quantity: 8,
      //     vat: 0.19,
      //     unitPrice: 3.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Mango',
      //     date: DateTime.now(),
      //     quantity: 1,
      //     vat: 0.19,
      //     unitPrice: 1.59,
      //   ),
      //   InvoiceItem(
      //     description: 'Blue Berries',
      //     date: DateTime.now(),
      //     quantity: 5,
      //     vat: 0.19,
      //     unitPrice: 0.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Tushy',
      //     date: DateTime.now(),
      //     quantity: 4,
      //     vat: 0.19,
      //     unitPrice: 1.29,
      //   ),
      // ],
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice);

    PdfApi.openFile(pdfFile);
  }

  @override
  Widget build(BuildContext context) {
    final dateController1 = TextEditingController();
    final dateController2 = TextEditingController();
    List projects = [];
    var _selectedItem1;
    DateTime dat1;
    DateTime dat2;
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("REPORTS"),
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Projects')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('project')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              List<String> project = [];
              List<String> projectid = [];
              List<String> location = [];
              List<String> note = [];
              var ind = 0;
              try {
                final allData =
                    snapshot.data.docs.map((doc) => doc.data()).toList();

                // print(allData);
                // print(snapshot.data);
                projects = [];

                for (var i = 0; i < allData.length; i++) {
                  projects.add(allData[i]['projectname']);
                  projectid.add(allData[i]['id']);
                  location.add(allData[i]['location']);
                  note.add(allData[i]['notes']);
                }
                for (int i = 0; i < projects.length; ++i) {
                  project.add(projects[i].toString());
                }
                // print(projects);
                _selectedItem1 = projects[0];
              } catch (e) {
                _selectedItem1 = "None";
                // print(e);
                projects = [];
              }
              return Container(
                  padding: EdgeInsets.all(20.0),
                  child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(children: [
                          Text(
                            "Project  ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          DropdownButton(
                              isExpanded: true,
                              value: _selectedItem1,
                              items: project
                                  .map((String item) =>
                                      DropdownMenuItem<String>(
                                          child: Text(item), value: item))
                                  .toList(),
                              onChanged: (value) async {
                                print(value);
                                setState(() {
                                  _selectedItem1 = value;
                                  ind = project.indexOf(value);
                                });
                              }),
                          // ]),
                          const SizedBox(
                            // width: 200.0,
                            height: 50.0,
                            // child: Card(child: Text('Hello World!')),
                          ),
                          // Row(children: [
                          Text(
                            "Start Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: dateController1,
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

                              dateController1.text =
                                  date.toString().substring(0, 10);
                              dat1 = DateTime.parse(
                                  date.toString().substring(0, 10));
                              print(dat1);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            // width: 200.0,
                            height: 50.0,
                            // child: Card(child: Text('Hello World!')),
                          ),
                          // ]),
                          // Row(children: [
                          Text(
                            "End Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: dateController2,
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

                              dateController2.text =
                                  date.toString().substring(0, 10);
                              dat2 = DateTime.parse(
                                  date.toString().substring(0, 10));
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            // width: 200.0,
                            height: 50.0,
                            // child: Card(child: Text('Hello World!')),
                          ),
                          // ]),
                          ButtonWidget(
                            text: 'Project Report',
                            onClicked: () async {
                              await gen(context, projectid[ind], project[ind],
                                  location[ind], note[ind], dat1, dat2);
                            },
                          ),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: Text('Generate'),
                          //   style: ElevatedButton.styleFrom(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.circular(3), // <-- Radius
                          //       ),
                          //       primary: Color(0xFF52595D)),
                          // ),
                        ]);
                  }));
            }));
  }
}
