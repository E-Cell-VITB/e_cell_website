import 'package:e_cell_website/screens/gallery/gallery_screen.dart';
import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.homeScreenRoute:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case GalleryScreen.galleryScreenRoute:
        return MaterialPageRoute(builder: (context) => const GalleryScreen());
      // case '/about':
      //   return MaterialPageRoute(builder: (context) => AboutPage());
      default:
        // return MaterialPageRoute(builder: (context) => HomePage());
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('Undefined route'),
        ),
      );
    });
  }
}
