import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<String> currentUserId();
  Future<String> userEmail();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print('USERID : ' + authresult.user.uid);
    return authresult.user.uid;
  }

  Future<String> createUser(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return authresult.user.uid;
  }

  Future<FirebaseUser> user() async{
    return await _firebaseAuth.currentUser();
  }

  Future<String> currentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USERID : ' + user.uid);
    return user != null ? user.uid : null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> userEmail() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USER EMAIL : ' + user.email);
    return user != null ? user.email : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}