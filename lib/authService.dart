import 'package:firebase_auth/firebase_auth.dart';
import 'package:feedpage/user.dart';
import 'package:feedpage/userService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/globals.dart' as globals;

class AuthService {
  final GoogleSignIn _gauth = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  User _FromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, isVerified: user.isEmailVerified) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _FromFirebaseUser(user));
  }

  //sign in with gmail
  Future gSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _gauth.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      globals.assert_1 = false;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final AuthResult authResult =
      await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      final snapShot =
      await Firestore.instance.collection('Users').document(user.uid).get();
      String username = user.email.split('@')[0];
      if (snapShot == null || !snapShot.exists) {
        UserService userService = UserService(uid: user.uid);
        await userService.updateUserData(user.email, username, true);
        user.sendEmailVerification();
      }
      globals.assert_1 = true;
      return 1;
    } catch (e) {
      globals.assert_1 = true;
      print(e);
      return null;
    }
  }

  //sign in with email
  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _FromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register
  Future register(String email, String password, String username) async {
    try {
      QuerySnapshot query = await Firestore.instance.collection('Users').where('username', isEqualTo: username).getDocuments();
      if(query.documents.isNotEmpty){
        return 1;
      }
      globals.assert_1 = false;
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await user.sendEmailVerification();
      //create the database instance
      await UserService(uid: user.uid).updateUserData(email, username, false);
      globals.assert_1=true;
      return _FromFirebaseUser(user);
    } catch (e) {
      globals.assert_1=true;
      print(e.toString());
      return null;
    }
  }

  //sign out
  // ignore: non_constant_identifier_names
  Future SignOut() async {
    try {
      await _auth.signOut();
      await _gauth.signOut();
      return 1;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reset password
  // ignore: non_constant_identifier_names
  Future ResetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //change password
  Future ChangePassword(String password) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user.updatePassword(password);
      return 1;
    } catch (e) {
      return null;
    }
  }
}