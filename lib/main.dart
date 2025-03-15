import 'package:e_cell_website/app/go_router_navigation.dart';
import 'package:e_cell_website/app/providers.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double screensize=0;
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final screensize=MediaQuery.of(context).size.width;
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
