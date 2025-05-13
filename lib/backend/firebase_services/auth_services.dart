import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _authServices = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Enter Email and Password");
      }
      if (!(email.endsWith("@gmail.com") || email.endsWith("@vishnu.edu.in"))) {
        throw Exception("Enter a valid Vishnu or Gmail address");
      }
      UserCredential cred = await _authServices.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signup(String name, String email, String password) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception("Enter Name, Email and Password");
      }
      if (!(email.endsWith("@gmail.com") || email.endsWith("@vishnu.edu.in"))) {
        throw Exception("Enter a valid address");
      }
      UserCredential cred = await _authServices.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email Already Exists");
      } else {
        throw Exception(e.message ?? "Signup failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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

  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await _authServices.signInWithPopup(authProvider);
      User? user = userCredential.user;

      if (user != null) {
        if (!(user.email?.endsWith("@gmail.com") == true ||
            user.email?.endsWith("@vishnu.edu.in") == true)) {
          await _authServices.signOut();
          throw Exception(
              "Only @gmail.com or @vishnu.edu.in emails are allowed");
        }
        return user;
      }
      return null;
    } catch (e) {
      throw Exception("Google Sign-In failed: ${e.toString()}");
    }
  }
}
