import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String email2;
String studentID;
String major;
String name2;

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  final databaseReference = Firestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _email;
  String _password;
  String _studentID;
  String _name;
  String _major;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  void createRecord(
      String email, String major, String name, String studentID) async {
    await databaseReference.collection("student").document(email).setData({
      'email': email,
      'major': major,
      'name': name,
      'studentID': studentID,
      'grade_absent': 0,
      'grade_final': 0,
      'grade_mid': 0,
      'grade_quiz': 0,
      'grade_project':0,
      'img': 'https://i.stack.imgur.com/l60Hf.png',
    });
    await _firebaseMessaging.getToken().then((token) {
      print(token);
      Firestore.instance
          .collection('tokens')
          .document(email)
          .setData({
        'token': token,
        'quizNotification' : true,
        'noticeNotification' : true,
        'questionNotification' : true,
      }, merge: true);
    });
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password,context);
          print('Signed in: $userId');
        } else {
          email2 = _email;
          studentID = _studentID;
          major = _major;
          name2 = _name;
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          createRecord(email2, major, name2, studentID.toString());
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(height: 100, child: Image.asset('images/logo.png')),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Verify",style: TextStyle(color: Colors.blue),),
              onPressed: () {
                launch("https://mail.hanyang.ac.kr");
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showErrorMessage(),
              _showEmailInput(),
              _showPasswordInput(),
              _formMode == FormMode.LOGIN ? Text("") : _showStudentIdInput(),
              _formMode == FormMode.LOGIN ? Text("") : _showNameInput(),
              _formMode == FormMode.LOGIN ? Text("") : _showMajorInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.contains('@hanyang.ac.kr') || value == 'aldehf420@gmail.com' ||value=='admin@selab.com' ? null : 'Use Hanyang account',
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showStudentIdInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'studentID',
            icon: new Icon(
              Icons.perm_identity,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'StudentID can\'t be empty' : null,
        onSaved: (value) => _studentID = value.trim(),
      ),
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'name',
            icon: new Icon(
              Icons.contact_mail,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'StudentID can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget _showMajorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'major',
            icon: new Icon(
              Icons.collections_bookmark,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'StudentID can\'t be empty' : null,
        onSaved: (value) => _major = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.orangeAccent,
          child: _formMode == FormMode.LOGIN
              ? new Text('Login',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))
              : new Text('Create account',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            _formMode == FormMode.LOGIN? _validateAndSubmit():_showDialog(context);

          },
        ),
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
          content: new Text("Are you sure to Sign up?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                _validateAndSubmit();
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
