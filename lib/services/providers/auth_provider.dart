import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/user.dart';
import 'package:e_cell_website/screens/auth/forgot_password.dart';
import 'package:e_cell_website/screens/auth/login.dart';
import 'package:e_cell_website/screens/auth/signup.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_cell_website/backend/firebase_services/auth_services.dart';

enum Pages {
  login,
  register,
  forgotPassword;

  Widget get widget {
    switch (this) {
      case Pages.login:
        return const Login();
      case Pages.register:
        return const Signup();
      case Pages.forgotPassword:
        return const ForgotPassword();
    }
  }
}

class AuthProvider with ChangeNotifier {
  Pages _page = Pages.login;
  Pages get page => _page;

  final AuthServices _authServices = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  UserModel? _currentUserModel;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  User? get user => _auth.currentUser;
  UserModel? get currentUserModel => _currentUserModel;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get username => _currentUserModel?.name;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    if (user != null) {
      fetchUserData();
    }
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUserModel = null;
        notifyListeners();
      } else if (_currentUserModel == null) {
        fetchUserData();
      }
    });
  }

  void setPage(Pages pageindicator) {
    _page = pageindicator;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        _setLoading(true);
        final snapshot =
            await _firestore.collection('users').doc(user!.uid).get();
        if (snapshot.exists && snapshot.data() != null) {
          _currentUserModel = UserModel.fromMap(snapshot.data()!);
          notifyListeners();
        } else {
          _errorMessage = 'User profile not found';
          notifyListeners();
        }
      } catch (e) {
        _errorMessage = 'Failed to fetch user data: ${e.toString()}';
        notifyListeners();
      } finally {
        _setLoading(false);
      }
    }
  }

  Future<User?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showCustomToast(
          title: 'Login Error', description: 'Please fill all fields');
      return null;
    }
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authServices.login(email, password);
      if (user != null) {
        await fetchUserData();
      }
      return user;
    } catch (e) {
      _errorMessage = 'Invalid credentials';
      showCustomToast(title: 'Login Error', description: _errorMessage!);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showCustomToast(
          title: 'Signup Error', description: 'Please fill all fields');
      return null;
    }
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authServices.signup(name, email, password);
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        UserModel userModel = UserModel(
          name: name,
          email: email,
          uid: currentUser.uid,
        );
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .set(userModel.toMap());
        _currentUserModel = userModel;
        notifyListeners();
        return currentUser;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      showCustomToast(title: 'Signup Error', description: _errorMessage!);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authServices.signInWithGoogle();
      if (user != null) {
        final snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (!snapshot.exists) {
          UserModel userModel = UserModel(
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            uid: user.uid,
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
          _currentUserModel = userModel;
        } else {
          _currentUserModel = UserModel.fromMap(snapshot.data()!);
        }
        notifyListeners();
        showCustomToast(
          title: 'Google Sign-In',
          description: 'Signed in successfully',
        );

        return user;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      showCustomToast(
          title: 'Google Sign-In Error', description: _errorMessage!);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _currentUserModel = null;
      showCustomToast(title: 'Logout', description: 'Logout Successfully');
    } catch (e) {
      _errorMessage = 'Failed to logout';
      showCustomToast(title: 'Logout Error', description: _errorMessage!);
    } finally {
      _setLoading(false);
    }
  }

  Future<String> resetPassword(String email) async {
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    _setLoading(true);
    String result;
    try {
      await _authServices.resetPassword(email);
      result = 'Password reset email sent to $email';
      showCustomToast(title: 'Password Reset', description: result);
    } on FirebaseAuthException catch (e) {
      result = e.message ?? 'An error occurred while resetting password';
      showCustomToast(title: 'Password Reset Error', description: result);
    } catch (e) {
      result = e.toString();
      showCustomToast(title: 'Password Reset Error', description: result);
    } finally {
      _setLoading(false);
    }
    return result;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
