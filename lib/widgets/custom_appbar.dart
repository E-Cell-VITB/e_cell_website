import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor, // Dark Background
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
