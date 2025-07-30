import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScheduleSection extends StatefulWidget {
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
  State<EventScheduleSection> createState() => _EventScheduleSectionState();
}

class _EventScheduleSectionState extends State<EventScheduleSection>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _staggerController;
  late Animation<double> _titleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    if (widget.provider.schedules.isNotEmpty) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _mainController.forward();
    _staggerController.forward();
  }

  @override
  void didUpdateWidget(EventScheduleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.schedules.isNotEmpty &&
        oldWidget.provider.schedules.isEmpty) {
      _startAnimations();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile
            ? 16
            : widget.isTablet
                ? 24
                : 32,
        vertical: widget.isMobile ? 20 : 32,
      ),
      child: Column(
        children: [
          if (widget.provider.isLoadingSchedules)
            SizedBox(
              height: screenHeight * 0.6,
              child: const Center(child: LoadingIndicator()),
            )
          else if (widget.provider.errorSchedules != null)
            _buildErrorWidget()
          else if (widget.provider.schedules.isNotEmpty) ...[
            AnimatedBuilder(
              animation: _titleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _titleAnimation.value)),
                  child: Opacity(
                    opacity: _titleAnimation.value,
                    child: _buildHeader(),
                  ),
                );
              },
            ),
            SizedBox(height: widget.isMobile ? 32 : 48),
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildScheduleLayout(screenWidth),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.all(widget.isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: widget.isMobile ? 24 : 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load schedule',
            style: TextStyle(
              fontSize: widget.isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.provider.errorSchedules ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: widget.isMobile ? 12 : 14,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Main Title
        LinearGradientText(
          child: Text(
            'Event Schedule',
            style: widget.isMobile
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 12),
        // Decorative elements
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.transparent, secondaryColor],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [secondaryColor, Colors.transparent],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Stay updated with our latest events and timings',
          style: TextStyle(
            fontSize: widget.isMobile ? 8 : 12,
            color: Colors.grey[400],
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScheduleLayout(double screenWidth) {
    if (widget.isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout(screenWidth);
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: widget.provider.schedules.asMap().entries.map((entry) {
        final index = entry.key;
        final schedule = entry.value;
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Column(
                  children: [
                    _buildEventCard(schedule, index),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDesktopLayout(double screenWidth) {
    final crossAxisCount = widget.isTablet ? 2 : 3;
    final cardWidth =
        (screenWidth - 64 - (crossAxisCount - 1) * 24) / crossAxisCount;

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: widget.provider.schedules.asMap().entries.map((entry) {
        final index = entry.key;
        final schedule = entry.value;
        return Opacity(
          opacity: 1.0,
          child: SizedBox(
            width: cardWidth,
            child: _buildEventCard(schedule, index),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventCard(dynamic schedule, int index) {
    final startTime =
        DateFormat('hh:mm a').format(schedule.scheduledTime.toDate());
    final endTime = schedule.expectedEndTime != null
        ? DateFormat('hh:mm a').format(schedule.expectedEndTime!.toDate())
        : null;

    return GradientBox(
      radius: 20,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: eventBoxLinearGradient,
          ),
          border: Border.all(
            color: secondaryColor.withOpacity(0.7),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        secondaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Number Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [secondaryColor, Color(0xFFFFD700)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        schedule.title,
                        style: const TextStyle(
                          color: backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Event Description
                    Text(
                      schedule.description,
                      style: TextStyle(
                        fontSize: widget.isMobile ? 14 : 15,
                        color: Colors.grey[300],
                        height: 1.4,
                      ),
                      maxLines: widget.isMobile ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),

                    // Time Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Start Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      color: secondaryColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Start',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  startTime,
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1,
                            height: 40,
                            color: secondaryColor.withOpacity(0.3),
                          ),

                          // End Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'End',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.stop_circle_outlined,
                                      color: endTime != null
                                          ? secondaryColor
                                          : Colors.grey[600],
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  endTime ?? 'TBD',
                                  style: TextStyle(
                                    color: endTime != null
                                        ? primaryColor
                                        : Colors.grey[500],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
