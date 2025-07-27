import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
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
  }

  void _startAnimations() {
    _containerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _containerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _formatTime(dynamic timeValue) {
    if (timeValue == null) return '';

    DateTime? dateTime;

    // Handle Firestore Timestamp
    if (timeValue is DateTime) {
      dateTime = timeValue;
    } else if (timeValue.runtimeType.toString() == 'Timestamp') {
      // Avoid direct import to keep this file decoupled from Firestore
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
      child: Container(
        width: containerSpecs['width'],
        height: containerSpecs['height'],
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2A2A2A),
              const Color(0xFF1F1F1F),
              const Color(0xFF252525),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius:
              BorderRadius.circular(containerSpecs['borderRadius'] ?? 0.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC79200).withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(containerSpecs['borderRadius'] ?? 0.0),
          child: Stack(
            children: [
              _buildBackgroundPattern(),
              Padding(
                padding: EdgeInsets.all(containerSpecs['padding'] ?? 0.0),
                child: widget.isMobile
                    ? _buildMobileLayout(containerSpecs)
                    : _buildDesktopLayout(containerSpecs),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFC79200).withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Map<String, double> specs) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
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

  Widget _buildHeader() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, Color(0xFFC79200)],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.campaign_outlined,
                  color: const Color(0xFFC79200),
                  size: widget.isMobile ? 20 : 24,
                ),
                const SizedBox(width: 8),
                LinearGradientText(
                  child: Text(
                    'Event Updates',
                    style: TextStyle(
                      fontSize: widget.isMobile
                          ? 20
                          : widget.isTablet
                              ? 24
                              : 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.campaign_outlined,
                  color: const Color(0xFFC79200),
                  size: widget.isMobile ? 20 : 24,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC79200), Colors.transparent],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Stay informed with the latest announcements',
              style: TextStyle(
                fontSize: widget.isMobile ? 12 : 14,
                color: Colors.grey[400],
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Map<String, double> specs) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset.zero,
      ).animate(_contentAnimation),
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Container(
          width: specs['imageWidth'],
          height: specs['imageHeight'],
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[800]!,
                          Colors.grey[700]!,
                        ],
                      ),
                    ),
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
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
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
              color: const Color(0xFFC79200).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC79200)),
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
                  color: const Color(0xFFC79200).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: const Color(0xFFC79200),
                  size: widget.isMobile ? 40 : 50,
                ),
              ),
              const SizedBox(height: 20),
              const LinearGradientText(
                child: Text(
                  "No Updates",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 8),
          itemCount: updates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final update = updates[index];
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 100)),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildUpdateCard(dynamic update, int index) {
    final formattedTime = _formatTime(update.updateLiveStartTime);

    return Container(
      padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF303030).withOpacity(0.8),
            const Color(0xFF252525).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC79200).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with time and title
          Row(
            children: [
              if (formattedTime.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC79200).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFC79200).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: const Color(0xFFC79200),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: const Color(0xFFC79200),
                          fontSize: widget.isMobile ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 20,
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC79200).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: LinearGradientText(
                  child: Text(
                    update.title,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Message content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.isMobile ? 14 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFF202020).withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC79200).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: SelectableText(
              update.message,
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: widget.isMobile ? 14 : 15,
                height: 1.4,
                letterSpacing: 0.3,
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
        'width': widget.screenWidth * 0.95,
        'height': 380.0,
        'borderRadius': 20.0,
        'padding': 20.0,
        'imageWidth': 0.0,
        'imageHeight': 0.0,
        'spacing': 0.0,
      };
    } else if (widget.isTablet) {
      return {
        'width': widget.screenWidth * 0.85,
        'height': 450.0,
        'borderRadius': 24.0,
        'padding': 28.0,
        'imageWidth': 160.0,
        'imageHeight': 160.0,
        'spacing': 24.0,
      };
    } else {
      return {
        'width': widget.screenWidth * 0.9,
        'height': 300.0,
        'borderRadius': 28.0,
        'padding': 36.0,
        'imageWidth': 200.0,
        'imageHeight': 200.0,
        'spacing': 32.0,
      };
    }
  }
}
