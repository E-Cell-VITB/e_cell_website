import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage404 extends StatelessWidget {
  const ErrorPage404({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: ParticleBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: isSmallScreen
                      ? screenSize.height * 0.2
                      : screenSize.height * 0.172,
                ),
                SizedBox(
                  width: 600,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: isSmallScreen ? 320 : 480,
                          padding: EdgeInsets.only(
                            left: isSmallScreen ? 30 : 40,
                            right: isSmallScreen ? 10 : 50,
                            top: isSmallScreen ? 20 : 30,
                            bottom: isSmallScreen ? 20 : 30,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: const Color(0xFFB38B00),
                                width: 1.5,
                              ),
                              gradient: const LinearGradient(
                                  colors: eventBoxLinearGradient)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "404",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 80 : 120,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 20 : 25),
                              InkWell(
                                onTap: () {
                                  context.go('/');
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 20 : 30,
                                    vertical: isSmallScreen ? 12 : 15,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: linerGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "Go to Home Page",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 16,
                          ),
                          width: isSmallScreen ? 140 : 220,
                          height: isSmallScreen ? 140 : 220,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFB38B00),
                                width: 1.5,
                              ),
                              gradient: const LinearGradient(
                                  colors: eventBoxLinearGradient)),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/icons/logo.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 40 : 50),
                // Error Messages
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isSmallScreen ? double.infinity : 800,
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        "THE RESOURCE YOU'RE LOOKING FOR IS EITHER UNAVAILABLE OR DOES NOT EXIST.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        "CLICK THE BUTTON ABOVE TO RETURN HOME AND KEEP EXPLORING.",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: isSmallScreen ? 14 : 16,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.2,
                ),
                const Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
