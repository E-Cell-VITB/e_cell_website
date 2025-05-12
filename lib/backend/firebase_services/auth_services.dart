import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _authServices = FirebaseAuth.instance;

  //login
  Future<User?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Enter Email and Password");
      }
      if (!(email.endsWith("@gmail.com") || email.endsWith("@vishnu.edu.in"))) {
        throw Exception("Enter a valid Vishnu or Gmail address");
      }
      UserCredential _cred = await _authServices.signInWithEmailAndPassword(
          email: email, password: password);
      return _cred.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //signup
  Future<User?> signup(String name, String email, String password) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception("Enter Name,Email and Password");
      }
      if (!(email.endsWith("@gmail.com") || email.endsWith("@vishnu.edu.in"))) {
        throw Exception("Enter a valid address");
      }
      UserCredential _cred = await _authServices.createUserWithEmailAndPassword(
          email: email, password: password);
      return _cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email Already Exists");
      } else {
        throw Exception( e.message??  "signup failed");
      }
    } catch (e) {    
      throw Exception(e.toString());
    }
  }

  // Forgot Password
  Future<String> resetPassword(String email) async {
    String res = '';
    try {
      await _authServices.sendPasswordResetEmail(email: email);
      res = 'Password Reset Email Sent to $email';
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    return res;
  }
}
