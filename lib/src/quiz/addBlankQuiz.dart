import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class BlankQuiz extends StatefulWidget {
  @override
  _BlankQuizState createState() => _BlankQuizState();
}

class _BlankQuizState extends State<BlankQuiz> {
  TextEditingController _first = TextEditingController();
  TextEditingController _blank = TextEditingController();
  TextEditingController _second = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String startTimeString = "Start Time";
  String endTimeString = "End Time";
  DateTime startTime = DateTime.now();
  DateTime endTime = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
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
                          hintText: 'First Sentence'),
                      controller: _first,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Input Sentence.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      controller: _blank,
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
                          hintText: 'Blank'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Input Blank.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: TextFormField(
                      controller: _second,
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
                          hintText: 'Second Sentence'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Input Sentence.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              startTime = date;
                              startTimeString = startTime.toString().split(':')[0] +
                                  ":" +
                                  startTime.toString().split(':')[1];
                            });

                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.ko);
                    },
                    child: Text(
                      startTimeString,
                      style: TextStyle(color: Colors.orangeAccent),
                    )),
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              endTime = date;
                              endTimeString = endTime.toString().split(':')[0] +
                                  ":" +
                                  endTime.toString().split(':')[1];
                            });

                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.ko);
                    },
                    child: Text(
                      endTimeString,
                      style: TextStyle(color: Colors.orangeAccent),
                    )),
              ),
            ],
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
                await Firestore.instance.collection('quiz').add({
                  'question': _first.text + "\\blank\\" + _second.text,
                  'answer': _blank.text,
                  'type': "blank",
                  'startTime': startTime,
                  'endTime': endTime
                });

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
