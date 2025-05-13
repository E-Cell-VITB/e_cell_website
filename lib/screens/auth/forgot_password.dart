import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/widgets/custom_text_feild.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  final String email;

  const ForgotPassword({
    super.key,
    this.email = '',
  });

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _emailSent = false;
  String _resultMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.isLoading;

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
          // Back button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                authProvider.setPage(Pages.login);
              },
            ),
          ),

          // Header
          Center(
            child: LinearGradientText(
              child: Text(
                "Reset Password",
                style: TextStyle(fontSize: headingSize),
              ),
            ),
          ),
          SizedBox(height: smallSpacing),
          Center(
            child: Text(
              _emailSent
                  ? "Check your email for password reset instructions"
                  : "Enter your email to receive a password reset link",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: subheadingSize),
            ),
          ),
          SizedBox(height: spacing),

          if (_emailSent && _resultMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: const Color.fromARGB(76, 230, 230, 230)),
              ),
              child: Text(
                _resultMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

          if (!_emailSent) ...[
            // Email input
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

            // Reset button
            SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : () => _handleResetPassword(authProvider),
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
                            "Send Reset Link",
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
          ] else ...[
            // Return to login button
            SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () => authProvider.setPage(Pages.login),
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
                    child: Text(
                      "Return to Login",
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
          ],
          SizedBox(height: spacing),

          // Login link
          if (!_emailSent)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Remember your password?",
                  style: TextStyle(fontSize: subheadingSize),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => authProvider.setPage(Pages.login),
                  child: LinearGradientText(
                    child: Text(
                      "Login here",
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

  void _handleResetPassword(AuthProvider authProvider) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _resultMessage = "Please enter your email address";
      });
      return;
    }

    final result = await authProvider.resetPassword(email);

    setState(() {
      _emailSent = true;
      _resultMessage = result;
    });
  }
}
