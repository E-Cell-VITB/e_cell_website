import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/ongoing_events/results/results_page.dart';
import 'package:flutter/material.dart';

// Reusable Animated Flip Dialog
class FlipDialog {
  static void show(BuildContext context, {String? eventId}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _AnimatedFlipDialog(eventId: eventId);
      },
    );
  }
}

class _AnimatedFlipDialog extends StatefulWidget {
  final String? eventId;

  const _AnimatedFlipDialog({this.eventId});

  @override
  State<_AnimatedFlipDialog> createState() => _AnimatedFlipDialogState();
}

class _AnimatedFlipDialogState extends State<_AnimatedFlipDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _closeController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _closeSlideAnimation;
  late Animation<double> _closeScaleAnimation;

  bool _showFront = true;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _closeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    // Close animations (opposite direction)
    _closeSlideAnimation = Tween<double>(
      begin: 0.0,
      end: -50.0, // Slide up (opposite direction)
    ).animate(CurvedAnimation(
      parent: _closeController,
      curve: Curves.easeIn,
    ));

    _closeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _closeController,
      curve: Curves.easeIn,
    ));

    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= 0.5) {
        if (_showFront) {
          setState(() {
            _showFront = false;
          });
        }
      } else {
        if (!_showFront) {
          setState(() {
            _showFront = true;
          });
        }
      }
    });

    _closeController.addListener(() {
      setState(() {
        _isClosing = true;
      });
    });

    // Start animation immediately
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _closeController.dispose();
    super.dispose();
  }

  void _closeDialog() {
    _closeController.forward().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closeDialog();
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AnimatedBuilder(
          animation: _isClosing ? _closeController : _animationController,
          builder: (context, child) {
            final slideValue =
                _isClosing ? _closeSlideAnimation.value : _slideAnimation.value;
            final scaleValue =
                _isClosing ? _closeScaleAnimation.value : _scaleAnimation.value;

            return Transform.translate(
              offset: Offset(0, slideValue),
              child: Transform.scale(
                scale: scaleValue,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * 3.14159),
                  child: SizedBox(
                    width: _showFront
                        ? (MediaQuery.of(context).size.width < 600
                            ? MediaQuery.of(context).size.width * 0.9
                            : MediaQuery.of(context).size.width * 0.4)
                        : MediaQuery.of(context).size.width * 0.85,
                    height: _showFront
                        ? (MediaQuery.of(context).size.width < 600 ? 450 : 450)
                        : (MediaQuery.of(context).size.width < 600
                            ? MediaQuery.of(context).size.height * 0.7
                            : MediaQuery.of(context).size.width * 0.75),
                    child: _showFront
                        ? _buildFrontCard()
                        : _buildBackCard(eventId: widget.eventId),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_flipAnimation.value >= 0.5 ? 3.14159 : 0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: linerGradient,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  size: 60,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Results',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Loading your results...',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard({required String? eventId}) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;
    if (eventId == null) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(3.14159),
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: linerGradient,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 60,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Data Available',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Event ID not found',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(3.14159),
      child: GradientBox(
          width: double.infinity,
          height: double.infinity,
          radius: 16,
          child: ResultsScreen(
            eventId: eventId,
            isMobile: isMobile,
            isTablet: isTablet,
          )),
    );
  }
}
