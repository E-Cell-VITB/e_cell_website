import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

// Reusable Animated Flip Dialog
class FlipDialog {
  static void show(BuildContext context, {List<MessageData>? messages}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _AnimatedFlipDialog(messages: messages);
      },
    );
  }
}

// Data model for messages
class MessageData {
  final String sender;
  final String message;
  final String time;
  final IconData icon;

  MessageData({
    required this.sender,
    required this.message,
    required this.time,
    required this.icon,
  });
}

class _AnimatedFlipDialog extends StatefulWidget {
  final List<MessageData>? messages;

  const _AnimatedFlipDialog({this.messages});

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

  List<MessageData> get _defaultMessages => [
        MessageData(
          sender: 'John Doe',
          message: 'Meeting tomorrow at 10 AM',
          time: '2 min ago',
          icon: Icons.person,
        ),
        MessageData(
          sender: 'Sarah Wilson',
          message: 'Project update required',
          time: '1 hour ago',
          icon: Icons.work,
        ),
        MessageData(
          sender: 'Team Lead',
          message: 'Code review completed',
          time: '3 hours ago',
          icon: Icons.code,
        ),
        MessageData(
          sender: 'HR Department',
          message: 'Monthly report submission',
          time: '1 day ago',
          icon: Icons.business,
        ),
      ];

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
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.85,
                    height: _showFront
                        ? 450
                        : MediaQuery.of(context).size.width * 0.75,
                    child: _showFront ? _buildFrontCard() : _buildBackCard(),
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

  Widget _buildBackCard() {
    final messages = widget.messages ?? _defaultMessages;

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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.inbox, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Messages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _closeDialog,
                    icon: const Icon(Icons.close, color: Colors.white70),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Text(
                '${messages.length} unread messages',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageItem(
                      message.sender,
                      message.message,
                      message.time,
                      message.icon,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Handle mark all as read
                      _closeDialog();
                    },
                    icon: const Icon(Icons.done_all,
                        color: Colors.white70, size: 18),
                    label: const Text(
                      'Mark All Read',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _closeDialog,
                    icon: const Icon(Icons.close,
                        color: Colors.white70, size: 18),
                    label: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(
      String sender, String message, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
