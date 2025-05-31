import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScheduleSection extends StatelessWidget {
  final OngoingEventProvider provider;
  final bool isMobile;
  final bool isTablet;

  const EventScheduleSection({
    required this.provider,
    required this.isMobile,
    required this.isTablet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        if (provider.isLoadingSchedules)
          SizedBox(
              height: screenHeight * 0.6,
              child: const Center(
                child: LoadingIndicator(),
              ))
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
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Table(
                    border: TableBorder.all(
                      color: secondaryColor.withOpacity(0.3),
                      width: 1,
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
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
                      TableRow(
                        decoration: const BoxDecoration(color: backgroundColor),
                        children: [
                          _buildTableHeader('Title'),
                          _buildTableHeader('Description'),
                          _buildTableHeader('Start Time'),
                          _buildTableHeader('End Time'),
                          _buildTableHeader('Status'),
                        ],
                      ),
                      ...provider.schedules.asMap().entries.map((entry) {
                        final index = entry.key;
                        final schedule = entry.value;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? const Color(0xFF303030).withOpacity(0.8)
                                : const Color(0xFF404040).withOpacity(0.8),
                          ),
                          children: [
                            _buildTableCell(schedule.title, maxLines: 2),
                            _buildTableCell(schedule.description,
                                maxLines: isMobile ? 2 : 3),
                            _buildTableCell(
                              DateFormat('dd-MM-yyyy HH:mm')
                                  .format(schedule.scheduledTime.toDate()),
                            ),
                            _buildTableCell(
                              schedule.expectedEndTime != null
                                  ? DateFormat('dd-MM-yyyy HH:mm').format(
                                      schedule.expectedEndTime!.toDate())
                                  : 'N/A',
                            ),
                            _buildTableCell(schedule.status),
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
      ],
    );
  }

  Widget _buildTableHeader(String text) {
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
          color: primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {int maxLines = 1}) {
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
