import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool noticeNotification=true;
  bool quizNotification=true;
  bool questionNotification=true;

  @override
  void initState() {
    super.initState();

    getUser().then((user) {
      if (user != null) {
        // send the user to the home page
//        counter.increment();
        setState(() {
          email3 = user.email;
        });

        print(user);
      }
    });
    getUserNotificationSetting();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

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
              ? Center(
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      _settingModalBottomSheet(context);
                    },
                    child: Text(
                    "  ADMIN",
                    textScaleFactor: 1,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                  ))
              : email3 == null
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => _settingModalBottomSheet(context),
                    ),
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
                    onPressed: () => _confirmSignOut(context),
                  ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.white54,
            labelColor: Colors.white,
            tabs: _kTabs,
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }

  Future<void> getUserNotificationSetting() async {
    var document =
        await Firestore.instance.collection('tokens').document(email3).get();
    setState(() async{
      noticeNotification = document['noticeNotification'];
      quizNotification = document['quizNotification'];
      questionNotification = document['questionNotification'];
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: new Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          "Push Notification",
                          textScaleFactor: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Notice"),
                                Checkbox(
                                  value: noticeNotification,
                                  onChanged: (bool value) {
                                    setState(() {
                                      noticeNotification = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Question"),
                                Checkbox(
                                  value: questionNotification,
                                  onChanged: (bool value) {
                                    setState(() {
                                      questionNotification = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Quiz"),
                                Checkbox(
                                  value: quizNotification,
                                  onChanged: (bool value) {
                                    setState(() {
                                      quizNotification = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(color: Colors.orangeAccent),
                          child: Center(child: Text("Update"))),
                      onPressed: () {
                        _confirmUpdateNotification(context);
                      },
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _confirmSignOut(BuildContext context) {
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

  void _confirmUpdateNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Do you want Update"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await Firestore.instance
                    .collection('tokens')
                    .document(email3)
                    .updateData({
                  'noticeNotification': noticeNotification,
                  'quizNotification': quizNotification,
                  'questionNotification': questionNotification,
                });
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
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
