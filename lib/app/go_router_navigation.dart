import 'package:e_cell_website/screens/contact/contact_screen.dart';
import 'package:e_cell_website/screens/events/events_screen.dart';
import 'package:e_cell_website/screens/gallery/gallery_screen.dart';
import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:e_cell_website/screens/team/team_screen.dart';
import 'package:e_cell_website/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(250),
            child: CustomAppBar(),
          ),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const HomeScreen(section: 'about'),
        ),
        GoRoute(
          path: '/gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/team',
          builder: (context, state) => const TeamScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
      ],
    ),
  ],
);
