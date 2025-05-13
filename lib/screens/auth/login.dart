import 'package:e_cell_website/backend/models/user.dart';
import 'package:e_cell_website/const/theme.dart';

import 'package:e_cell_website/screens/auth/widgets/custom_text_feild.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.isLoading;
    final userModel = authProvider.currentUserModel;

    bool isMobile = MediaQuery.of(context).size.width < 600;

    final double headingSize = isMobile ? 28 : 32;
    final double subheadingSize = isMobile ? 10 : 12;

    final double buttonHeight = isMobile ? 46 : 50;
    final double buttonTextSize = isMobile ? 16 : 18;
    final double horizontalPadding =
        isMobile ? 20 : MediaQuery.of(context).size.width * 0.04;
    final double verticalPadding = isMobile ? 20 : 10;
    final double spacing = isMobile ? 14 : 18;
    final double smallSpacing = isMobile ? 6 : 8;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LinearGradientText(
              child: Text(
                "Login",
                style: TextStyle(fontSize: headingSize),
              ),
            ),
          ),
          SizedBox(height: smallSpacing),
          Center(
            child: Text(
              "Log in and be part of the E-Cell family",
              style: TextStyle(fontSize: subheadingSize),
            ),
          ),
          SizedBox(height: spacing),
          const LinearGradientText(
            child: Text(
              "Email",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: smallSpacing),
          CustomTextFormField(
            label: "Email",
            prefixIcon: Icons.email,
            controller: _emailController,
            hintText: "Enter email",
            isMobile: isMobile,
          ),
          SizedBox(height: spacing),
          const LinearGradientText(
            child: Text(
              "Password",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: smallSpacing),
          CustomTextFormField(
            label: "Password",
            prefixIcon: Icons.lock,
            controller: _passwordController,
            hintText: "Enter Password",
            isPassword: true,
            isMobile: isMobile,
          ),
          SizedBox(height: smallSpacing),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                authProvider.setPage(Pages.forgotPassword);
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _handleLogin(authProvider, userModel),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: linerGradient),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: buttonTextSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      await authProvider.signInWithGoogle();
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                side:
                    const BorderSide(color: Color.fromARGB(76, 230, 230, 230)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: Image.asset(
                      "assets/icons/google.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Login with Google",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: subheadingSize),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  authProvider.setPage(Pages.register);
                },
                child: LinearGradientText(
                  child: Text(
                    "Register here",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: subheadingSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogin(AuthProvider authProvider, UserModel? currentUser) async {
    if (currentUser != null) {
      authProvider.logout();
    } else {
      final user = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        showCustomToast(
          title: "Login",
          description: "Login Successfully",
        );
        Navigator.pop(context);
      }
    }
  }
}
