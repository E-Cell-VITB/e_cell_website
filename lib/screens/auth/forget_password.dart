import 'package:e_cell_website/backend/firebase_services/auth_services.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/widgets/custom_text_feild.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class ForgotPassword extends StatefulWidget {
  final String? email;
  const ForgotPassword({super.key, this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  bool isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String res =
            await AuthServices().resetPassword(emailController.text.trim());

        if (mounted) {
          setState(() {
            isLoading = false;
          });

          showCustomToast(
            title: 'Password Reset',
            description: res,
            type: ToastificationType.success,
          );
          // Navigate back after successful reset
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });

          showCustomToast(
            title: 'Error, Try again',
            description: e.toString(),
            type: ToastificationType.success,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 900;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isSmallScreen ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Card(
      elevation: 10,
      color: backgroundColor,
      margin: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          // Left side with image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Password Reset',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your email address and we will send you instructions to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side with form
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(48),
              child: _buildResetForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          Image.asset(
            'assets/icon/logo.png',
            height: 180,
          ),
          const SizedBox(height: 24),
          Text(
            'Password Reset',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter your email address and we will send you instructions to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 48),
          Card(
            color: backgroundColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildResetForm(),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildResetForm() {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * .2),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: const Text(
              'We will send you a password reset link',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          CustomTextFormField(
            controller: emailController,
            label: "Email",
            prefixicon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@gmail.com') &&
                  !value.contains('@vishnu.edu.in')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          SizedBox(height: screenHeight * 0.05),

          // Reset Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator(color: secondaryColor)
                  : const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Back to Login
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                // context.go('/login');
                Navigator.of(context).pop();
              },
              child: Text(
                "Back to Login",
                style: TextStyle(
                  color: Color(0x80FFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}