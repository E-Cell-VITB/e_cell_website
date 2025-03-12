import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

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
                _navItem("Home", context),
                _navItem("About", context),
                _navItem("Events", context),
                _navItem("Gallery", context),
                _navItem("Team", context),
                _navItem("Contact", context),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                // foregroundColor: Colors.black, // Black Text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text("Join Us"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String title, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: secondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(250);
}
