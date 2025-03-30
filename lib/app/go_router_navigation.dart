import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/screens/blogs/blogs_screen.dart';
import 'package:e_cell_website/screens/events/events_screen.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/gallery/gallery_screen.dart';
import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:e_cell_website/screens/team/team_screen.dart';
import 'package:e_cell_website/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'error_404.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  errorBuilder: (context, state) {
    return const ErrorPage404();
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(child: child);
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
            routes: [
              GoRoute(
                path: ':eventName',
                builder: (context, state) {
                  final eventData =
                      state.extra is Event ? state.extra as Event : null;

                  if (eventData == null) {
                    return const EventsScreen();
                  }

                  return EventDetails(
                    event: eventData,
                  );
                },
                redirect: (context, state) {
                  final eventData =
                      state.extra is Event ? state.extra as Event : null;

                  if (eventData == null) {
                    return '/events';
                  }

                  return null;
                },
              ),
            ]),
        GoRoute(
          path: '/team',
          builder: (context, state) => const TeamScreen(),
        ),
        GoRoute(
          path: '/blogs',
          builder: (context, state) => const BlogsScreen(),
        ),
        GoRoute(
          path: '/joinus',
          builder: (context, state) => const HomeScreen(section: 'footer'),
        ),
      ],
    ),
  ],
);
