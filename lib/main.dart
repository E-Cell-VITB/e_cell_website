import 'package:e_cell_website/app/go_router_navigation.dart';
import 'package:e_cell_website/app/providers.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/firebase_options.dart';
// import 'package:e_cell_website/services/const/toaster.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toastification/toastification.dart';
import 'package:seo/seo.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:web/web.dart';

// import 'certificate_gen/gertificate_generator.dart';

// import 'dart:async';

// import 'package:toastification/toastification.dart';

double? screensize;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleFonts.pendingFonts();
  // usePathUrlStrategy();
  // final uri = Uri.base;

  // if (!uri.path.contains('/#') && uri.path != '/') {
  //   final newUrl = '${uri.origin}/#${uri.path}';
  //   window.location.replace(newUrl);
  //   // print(newUrl);
  // } else {
  //   setUrlStrategy(const HashUrlStrategy());
  //   runApp(const MyApp());
  // }
  runApp(const MyApp());

  // runApp(const CertificateApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initial check
  //   _checkConnectivity();

  //   // Set up listener for connectivity changes
  //   _connectivitySubscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((List<ConnectivityResult> results) {
  //     if (results.contains(ConnectivityResult.none) || results.isEmpty) {
  //       _showNoInternetToast();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _connectivitySubscription.cancel();
  //   super.dispose();
  // }

  // Future<void> _checkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult.contains(ConnectivityResult.none) ||
  //       connectivityResult.isEmpty) {
  //     _showNoInternetToast();
  //   }
  // }

  // void _showNoInternetToast() {
  //   showCustomToast(
  //       title: "Internet Connection",
  //       description: "No internet connection",
  //       type: ToastificationType.warning);
  // }

  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: AppProviders.providers,
      child: ToastificationWrapper(
        child: SeoController(
          enabled: true,
          tree: WidgetTree(context: context),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'E-Cell VITB',
            // onGenerateRoute: AppNavigator.generateRoute,
            routerConfig: appRouter,
            theme: getAppTheme(),
            // home: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}
