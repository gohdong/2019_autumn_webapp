import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:untitled3/src/signInOut/authentication.dart';

class AddReply extends StatefulWidget {
  String questionId;

  AddReply(String getID) {
    this.questionId = getID;
  }

  @override
  _AddReplyState createState() => _AddReplyState(questionId);
}

class _AddReplyState extends State<AddReply> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  String questionId;

  _AddReplyState(String getID) {
    this.questionId = getID;
  }

//  TextEditingController _second = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(height: 100, child: Image.asset('images/logo.png')),
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      decoration: new InputDecoration(
                          labelStyle: TextStyle(color: Colors.orange),
                          fillColor: Colors.orange,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.orange),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.orange),
                          ),
                          hintText: 'Title'),
                      controller: _title,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Input Title.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      controller: _description,
                      decoration: new InputDecoration(
                          labelStyle: TextStyle(color: Colors.orange),
                          fillColor: Colors.orange,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.orange),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.orange),
                          ),
                          hintText: 'Answer'),
                      maxLines: 10,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Fill the box";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              child: Text("GO!"),
              color: Colors.orangeAccent,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _showDialog(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Alert"),
          content: new Text("Are you sure to add it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await Firestore.instance.collection('question')
                    .document(questionId).collection('reply').add({
                  'title': _title.text,
                  'description': _description.text,
                  'date': DateTime.now(),
                  'question': questionId,
                  'writer' : email3
                });

                await _firebaseMessaging.getToken().then((token) {
                  print(token);
                  Firestore.instance
                      .collection('question')
                      .document(questionId).collection('participants').document(email3)
                      .setData({
                    'token': token,
                  }, merge: true);
                });

//                await Firestore.instance
//                    .collection('question')
//                    .document(questionId).collection('reply').document(email3)
//                    .updateData({"reply": true});

//                Navigator.of(context)
//                    .popUntil(MaterialPageRoute(builder: (context) => Notice()));
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
