import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/blogs/blogs_screen.dart';
import 'package:e_cell_website/screens/events/events_screen.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/gallery/gallery_screen.dart';
import 'package:e_cell_website/screens/home/home_page.dart';
import 'package:e_cell_website/screens/ongoing_events/ongoing_events_detail.dart';
import 'package:e_cell_website/screens/ongoing_events/ongoing_events.dart';
import 'package:e_cell_website/screens/ongoing_events/registration_form.dart';
import 'package:e_cell_website/screens/recruitment/applications/recruitment_form_screen.dart';
import 'package:e_cell_website/screens/recruitment/recruitment_list/user_open_recruitment.dart';
import 'package:e_cell_website/screens/team/team_screen.dart';
import 'package:e_cell_website/services/providers/events_provider.dart';
import 'package:e_cell_website/widgets/app_scaffold.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                path: ':eventParam',
                builder: (context, state) {
                  final eventData =
                      state.extra is Event ? state.extra as Event : null;

                  if (eventData != null) {
                    return EventDetails(event: eventData);
                  }

                  final param = state.pathParameters['eventParam'] ?? '';
                  final eventId = param.split('-').first;

                  return FutureBuilder<Event?>(
                    future: Provider.of<EventProvider>(context, listen: false)
                        .getEventById(eventId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: ParticleBackground(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const EventsScreen();
                      }

                      return EventDetails(event: snapshot.data!);
                    },
                  );
                },
                redirect: (context, state) async {
                  if (state.extra is Event) {
                    return null;
                  }

                  final param = state.pathParameters['eventParam'] ?? '';
                  if (param.isEmpty) {
                    return '/events';
                  }

                  final eventId = param.split('-').first;
                  if (eventId.isEmpty) {
                    return '/events';
                  }

                  final eventProvider =
                      Provider.of<EventProvider>(context, listen: false);
                  final event = await eventProvider.getEventById(eventId);

                  if (event == null) {
                    return '/events';
                  }

                  return null;
                },
              )
            ]),
        GoRoute(
          path: '/team',
          builder: (context, state) => const TeamScreen(),
          routes: [
            GoRoute(
              path: 'recruitment',
              name: 'recruitmentScreen',
              builder: (context, state) => const UserOpenRecruitmentsList(),
            ),
            GoRoute(
              path: 'recruitment/:id/:department',
              name: 'recruitmentApplications',
              builder: (context, state) {
                final recruitmentId = state.pathParameters['id']!;
                final department = state.pathParameters['department']!;
                return RecruitmentFormScreen(
                  recruitmentId: recruitmentId,
                  dept: department,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/blogs',
          builder: (context, state) => const BlogsScreen(),
        ),
        GoRoute(
            path: '/onGoingEvents',
            builder: (context, state) => const OngoingEventsPage(),
            routes: [
              GoRoute(
                path: ':eventId',
                builder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  return OngoingEventDetails(eventId: eventId);
                },
              ),
              GoRoute(
                path: '/register/:eventId',
                name: 'ongoingEventRegister',
                builder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  return OngoingEventRegister(
                    eventId: eventId,
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/joinus',
          builder: (context, state) => const HomeScreen(section: 'footer'),
        ),
      ],
    ),
  ],
);
