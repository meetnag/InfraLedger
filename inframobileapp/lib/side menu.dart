import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/projects.dart';
import './screens/categories.dart';
import './screens/subcategories.dart';
import './screens/reports.dart';
import './screens/database.dart';
import './screens/login_screen.dart';

class NavDrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF52595D),
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage('assets/images/cover.jpg'))
            ),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text('Projects'),
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Projects()))
                  }),
          ListTile(
              leading: Icon(Icons.category_rounded),
              title: Text('Categories'),
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Categories()))
                  }),
          // ListTile(
          //     leading: Icon(Icons.category_outlined),
          //     title: Text('Sub Categories'),
          //     onTap: () => {
          //           Navigator.of(context).pop(),
          //           Navigator.of(context).pop(),
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => Subcategories()))
          //         }),
          ListTile(
              leading: Icon(Icons.file_copy_rounded),
              title: Text('Report'),
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Reports()))
                  }),
          ListTile(
              leading: Icon(Icons.table_rows_outlined),
              title: Text('Database'),
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Database()))
                  }),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async => {
              await _auth.signOut(),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()))
            },
          ),
        ],
      ),
    );
  }
}

// bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal[400],
//         currentIndex: _selectedScreenIndex,
//         type: BottomNavigationBarType.fixed,
//         onTap: _selectScreen,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Projects'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.category_rounded), label: "Categories"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.file_copy_rounded), label: "Reports"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.table_rows_outlined), label: "Database")
//         ],
//       ),
