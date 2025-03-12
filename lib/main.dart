import 'package:e_cell_website/app/go_router_navigation.dart';
import 'package:e_cell_website/app/providers.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'E-Cell_VITB',
        // onGenerateRoute: AppNavigator.generateRoute,
        routerConfig: appRouter,
        theme: getAppTheme(),
        // home: const HomeScreen(),
      ),
    );
  }
}
