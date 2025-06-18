import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class EventUpdatesSection extends StatelessWidget {
  final OngoingEventProvider provider;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  const EventUpdatesSection({
    required this.provider,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Filter live updates
    final liveUpdates = provider.updates.where((update) {
      final startTime = update.updateLiveStartTime.toDate();
      final endTime = update.updateLiveEndTime.toDate();
      final now = DateTime.now();
      // AppLogger.log(
      //     'Update: ${update.message}, Start: $startTime, End: $endTime, IsLive: ${now.isAfter(startTime) && now.isBefore(endTime)}');
      return now.isAfter(startTime) && now.isBefore(endTime);
    }).toList();

    return Column(
      children: [
        if (provider.isLoadingUpdates)
          SizedBox(
            height: screenHeight * 0.6,
            child: const Center(
              child: LoadingIndicator(),
            ),
          )
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
        else if (liveUpdates.isNotEmpty) ...[
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
            children: liveUpdates.asMap().entries.map((entry) {
              final index = entry.key;
              final update = entry.value;
              final updateCount = liveUpdates.length;

              double containerWidth;
              if (isMobile) {
                containerWidth =
                    updateCount == 1 ? screenWidth * 0.9 : screenWidth * 0.85;
              } else if (isTablet) {
                containerWidth =
                    updateCount <= 2 ? screenWidth * 0.45 : screenWidth * 0.3;
              } else {
                containerWidth = updateCount < 2
                    ? 400
                    : updateCount <= 4
                        ? 300
                        : 250;
              }

              // Determine border color based on updateType
              Color borderColor;
              switch (update.updateType) {
                case 'Announcement':
                  borderColor = secondaryColor.withOpacity(0.5);
                  break;
                case 'Alert':
                  borderColor = Colors.redAccent.withOpacity(0.7);
                  break;
                case 'Info':
                  borderColor = Colors.blueAccent.withOpacity(0.7);
                  break;
                default:
                  borderColor = secondaryColor.withOpacity(0.3);
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: containerWidth,
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF404040).withOpacity(0.9),
                      const Color(0xFF303030).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: isMobile ? 6 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: primaryColor,
                      ),
                      maxLines: isMobile ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (update.imageUrl != null &&
                        update.imageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        child: InkWell(
                          onTap: () => _showImageDialog(context,
                              update.imageUrl!, index + 1, updateCount),
                          child: Image.network(
                            update.imageUrl!,
                            width: containerWidth -
                                (isMobile ? 24 : 32), // Account for padding
                            height: containerWidth -
                                (isMobile ? 24 : 32), // Square aspect ratio
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: containerWidth - (isMobile ? 24 : 32),
                                height: containerWidth - (isMobile ? 24 : 32),
                                color: Colors.white.withOpacity(0.2),
                                child: const Center(
                                  child: LoadingIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: containerWidth - (isMobile ? 24 : 32),
                              height: containerWidth - (isMobile ? 24 : 32),
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  void _showImageDialog(
      BuildContext context, String imageUrl, int index, int totalCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? 15 : 40),
          child: Container(
            width: isMobile ? screenWidth * 0.9 : screenWidth * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black87,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: isMobile ? 200 : 300,
                          width: double.infinity,
                          color: Colors.white.withOpacity(0.2),
                          child: const Center(
                            child: LoadingIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: isMobile ? 200 : 300,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Image $index of $totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
