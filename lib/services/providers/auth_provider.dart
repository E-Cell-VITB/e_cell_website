import "package:cloud_firestore/cloud_firestore.dart";
import "package:e_cell_website/backend/models/user.dart";
import "package:e_cell_website/services/const/toaster.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../backend/firebase_services/auth_services.dart";

enum Pages { login, register }

class AuthProvider with ChangeNotifier {
  Pages _page = Pages.login;
  Pages get page => _page;
  void setPage(Pages page) {
    _page = page;
    notifyListeners();
  }

  //login and sign up services
  final AuthServices _authServices = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? get user => FirebaseAuth.instance.currentUser;
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();
  String? _Username;
  String? get Username => _Username;

  Future<void> fetchUsername() async {
    if (user != null) {
      final snapshot = await _firestore
          .collection("users")
          .where('uid', isEqualTo: user!.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _Username = snapshot.docs.first.data()['name'];
        notifyListeners();
      }
    }
  }

  Future<User?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authServices.login(email, password);
      if (user != null) {
        await fetchUsername();
      }
      return user;
    } catch (e) {
      showCustomToast(title: "Login", description: "Invalid Credentials");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<User?> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authServices.signup(name, email, password);

      User? currentuser = FirebaseAuth.instance.currentUser;
      if (currentuser != null) {
        UserModel userModel =
            UserModel(name: name, email: email, uid: currentuser.uid);
        await _firestore
            .collection("users")
            .doc(currentuser.uid)
            .set(userModel.toMap());

        await fetchUsername();
        return currentuser;
      }
    } catch (e) {
      showCustomToast(
        title: "Signup Error",
        description: e.toString().replaceAll("Exception: ", "").trim(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    showCustomToast(title: "Logout", description: "Logout Succesffuly");
    notifyListeners();
  }
}
