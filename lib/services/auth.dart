import 'package:firebase_auth/firebase_auth.dart';
import 'package:group/models/user.dart';

import 'apiCalls.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create User Object
  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid,name: "name") : null;
  }

  //auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Anon signin
  Future signInAnon() async {
    try {
      //AuthResult==UserCredential
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

 //email/pw signin
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//signout
  Future signUserOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
