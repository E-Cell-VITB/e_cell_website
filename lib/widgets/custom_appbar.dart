import 'package:e_cell_website/const/theme.dart';

import 'package:e_cell_website/screens/auth/widgets/gradient_box_auth.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final currentuser = provider.user;
    final username = provider.username;
    // Check if the screen width is less than 768px (mobile view)
    bool isMobile = MediaQuery.of(context).size.width < 720;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: isMobile
                  ? () {
                      // Scaffold.of(context).openDrawer();
                      context.go('/');
                    }
                  : () {},
              child: Image.asset(
                'assets/icons/logo.png',
                height: 46,
              ),
            ),
            if (isMobile)
              LinearGradientText(
                  child: Text(
                "E-Cell",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Lora',
                    ),
              )),
            if (!isMobile)
              Row(
                children: [
                  _navItem("Home", context, "/"),
                  _navItem("About", context, "/about"),
                  _navItem("Events", context, "/events"),
                  _navItem("Gallery", context, "/gallery"),
                  _navItem("Team", context, "/team"),
                  _navItem("Blogs", context, "/blogs"),
                  _navItem("Ongoing", context, "/onGoingEvents"),
                ],
              ),
            if (!isMobile)
              (provider.user != null && provider.currentUserModel != null)
                  ? DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                      value: username!,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.amberAccent),
                      items: [
                        DropdownMenuItem(
                          value: username,
                          child: Text(username),
                        ),
                        const DropdownMenuItem(
                          value: 'logout',
                          child: Text("Logout"),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == 'logout') {
                          provider.logout(); // refresh UI
                        }
                      },
                    ))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (currentuser != null) {
                          provider.logout();
                        } else {
                          bool authSuccessful = false;
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  child: Consumer<AuthProvider>(
                                    builder: (context, auth, _) {
                                      if (auth.currentUserModel != null &&
                                          !authSuccessful) {
                                        authSuccessful = true;

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.of(dialogContext).pop(true);
                                        });
                                      }

                                      return GradientBoxAuth(
                                        radius: 16,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.8,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.4,
                                        child: auth.page.widget,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ).then((_) {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            authProvider.setPage(Pages.login);
                          });
                        }

                        // // Navigator.pushNamed(context, JoinPage.joinPageRoute);
                        // context.go("/joinus");
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu, size: 32, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String title, BuildContext context, String route) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: secondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.go(route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
