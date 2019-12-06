import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/src/qna/question.dart';
import 'package:untitled3/src/qna/reply.dart';
import 'package:untitled3/src/signInOut/authentication.dart';
import 'package:untitled3/src/signInOut/root_page.dart';

class QNA extends StatefulWidget {
  @override
  _QNAState createState() => _QNAState();
}

class _QNAState extends State<QNA> with SingleTickerProviderStateMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
  }

  Widget storeTab() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.all(0),
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: new TabBar(
        controller: _controller,
        indicatorColor: Colors.orangeAccent,
        unselectedLabelColor: Colors.white54,
        labelColor: Colors.white,
        tabs: [
          new Tab(
            text: 'ALL',
          ),
          new Tab(
            text: 'CLASS',
          ),
          new Tab(
            text: 'LAB',
          ),
          new Tab(
            text: 'ETC',
          ),
        ],
      ),
    );
  }

  Widget storeTabView() {
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: <Widget>[
          questionAll(),
          questionClass(),
          questionLab(),
          questionEtc()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return email3 == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Image.asset('images/logo.png'),
                    margin: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(18))),
                FlatButton(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "SIGN ",
                        textScaleFactor: 3,
                      ),
                      Text(
                        "IN",
                        textScaleFactor: 3,
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RootPage(auth: new Auth())));
                  },
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title:
                  Container(height: 100, child: Image.asset('images/logo.png')),
              elevation: 0,
              leading: email3 == "aldehf420@gmail.com"
                  ? Center(
                      child: Text(
                      "  ADMIN",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ))
                  : null,
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
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add_comment,
                color: Colors.white,
              ),
              backgroundColor: Colors.white30,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddQuestion()));
              },
            ),
            body: Column(
              children: <Widget>[storeTab(), storeTabView()],
            ));
  }

  Widget questionAll() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('question')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildTile(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget questionClass() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('question')
          .where('category', isEqualTo: "Class")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildTile(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget questionLab() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('question')
          .where('category', isEqualTo: "Lab")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildTile(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget questionEtc() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('question')
          .where('category', isEqualTo: "Etc")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildTile(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget buildTile(DocumentSnapshot document) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 50, top: 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(18)),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      document['title'],
                      textScaleFactor: 2,
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    email3 == "aldehf420@gmail.com" || email3 == document['questioner']
                        ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          removeQuestion(document.documentID)
                        ],
                      ),
                    )
                        : Container()
                  ],
                ),
                Text(
                  document['description'],
                ),
                Divider(
                  thickness: 2,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      document['questioner']== "aldehf420@gmail.com"?
                      "By Admin": document['anonymous']?"By Anonymous":"By " + document['questioner'].split("@")[0],
                      style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            document['date']
                                .toDate()
                                .toString()
                                .split(':')[0] +
                                ":" +
                                document['date']
                                    .toDate()
                                    .toString()
                                    .split(':')[1],
                            style: TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            onPressed: () {
              email3 != null
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddReply(document.documentID)))
                  : null;
            },
          ),
        ),
        buildAnswer(document.documentID)
      ],
    );
  }

  Widget buildAnswer(String questionID) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('question').document(questionID).collection('reply')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return buildReplyTile(questionID,snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget buildReplyTile(String questionID,DocumentSnapshot document) {
    return Container(
      margin: EdgeInsets.only(left: 50, right: 10, top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.black26, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.subdirectory_arrow_right),
              Text(
                document['title'],
                textScaleFactor: 2,
                style: TextStyle(
                    color: Colors.cyanAccent, fontWeight: FontWeight.bold),
              ),
              email3 == "aldehf420@gmail.com" || email3 == document['writer']
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[removeAnswer(questionID,document)],
                      ),
                    )
                  : Container()
            ],
          ),
          Text(
            document['description'],
          ),
          Divider(
            thickness: 2,
          ),
          Row(
            children: <Widget>[
              Text(
                document['writer']== "aldehf420@gmail.com"?"By Admin":
                "By " + document['writer'].split('@')[0],
                style: TextStyle(
                    color: Colors.white70, fontStyle: FontStyle.italic),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      document['date'].toDate().toString().split(':')[0] +
                          ":" +
                          document['date'].toDate().toString().split(':')[1],
                      style: TextStyle(
                          color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _confirmDelQuestion(BuildContext context, String questionID) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Are you sure you want to delete it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await Firestore.instance
                    .collection('question')
                    .document(questionID)
                    .delete();
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

  void _confirmDelAnswer(BuildContext context, String questionID,DocumentSnapshot document) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Are you sure you want to delete it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await Firestore.instance
                    .collection('question')
                    .document(questionID).collection('reply').document(document.documentID)
                    .delete();
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

  Widget removeQuestion(String questionID) {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      onPressed: () {
        _confirmDelQuestion(context, questionID);
      },
    );
  }

  Widget removeAnswer(String questionID,DocumentSnapshot document) {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      onPressed: () {
        _confirmDelAnswer(context, questionID,document);
      },
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
