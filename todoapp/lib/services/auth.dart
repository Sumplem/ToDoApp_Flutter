import 'package:firebase_auth/firebase_auth.dart';


import '../models/user.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  // create user from firebaseuser
  UserModel? createFromFirebaseUSer(User? user) {
    return user != null ? UserModel(user.uid) : null;
  }

  // get chage
  Stream<UserModel?> get user {
    return auth
        .authStateChanges()
        .asyncMap((event) => createFromFirebaseUSer(event));
  }

  String? getUid() {
    return auth.currentUser?.uid;
  }

  // signin with email vs pass
  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      var result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return createFromFirebaseUSer(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
      }
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }


  // regis with email vs pass
  Future registerWithEmailAndPass(String email, String password) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return createFromFirebaseUSer(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  // signout
  Future signOut() async {
    try {
      return auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}
