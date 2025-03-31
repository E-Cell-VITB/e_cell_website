import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'custom_appbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: Drawer(
        backgroundColor: backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 72,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-Cell",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: "Lora",
                          ),
                        ),
                        Text(
                          "VITB",
                          style: TextStyle(
                            fontSize: 32,
                            color: secondaryColor,
                            fontFamily: "Lora",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildDrawerNavItem("Home", context, "/"),
              _buildDrawerNavItem("About", context, "/about"),
              _buildDrawerNavItem("Events", context, "/events"),
              _buildDrawerNavItem("Gallery", context, "/gallery"),
              _buildDrawerNavItem("Team", context, "/team"),
              _buildDrawerNavItem("Blogs", context, "/blogs"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: secondaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, JoinPage.joinPageRoute);
                    Navigator.pop(context);
                    context.go("/joinus");
                  },
                  child: Text(
                    "Join Us",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }

  Widget _buildDrawerNavItem(String title, BuildContext context, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          Icons.chevron_right, // Use a subtle icon for drawer items
          size: 20,
          color:
              Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        ),
        // hoverColor: secondaryColor.withOpacity(0.1),
        splashColor: secondaryColor.withOpacity(0.2),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          context.go(route); // Navigate to the specified route
        },
      ),
    );
  }
}
