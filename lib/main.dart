import 'package:e_cell_website/app/go_router_navigation.dart';
import 'package:e_cell_website/app/providers.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

double? screensize;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery.of(context).size.width;
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

/// firebase hosting command

// firebase deploy --only hosting:ecell-vitb (use this only for main-website)
