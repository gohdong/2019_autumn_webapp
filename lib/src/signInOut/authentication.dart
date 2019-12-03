import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/src/signInOut/islogin.dart';

String email3;



abstract class BaseAuth {
  Future<String> signIn(String email, String password,BuildContext context);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> changeEmail(String email);

  Future<void> changePassword(String password);

  Future<void> deleteUser();

  Future<void> sendPasswordResetMail(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password,BuildContext context) async {
    final counter = Provider.of<Counter>(context);
    if(email == 'aldehf420@gmail.com'){
      counter.admin();
    }else{
      counter.increment();
    }
    print('===========>'+email);
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    email3 = email;

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> changeEmail(String email) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updateEmail(email).then((_) {
      print("Succesfull changed email");
    }).catchError((error) {
      print("email can't be changed" + error.toString());
    });
    return null;
  }

  @override
  Future<void> changePassword(String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
    });
    return null;
  }

  @override
  Future<void> deleteUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.delete().then((_) {
      print("Succesfull user deleted");
    }).catchError((error) {
      print("user can't be delete" + error.toString());
    });
    return null;
  }

  @override
  Future<void> sendPasswordResetMail(String email) async{
    print('===========>'+email);
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }

}
