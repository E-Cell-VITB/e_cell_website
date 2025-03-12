import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.homePageRoute:
        return MaterialPageRoute(builder: (context) => const HomePage());
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
