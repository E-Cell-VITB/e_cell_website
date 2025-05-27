import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/widgets/gradient_box_auth.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/count_down_time.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/evaluation_criteria.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/guests_and_judges.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/social_links.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OngoingEventDetails extends StatelessWidget {
  final String eventId;

  const OngoingEventDetails({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return ChangeNotifierProvider(
      create: (context) => OngoingEventProvider()
        ..fetchEventById(eventId)
        ..fetchSchedules(eventId)
        ..fetchUpdates(eventId),
      child: Scaffold(
        body: ParticleBackground(
          child: Consumer<OngoingEventProvider>(
            builder: (context, provider, child) {
              if (provider.isLoadingEvents) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: Colors.amberAccent));
              }
              if (provider.errorEvents != null) {
                return Center(
                  child: Text(
                    'Error: ${provider.errorEvents}',
                    style: TextStyle(
                        fontSize: isMobile
                            ? 14
                            : isTablet
                                ? 16
                                : 18,
                        color: Colors.redAccent),
                  ),
                );
              }
              final event = provider.currentEvent;
              if (event == null) {
                return Center(
                  child: Text(
                    'Event not found',
                    style: TextStyle(
                        fontSize: isMobile
                            ? 16
                            : isTablet
                                ? 18
                                : 20),
                  ),
                );
              }
              String remaining_days(DateTime date) {
                final now = DateTime.now();
                final difference = date.difference(now);

                if (difference.isNegative) {
                  return 'Event has ended';
                }

                final days = difference.inDays;
                final hours = difference.inHours % 24;
                final minutes = difference.inMinutes % 60;
                final seconds = difference.inSeconds % 60;

                if (days > 0) {
                  return '$days days left';
                } else if (hours > 0) {
                  return '$hours hours left';
                } else if (minutes > 0) {
                  return '$minutes minutes left';
                } else {
                  return '$seconds seconds left';
                }
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isMobile
                      ? 12.0
                      : isTablet
                          ? 18.0
                          : 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: isMobile ? screenWidth : 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LinearGradientText(
                            child: Text(
                              event.name,
                              style: isMobile
                                  ? Theme.of(context).textTheme.displayMedium
                                  : Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            event.description,
                            style: isMobile
                                ? Theme.of(context).textTheme.bodySmall
                                : Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.left,
                            maxLines: isMobile ? 4 : 6,
                          ),
                          const SizedBox(height: 16),
                          if (event.bannerPhotoUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(isMobile ? 9 : 18),
                              child: Image.network(
                                event.bannerPhotoUrl,
                                height: isMobile
                                    ? 100
                                    : isTablet
                                        ? 140
                                        : 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: isMobile
                                      ? 100
                                      : isTablet
                                          ? 140
                                          : 180,
                                  color: Colors.grey[800],
                                  child: const Center(
                                      child: Text('Image not available')),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (event.eventDate.isAfter(DateTime.now()))
                            CountdownTimerWidget(
                              startDateTime: event.eventDate,
                              endDateTime:
                                  event.estimatedEndTime ?? event.eventDate,
                              isMobile: isMobile,
                              screenWidth: screenWidth,
                            ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: isMobile
                                ? 8
                                : isTablet
                                    ? 12
                                    : 16,
                            runSpacing: isMobile
                                ? 8
                                : isTablet
                                    ? 12
                                    : 16,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildDetailTile(
                                context,
                                icon: Icons.calendar_month_outlined,
                                text: DateFormat('dd-MM-yyyy')
                                    .format(event.eventDate),
                                isMobile: isMobile,
                                isTablet: isTablet,
                              ),
                              _buildDetailTile(
                                context,
                                icon: Icons.location_on_outlined,
                                text: event.place,
                                isMobile: isMobile,
                                isTablet: isTablet,
                              ),
                              _buildDetailTile(
                                context,
                                icon: Icons.group_outlined,
                                text: event.isTeamEvent
                                    ? 'Team Event (Max ${event.maxTeamSize})'
                                    : 'Individual',
                                isMobile: isMobile,
                                isTablet: isTablet,
                              ),
                              if (event.prizePool != 0)
                                _buildDetailTile(
                                  context,
                                  icon: Icons.emoji_events_outlined,
                                  text: event.prizePool.toString(),
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                ),
                              _buildDetailTile(
                                context,
                                icon: Icons.access_time_outlined,
                                text: event.status,
                                isMobile: isMobile,
                                isTablet: isTablet,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Evaluation Criteria
                          if (event.evaluationTemplate.isNotEmpty) ...[
                            buildEvaluationCriteriaSection(
                              context,
                              event.evaluationTemplate,
                              isMobile,
                              isTablet,
                              screenWidth,
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Schedules
                          if (provider.isLoadingSchedules)
                            const CircularProgressIndicator(
                                color: Colors.amberAccent)
                          else if (provider.errorSchedules != null)
                            Text(
                              'Error: ${provider.errorSchedules}',
                              style: TextStyle(
                                fontSize: isMobile
                                    ? 12
                                    : isTablet
                                        ? 14
                                        : 16,
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else if (provider.schedules.isNotEmpty) ...[
                            LinearGradientText(
                              child: Text(
                                'Event Schedule',
                                style: isMobile
                                    ? Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth),
                                    child: Table(
                                      border: TableBorder.all(
                                        color: secondaryColor.withOpacity(0.3),
                                        width: 1,
                                        borderRadius: BorderRadius.circular(
                                            isMobile ? 8 : 12),
                                      ),
                                      columnWidths: {
                                        0: FixedColumnWidth(isMobile
                                            ? 100
                                            : isTablet
                                                ? 120
                                                : 150), // Title
                                        1: FixedColumnWidth(isMobile
                                            ? 120
                                            : isTablet
                                                ? 150
                                                : 200), // Description
                                        2: FixedColumnWidth(isMobile
                                            ? 100
                                            : isTablet
                                                ? 120
                                                : 140), // Time
                                        3: FixedColumnWidth(isMobile
                                            ? 100
                                            : isTablet
                                                ? 120
                                                : 140), // End Time
                                        4: FixedColumnWidth(isMobile
                                            ? 80
                                            : isTablet
                                                ? 100
                                                : 120), // Status
                                      },
                                      children: [
                                        // Header Row
                                        TableRow(
                                          decoration: const BoxDecoration(
                                              color: backgroundColor),
                                          children: [
                                            _buildTableHeader(
                                                'Title', isMobile, isTablet),
                                            _buildTableHeader('Description',
                                                isMobile, isTablet),
                                            _buildTableHeader('Start Time',
                                                isMobile, isTablet),
                                            _buildTableHeader(
                                                'End Time', isMobile, isTablet),
                                            _buildTableHeader(
                                                'Status', isMobile, isTablet),
                                          ],
                                        ),
                                        // Data Rows
                                        ...provider.schedules
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final schedule = entry.value;
                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color: index % 2 == 0
                                                  ? const Color(0xFF303030)
                                                      .withOpacity(0.8)
                                                  : const Color(0xFF404040)
                                                      .withOpacity(0.8),
                                            ),
                                            children: [
                                              _buildTableCell(schedule.title,
                                                  isMobile, isTablet,
                                                  maxLines: 2),
                                              _buildTableCell(
                                                  schedule.description,
                                                  isMobile,
                                                  isTablet,
                                                  maxLines: isMobile ? 2 : 3),
                                              _buildTableCell(
                                                DateFormat('dd-MM-yyyy HH:mm')
                                                    .format(schedule
                                                        .scheduledTime
                                                        .toDate()),
                                                isMobile,
                                                isTablet,
                                              ),
                                              _buildTableCell(
                                                schedule.expectedEndTime != null
                                                    ? DateFormat(
                                                            'dd-MM-yyyy HH:mm')
                                                        .format(schedule
                                                            .expectedEndTime!
                                                            .toDate())
                                                    : 'N/A',
                                                isMobile,
                                                isTablet,
                                              ),
                                              _buildTableCell(schedule.status,
                                                  isMobile, isTablet),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Updates
                          if (provider.isLoadingUpdates)
                            const CircularProgressIndicator(
                                color: Colors.amberAccent)
                          else if (provider.errorUpdates != null)
                            Text(
                              'Error: ${provider.errorUpdates}',
                              style: TextStyle(
                                fontSize: isMobile
                                    ? 12
                                    : isTablet
                                        ? 14
                                        : 16,
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else if (provider.updates.isNotEmpty) ...[
                            LinearGradientText(
                              child: Text(
                                'Event Updates',
                                style: isMobile
                                    ? Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: isMobile
                                  ? 12
                                  : isTablet
                                      ? 16
                                      : 24,
                              runSpacing: isMobile
                                  ? 12
                                  : isTablet
                                      ? 16
                                      : 24,
                              alignment: WrapAlignment.center,
                              children: provider.updates.map((update) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: isMobile
                                      ? screenWidth * 0.9
                                      : isTablet
                                          ? screenWidth * 0.45
                                          : 400,
                                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF404040)
                                            .withOpacity(0.9),
                                        const Color(0xFF303030)
                                            .withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: isMobile ? 6 : 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color:
                                          Colors.amberAccent.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        update.message,
                                        style: TextStyle(
                                          fontSize: isMobile
                                              ? 14
                                              : isTablet
                                                  ? 15
                                                  : 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        maxLines: isMobile ? 3 : 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (update.imageUrl != null &&
                                          update.imageUrl!.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              isMobile ? 8 : 12),
                                          child: Image.network(
                                            update.imageUrl!,
                                            width: double.infinity,
                                            height: isMobile
                                                ? 120
                                                : isTablet
                                                    ? 140
                                                    : 160,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              width: double.infinity,
                                              height: isMobile
                                                  ? 120
                                                  : isTablet
                                                      ? 140
                                                      : 160,
                                              color: Colors.grey[800],
                                              child: const Center(
                                                child: Text(
                                                  'Image not available',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        'Type: ${update.updateType}',
                                        style: TextStyle(
                                          fontSize: isMobile
                                              ? 12
                                              : isTablet
                                                  ? 13
                                                  : 14,
                                          color: Colors.grey[400],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        'Posted: ${DateFormat('dd-MM-yyyy HH:mm').format(update.timestamp.toDate())}',
                                        style: TextStyle(
                                          fontSize: isMobile
                                              ? 12
                                              : isTablet
                                                  ? 13
                                                  : 14,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Guests & Judges
                          if (event.jury.isNotEmpty) ...[
                            LinearGradientText(
                              child: Text(
                                'Guests & Judges',
                                style: isMobile
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            buildGuestsAndJudgesSection(event),
                            const SizedBox(height: 24),
                          ],
                          // Social Links
                          if (event.socialLink.isNotEmpty) ...[
                            LinearGradientText(
                              child: Text(
                                'Connect With Us',
                                style: isMobile
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            buildSocialLinksSection(event),
                            const SizedBox(height: 24),
                          ],
                          // Photos
                          if (event.allPhotos.isNotEmpty) ...[
                            LinearGradientText(
                              child: Text(
                                'Event Photos',
                                style: isMobile
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: isMobile
                                  ? 8
                                  : isTablet
                                      ? 12
                                      : 16,
                              runSpacing: isMobile
                                  ? 8
                                  : isTablet
                                      ? 12
                                      : 16,
                              children: event.allPhotos.map((photo) {
                                return ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(isMobile ? 6 : 12),
                                  child: Image.network(
                                    photo,
                                    width: isMobile
                                        ? 100
                                        : isTablet
                                            ? 120
                                            : 150,
                                    height: isMobile
                                        ? 100
                                        : isTablet
                                            ? 120
                                            : 150,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: isMobile
                                          ? 100
                                          : isTablet
                                              ? 120
                                              : 150,
                                      height: isMobile
                                          ? 100
                                          : isTablet
                                              ? 120
                                              : 150,
                                      color: Colors.grey[800],
                                      child: const Center(
                                          child: Text('Image not available')),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // // Register Button
                          // if (event.registrationEnds == null ||
                          //     event.registrationEnds!.isAfter(DateTime.now()))
                          //   GestureDetector(
                          //     onTap: () {
                          //       print(
                          //           'Navigating to /onGoingEvents/register/$eventId');
                          //       context.go('/onGoingEvents/register/$eventId');
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //         vertical: isMobile
                          //             ? 10
                          //             : isTablet
                          //                 ? 12
                          //                 : 15,
                          //         horizontal: isMobile
                          //             ? 20
                          //             : isTablet
                          //                 ? 25
                          //                 : 30,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         gradient: const LinearGradient(
                          //           colors: [
                          //             Color(0xFF00C4B4),
                          //             Color(0xFF0288D1),
                          //           ],
                          //         ),
                          //         borderRadius:
                          //             BorderRadius.circular(isMobile ? 7 : 12),
                          //       ),
                          //       child: Text(
                          //         'Register Now',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: isMobile
                          //               ? 14
                          //               : isTablet
                          //                   ? 16
                          //                   : 18,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // const SizedBox(height: 24),
                          //hi
                          if (event.registrationEnds == null ||
                              event.registrationEnds!.isAfter(DateTime.now()))
                            SizedBox(
                              width: isMobile
                                  ? screenWidth * 0.8
                                  : isTablet
                                      ? screenWidth * 0.5
                                      : screenWidth * 0.4,
                              height: isMobile
                                  ? 180
                                  : isTablet
                                      ? 200
                                      : 225, // Responsive height
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/ticket.png",
                                      height: isMobile
                                          ? 180
                                          : isTablet
                                              ? 200
                                              : 225, // Match SizedBox height
                                      width: isMobile
                                          ? screenWidth * 0.8
                                          : isTablet
                                              ? screenWidth * 0.5
                                              : screenWidth * 0.4,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                              "assets/images/Ecell.png",
                                              height: isMobile
                                                  ? 60
                                                  : isTablet
                                                      ? 120
                                                      : 180,
                                              width: isMobile
                                                  ? 60
                                                  : isTablet
                                                      ? 120
                                                      : 180,
                                              fit: BoxFit.cover,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                LinearGradientText(
                                                  child: Text(
                                                    "Grab your Spot",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: isMobile
                                                          ? 16
                                                          : isTablet
                                                              ? 20
                                                              : 25,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isMobile
                                                        ? 6
                                                        : isTablet
                                                            ? 10
                                                            : 15),
                                                // Time remaining
                                                Container(
                                                  height: isMobile
                                                      ? 18
                                                      : isTablet
                                                          ? 24
                                                          : 30,
                                                  width: isMobile
                                                      ? 80
                                                      : isTablet
                                                          ? 100
                                                          : 118,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 39, 39, 39),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      isMobile ? 15 : 20,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_outlined,
                                                        color: Colors.amber,
                                                        size: isMobile
                                                            ? 14
                                                            : isTablet
                                                                ? 16
                                                                : 18,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              isMobile ? 6 : 8),
                                                      LinearGradientText(
                                                        child: Text(
                                                          remaining_days(
                                                            event.registrationEnds ??
                                                                event.eventDate,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: isMobile
                                                                ? 10
                                                                : isTablet
                                                                    ? 12
                                                                    : 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isMobile
                                                        ? 6
                                                        : isTablet
                                                            ? 10
                                                            : 15),
                                                // Register button
                                                GestureDetector(
                                                  onTap: () {
                                                    final authProvider =
                                                        Provider.of<
                                                                AuthProvider>(
                                                            context,
                                                            listen: false);
                                                    if (authProvider
                                                            .currentUserModel ==
                                                        null) {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        showCustomToast(
                                                          title: "Hold Up!",
                                                          description:
                                                              "You need to log in before registering for an event.",
                                                        );
                                                      });

                                                      showDialog<bool>(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder:
                                                            (dialogContext) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.8,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              child:
                                                                  GradientBoxAuth(
                                                                radius: 16,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.8,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child: Consumer<
                                                                    AuthProvider>(
                                                                  builder:
                                                                      (context,
                                                                          auth,
                                                                          _) {
                                                                    return auth
                                                                        .page
                                                                        .widget;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((result) {
                                                        if (result == true &&
                                                            authProvider
                                                                    .currentUserModel !=
                                                                null) {
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            context.go(
                                                                '/onGoingEvents/register/${event.id}');
                                                          });
                                                        } else if (result !=
                                                            true) {
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            authProvider
                                                                .setPage(Pages
                                                                    .login);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        context.go(
                                                            '/onGoingEvents/register/${event.id}');
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: isMobile
                                                          ? 4
                                                          : isTablet
                                                              ? 8
                                                              : 10,
                                                      horizontal: isMobile
                                                          ? 12
                                                          : isTablet
                                                              ? 20
                                                              : 30,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        isMobile ? 5 : 7,
                                                      ),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors:
                                                                  linerGradient),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Register Now!",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: isMobile
                                                              ? 10
                                                              : isTablet
                                                                  ? 11
                                                                  : 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isMobile,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? 8
            : isTablet
                ? 10
                : 12,
        horizontal: isMobile
            ? 12
            : isTablet
                ? 14
                : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 9 : 18),
        color: const Color(0xFF303030),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.amberAccent,
            size: isMobile
                ? 16
                : isTablet
                    ? 20
                    : 24,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: isMobile
                    ? 12
                    : isTablet
                        ? 14
                        : 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isMobile
          ? 8
          : isTablet
              ? 10
              : 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile
              ? 12
              : isTablet
                  ? 14
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, bool isMobile, bool isTablet,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.all(isMobile
          ? 8
          : isTablet
              ? 10
              : 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile
              ? 10
              : isTablet
                  ? 12
                  : 14,
          color: Colors.grey[300],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
