import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/src/home/contact.dart';
import 'package:untitled3/src/home/course.dart';
import 'package:untitled3/src/home/labHome.dart';
import 'package:untitled3/src/home/members.dart';
import 'package:untitled3/src/home/gallery.dart';
import 'package:untitled3/src/home/about.dart';
import 'package:untitled3/src/home/publication.dart';
import 'package:untitled3/src/signInOut/login_signup_page.dart';
import 'package:untitled3/src/signInOut/root_page.dart';
import 'package:untitled3/src/signInOut/authentication.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//  final BaseAuth auth;
//  final VoidCallback onSignedOut;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      LabHome(),
      About(),
      Members(),
      Gallery(),
      Publication(),
//      CoursePage2(),
    ];
    final _kTabs = <Tab>[
      Tab(child: Text("HOME")),
      Tab(
        child: Text("RESEARCH"),
      ),
      Tab(
        child: Text("MEMBERS"),
      ),
      Tab(
        child: Text("GALLERY"),
      ),
      Tab(
        child: Text("PUBLICATION"),
      ),
//      Tab(child: Text("Course"),),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: email3 == "aldehf420@gmail.com"
              ? Center(child: Text("  ADMIN",textScaleFactor: 1,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),))
              : null,
          title: FlatButton(
            padding: EdgeInsets.all(0),
            child:
                Container(height: 100, child: Image.asset('images/logo.png')),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Contact()));
            },
          ),
          elevation: 0,
          actions: <Widget>[
            email3 == null
                ? IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RootPage(auth: Auth()))),
                  )
                : IconButton(
                    icon: Icon(Icons.person_outline),
                    onPressed: () => _showDialog(context),
                  )
          ],
          bottom: TabBar(
            indicatorColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.white54,
            labelColor: Colors.white,
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Do you want Sign Out?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                _firebaseAuth.signOut();
                setState(() {
                  email3 = null;
                });
                Navigator.of(context).pop();
              },
              textColor: Colors.blue,
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Colors.red,
            ),
          ],
        );
      },
    );
  }
}
