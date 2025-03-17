import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              'assets/icons/logo.png',
              height: 46,
            ),
            if (isMobile)
              LinearGradientText(
                  child: Text(
                "E-Cell",
                style: Theme.of(context).textTheme.titleLarge,
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, JoinPage.joinPageRoute);
                },
                child: Text(
                  "Join Us",
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
