import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled3/src/startpage.dart';
import 'notice.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class AddNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notice'),
      ),
      body: AddNoticeForm(),
    );
  }
}

class AddNoticeForm extends StatefulWidget {
  @override
  AddNoticeFormState createState() {
    return AddNoticeFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddNoticeFormState extends State<AddNoticeForm> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  String title;
  String description;
  var platform = MethodChannel('crossingthestreams.io/resourceResolver');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextFormField(
              controller: _title,
              decoration: InputDecoration(hintText: 'Enter Title'),
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
              decoration: InputDecoration(hintText: 'Enter Description'),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Input Description.";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextFormField(
              controller: _name,
              decoration: InputDecoration(hintText: 'Enter Your Name'),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Input Name.";
                }
                return null;
              },
            ),
          ),
//          RaisedButton(
//            child: Text("test"),
//            onPressed: () async {
//              await _showNotification();
//            },
//          ),
          FlatButton(
            child: Text("test"),
            onPressed: () {
//              _showNotification();
            },
          ),
          FlatButton(
            child: Text("Post"),
            color: Colors.blueAccent,
            onPressed: () async{
              if (_formKey.currentState.validate()) {
                _showDialog(context, db);
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _showNotification(String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'SElab 공지사항', body, platformChannelSpecifics,
        payload: 'item x');
  }



  void _showDialog(BuildContext context, Firestore db) {
    // flutter defined function
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
                await db.collection('notice').add({
                  'title': _title.text,
                  'description': _description.text,
                  'name': _name.text,
                  'date': Timestamp.now()
                });
                _showNotification(_title.text);

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Notice()));
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