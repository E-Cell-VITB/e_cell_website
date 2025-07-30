import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class EventUpdates extends StatefulWidget {
  final OngoingEventProvider provider;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  const EventUpdates({
    required this.provider,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
    super.key,
  });

  @override
  State<EventUpdates> createState() => _EventUpdatesState();
}

class _EventUpdatesState extends State<EventUpdates>
    with TickerProviderStateMixin {
  late AnimationController _containerController;
  late AnimationController _contentController;
  late Animation<double> _containerAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _containerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _containerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _containerController,
        curve: Curves.easeOutCubic,
      ),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutBack,
    ));

    _startAnimations();
    _startAutoScroll();
  }

  void _startAnimations() {
    _containerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && widget.provider.updates.isNotEmpty) {
        _goToNextPage(widget.provider.updates.length);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _containerController.dispose();
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    final totalPages = widget.provider.updates.length;
    if (totalPages == 0) return;

    final targetPage = _currentPage > 0 ? _currentPage - 1 : totalPages - 1;
    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage(int totalPages) {
    if (totalPages == 0) return;

    final targetPage = _currentPage < totalPages - 1 ? _currentPage + 1 : 0;
    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _formatTime(dynamic timeValue) {
    if (timeValue == null) return '';

    DateTime? dateTime;

    if (timeValue is DateTime) {
      dateTime = timeValue;
    } else if (timeValue.runtimeType.toString() == 'Timestamp') {
      dateTime = (timeValue as dynamic).toDate();
    } else if (timeValue is String) {
      try {
        dateTime = DateTime.parse(timeValue);
      } catch (e) {
        try {
          dateTime = DateFormat('HH:mm').parse(timeValue);
        } catch (e2) {
          return timeValue;
        }
      }
    } else {
      return timeValue.toString();
    }

    return DateFormat('hh:mm a').format(dateTime ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_containerAnimation, _contentAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _containerAnimation.value),
          child: Opacity(
            opacity: _containerAnimation.value,
            child: _buildMainContainer(),
          ),
        );
      },
    );
  }

  Widget _buildMainContainer() {
    final containerSpecs = _getContainerSpecs();

    return Center(
      child: GradientBox(
        radius: 20,
        child: Container(
          width: containerSpecs['width'],
          height: containerSpecs['height'],
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: const LinearGradient(colors: eventBoxLinearGradient),
            borderRadius:
                BorderRadius.circular(containerSpecs['borderRadius'] ?? 0.0),
            border: Border.all(color: secondaryColor.withOpacity(0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(containerSpecs['padding'] ?? 0.0),
            child: widget.isMobile
                ? _buildMobileLayout(containerSpecs)
                : _buildDesktopLayout(containerSpecs),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Map<String, double> specs) {
    return Column(
      children: [
        _buildImageSection(specs),
        SizedBox(width: specs['spacing']),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildDesktopLayout(Map<String, double> specs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImageSection(specs),
        SizedBox(width: specs['spacing']),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildImageSection(Map<String, double> specs) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(_contentAnimation),
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Container(
          width: specs['imageWidth'],
          height: specs['imageHeight'],
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/anouncment.png',
                  width: specs['imageWidth'],
                  height: specs['imageHeight'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: specs['imageWidth'],
                    height: specs['imageHeight'],
                    color: backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[500],
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
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
  }

  Widget _buildContent() {
    return Consumer<OngoingEventProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingUpdates) {
          return _buildLoadingState();
        }
        if (provider.errorUpdates != null) {
          return _buildErrorState(provider.errorUpdates!);
        }
        if (provider.updates.isEmpty) {
          return _buildEmptyState();
        }
        return _buildUpdatesList(provider.updates);
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading updates...',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: widget.isMobile ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: widget.isMobile ? 32 : 40,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load updates',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: widget.isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: widget.isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: secondaryColor,
                  size: widget.isMobile ? 40 : 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "No Updates",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "No updates available at the moment.\nCheck back later for announcements!",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: widget.isMobile ? 14 : 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdatesList(List<dynamic> updates) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  final update = updates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: _buildUpdateCard(update, index),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (updates.length > 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widget.isMobile ? 32 : 35,
                    height: widget.isMobile ? 32 : 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _goToPreviousPage,
                        icon: Icon(
                          Icons.chevron_left,
                          color: secondaryColor,
                          size: widget.isMobile ? 16 : 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: updates.length,
                    effect: WormEffect(
                      activeDotColor: secondaryColor,
                      dotColor: Colors.grey.withOpacity(0.5),
                      dotHeight: widget.isMobile ? 8 : 10,
                      dotWidth: widget.isMobile ? 8 : 10,
                      // expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: widget.isMobile ? 32 : 35,
                    height: widget.isMobile ? 32 : 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => _goToNextPage(updates.length),
                        icon: Icon(
                          Icons.chevron_right,
                          color: secondaryColor,
                          size: widget.isMobile ? 16 : 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard(dynamic update, int index) {
    final formattedTime = _formatTime(update.updateLiveStartTime);

    return Container(
      padding: EdgeInsets.all(widget.isMobile ? 8 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (formattedTime.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: secondaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: secondaryColor,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: widget.isMobile ? 10 : 12,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: widget.isMobile ? 10 : 20,
                  height: 2,
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  update.title,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(widget.isMobile ? 14 : 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  update.message,
                  maxLines: widget.isMobile ? 7 : 4,
                  style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: widget.isMobile ? 12 : 13,
                      height: 1.4,
                      letterSpacing: 0.3,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _getContainerSpecs() {
    if (widget.isMobile) {
      return {
        'width': widget.screenWidth * 0.8,
        'height': 350.0,
        'borderRadius': 20.0,
        'padding': 8.0,
        'imageWidth': 100.0,
        'imageHeight': 100.0,
        'spacing': 0.0,
      };
    } else if (widget.isTablet) {
      return {
        'width': widget.screenWidth * 0.85,
        'height': 520.0,
        'borderRadius': 24.0,
        'padding': 28.0,
        'imageWidth': 160.0,
        'imageHeight': 160.0,
        'spacing': 24.0,
      };
    } else {
      return {
        'width': widget.screenWidth * 0.9,
        'height': 250.0,
        'borderRadius': 20.0,
        'padding': 16.0,
        'imageWidth': 200.0,
        'imageHeight': 200.0,
        'spacing': 0.0,
      };
    }
  }
}
