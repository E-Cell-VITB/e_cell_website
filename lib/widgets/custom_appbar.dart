import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/login.dart';
import 'package:e_cell_website/screens/auth/signup.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AuthProvider>(context);
    final currentuser = _provider.user;
    final username = _provider.Username;
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
                ],
              ),
            if (!isMobile)
              (_provider.user != null && _provider.Username != null)
                  ? DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                      value: username!,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.amberAccent),
                      items: [
                        DropdownMenuItem(
                          value: username,
                          child: Text(username!),
                        ),
                        DropdownMenuItem(
                          value: 'logout',
                          child: Text("Logout"),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == 'logout') {
                          _provider.logout(); // refresh UI
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
                          _provider.logout();
                        } else {
                          showDialog(
                              context: context,
                              builder: (dialogContext) {
                                final authprovider =
                                    Provider.of<AuthProvider>(dialogContext);

                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: GradientBox(
                                    radius: 8,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.7,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.30,
                                    child: authprovider.page == Pages.login
                                        ? Login()
                                        : Signup(),
                                  ),
                                );
                              }).then((_) {
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
