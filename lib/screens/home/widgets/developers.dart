import 'package:flutter/material.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/backend/models/team_member.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class DevelopersScreen extends StatelessWidget {
  const DevelopersScreen({super.key});

  static List<TeamMemberModel> developerMembers = [
    TeamMemberModel(
      id: '1',
      name: 'Narasimha Naidu',
      designation: 'Lead',
      department: 'Technical',
      email: 'narasimhanaidu1909@gmail.com',
      phoneNumber: '+91 8125150264',
      linkedInProfileURL:
          'https://www.linkedin.com/in/narasimhanaidukorrapati/',
      profileURL:
          'https://res.cloudinary.com/dhh9hnl5f/image/upload/v1742719993/E-cell_Admin/qiri8khcif2zd9hxwxk2.png',
    ),
    TeamMemberModel(
      id: '2',
      name: 'Lokesh Surya Prakash',
      designation: 'Co-Lead',
      department: 'Technical',
      email: 'lokeshsuryaprakashk@gmail.com',
      phoneNumber: '+91 6303642297',
      linkedInProfileURL:
          'https://www.linkedin.com/in/lokesh-surya-prakash-konduboyena-2b556726b/',
      profileURL:
          'https://res.cloudinary.com/dhh9hnl5f/image/upload/v1742747208/E-cell_Admin/s0gynsbqbz7vgrvqnszb.png',
    ),
    TeamMemberModel(
      id: '3',
      name: 'Sri Ram Ganesh',
      designation: 'Lead',
      department: 'Design',
      email: 'sriramganesh28@gmail.com',
      phoneNumber: '+91 9603204860',
      linkedInProfileURL: 'https://www.linkedin.com/in/sriramganeshgovala/',
      profileURL:
          'https://res.cloudinary.com/dhh9hnl5f/image/upload/v1748785017/E-cell_Admin/tgubql9g8dxsldxy17hb.png',
    ),
    TeamMemberModel(
      id: '4',
      name: 'Gowthami Tirumalareddy',
      designation: 'Associate',
      department: 'Technical',
      email: 'gowthamitirumalareddy@gmail.com',
      phoneNumber: '+91 9381900860',
      linkedInProfileURL:
          'https://www.linkedin.com/in/gowthami-tirumalareddy-%E2%9C%B7-b228132bb/',
      profileURL:
          'https://res.cloudinary.com/dhh9hnl5f/image/upload/v1748863087/E-cell_Admin/zkpt00vntolb76b8drrp.png',
    ),
    TeamMemberModel(
      id: '5',
      name: 'Sandeep Kumar',
      designation: 'Associate',
      department: 'Technical',
      email: 'gummalasandy191212@gmail.com',
      phoneNumber: '+91 9491701393',
      linkedInProfileURL:
          'https://www.linkedin.com/in/gummala-sagar-sandeep-kumar-a23aa8304/',
      profileURL:
          'https://res.cloudinary.com/dhh9hnl5f/image/upload/v1748781952/E-cell_Admin/mtydzcpladcojmpa4evu.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;
    final isDesktop = size.width >= 1024;

    return SingleChildScrollView(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              secondaryColor.withOpacity(0.05),
              const Color(0xFF6366f1).withOpacity(0.02),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            ...List.generate(12, (index) {
              return Positioned(
                left: (index * 123.0) % size.width,
                top: (index * 87.0) % (size.height * 0.8),
                child: _FloatingParticle(index: index),
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? 20.0
                    : isTablet
                        ? 40.0
                        : 80.0,
                vertical: isMobile
                    ? 60.0
                    : isTablet
                        ? 80.0
                        : 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTitleSection(context, isMobile, isTablet),
                  SizedBox(
                      height: isMobile
                          ? 60
                          : isTablet
                              ? 70
                              : 80),
                  _buildDevelopersGrid(size, isMobile, isTablet, isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(
      BuildContext context, bool isMobile, bool isTablet) {
    return Column(
      children: [
        // Badge style header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secondaryColor.withOpacity(0.1),
                const Color(0xFF6366f1).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: secondaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                color: secondaryColor,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'MEET THE TEAM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: secondaryColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 24 : 32),

        // Main title with animated gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.white,
              Color(0xffC79200),
              Color(0xffFFE8A9),
              Color(0xffC79200),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ).createShader(bounds),
          child: Text(
            'Built With Passion',
            style: TextStyle(
              fontSize: isMobile
                  ? 40
                  : isTablet
                      ? 56
                      : 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.0,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: isMobile ? 16 : 20),

        // Subtitle with better styling
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Discover the talented individuals who architected and crafted the E-Cell digital experience',
            style: TextStyle(
              fontSize: isMobile
                  ? 16
                  : isTablet
                      ? 18
                      : 20,
              color: const Color(0xFFB8B8B8),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDevelopersGrid(
    Size size,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 1;
    } else if (isTablet) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = developerMembers.length > 2 ? 3 : 2;
    }

    final childAspectRatio = isDesktop
        ? 1.2
        : isTablet
            ? 0.9
            : size.width < 330
                ? 1.15
                : size.width < 380
                    ? 1.33
                    : 1.55;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isMobile
            ? 16
            : isTablet
                ? 32
                : 40,
        mainAxisSpacing: isMobile
            ? 16
            : isTablet
                ? 40
                : 48,
      ),
      itemCount: developerMembers.length,
      itemBuilder: (context, index) {
        return _DeveloperCard(
          member: developerMembers[index],
          isMobile: isMobile,
          isTablet: isTablet,
          index: index,
        );
      },
    );
  }
}

// Floating particle animation for background
class _FloatingParticle extends StatefulWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + widget.index % 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_controller.value * 2 * math.pi) * 20,
            math.cos(_controller.value * 2 * math.pi) * 20,
          ),
          child: Container(
            width: 4 + (widget.index % 3) * 2,
            height: 4 + (widget.index % 3) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  secondaryColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DeveloperCard extends StatefulWidget {
  final TeamMemberModel member;
  final bool isMobile;
  final bool isTablet;
  final int index;

  const _DeveloperCard({
    required this.member,
    required this.isMobile,
    required this.isTablet,
    required this.index,
  });

  @override
  State<_DeveloperCard> createState() => _DeveloperCardState();
}

class _DeveloperCardState extends State<_DeveloperCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: GestureDetector(
        onTap: () => _showDeveloperDetails(context),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (0.03 * _animationController.value),
              child: Transform.rotate(
                angle: (widget.index % 2 == 0 ? 1 : -1) *
                    0.01 *
                    _animationController.value,
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1C1C1C),
                  Color(0xFF0D0D0D),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                if (_isHovered)
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 0,
                  )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Mesh gradient background
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MeshGradientPainter(
                        isHovered: _isHovered,
                        animation: _animationController,
                      ),
                    ),
                  ),

                  // Glass morphism overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(_isHovered ? 0.08 : 0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Border effect
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _isHovered
                              ? secondaryColor.withOpacity(0.6)
                              : Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: EdgeInsets.all(widget.isMobile ? 22 : 32),
                    child: Column(
                      children: [
                        _buildProfileSection(),
                        SizedBox(
                          height: widget.isMobile ? 10 : 15,
                        ),
                        _buildInfoSection(),
                        SizedBox(height: widget.isMobile ? 10 : 15),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gradient ring
            if (_isHovered)
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 3),
                builder: (context, double value, child) {
                  return Transform.rotate(
                    angle: value * 2 * math.pi,
                    child: Container(
                      width: widget.isMobile ? 12 : 152,
                      height: widget.isMobile ? 12 : 152,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            secondaryColor,
                            secondaryColor.withOpacity(0.1),
                            secondaryColor,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Profile image container
            Container(
              width: widget.isMobile ? 100 : 180,
              height: widget.isMobile ? 100 : 180,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0a0a15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isHovered
                        ? secondaryColor.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.member.profileURL,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2A2A3E),
                              Color(0xFF1A1A2E),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: secondaryColor.withOpacity(0.3),
                          size: 50,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: secondaryColor,
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Sparkle effect on hover
            if (_isHovered)
              Positioned(
                top: 10,
                right: 15,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: value,
                        child: const Icon(
                          Icons.auto_awesome,
                          color: secondaryColor,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Text(
          widget.member.name,
          style: TextStyle(
            fontSize: widget.isMobile ? 18 : 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (!_isHovered) {
      return Row(
        children: [
          Expanded(
            child: _buildIconButton(
              icon: Icons.email_rounded,
              label: 'Email',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _buildIconButton(
              icon: Icons.link_rounded,
              label: 'LinkedIn',
              onTap: () {},
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            'View Profile',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              secondaryColor.withOpacity(0.1),
              secondaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: secondaryColor,
              size: 16,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: secondaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperDetails(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => _DeveloperDetailsDialog(
        member: widget.member,
      ),
    );
  }
}

// Custom painter for mesh gradient effect
class _MeshGradientPainter extends CustomPainter {
  final bool isHovered;
  final Animation<double> animation;

  _MeshGradientPainter({required this.isHovered, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create multiple gradient circles
    final centers = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
    ];

    for (var i = 0; i < centers.length; i++) {
      paint.shader = RadialGradient(
        colors: [
          (i % 2 == 0 ? secondaryColor : const Color(0xFF6366f1))
              .withOpacity(isHovered ? 0.15 : 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7],
      ).createShader(Rect.fromCircle(
        center: centers[i],
        radius: size.width * 0.4 * (1 + animation.value * 0.2),
      ));

      canvas.drawCircle(centers[i], size.width * 0.4, paint);
    }
  }

  @override
  bool shouldRepaint(_MeshGradientPainter oldDelegate) => true;
}

class _DeveloperDetailsDialog extends StatelessWidget {
  final TeamMemberModel member;

  const _DeveloperDetailsDialog({required this.member});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14, vertical: isMobile ? 10 : 20),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: 540,
            minHeight: isMobile ? size.height * 0.8 : size.height * 0.9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1F1F),
              Color(0xFF0A0A0A),
            ],
          ),
          border: Border.all(
            width: 2,
            color: secondaryColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: secondaryColor.withOpacity(0.2),
              blurRadius: 50,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background effect
            Positioned.fill(
              child: CustomPaint(
                painter: _DialogBackgroundPainter(),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 25,
                    vertical: isMobile ? 10 : 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: isMobile ? 20 : 5),
                    _buildProfileSection(context),
                    SizedBox(height: isMobile ? 10 : 15),
                    _buildDivider(),
                    SizedBox(height: isMobile ? 10 : 15),
                    _buildContactSection(context),
                    SizedBox(height: isMobile ? 25 : 30),
                    _buildLinkedInButton(isMobile: isMobile),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secondaryColor.withOpacity(0.2),
                const Color(0xFF6366f1).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: secondaryColor.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_rounded,
                size: isMobile ? 8 : 16,
                color: secondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: isMobile ? 8 : 11,
                  fontWeight: FontWeight.w700,
                  color: secondaryColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    return Column(
      children: [
        Container(
          width: isMobile ? 140 : 180,
          height: isMobile ? 140 : 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            gradient: const SweepGradient(
              colors: [
                secondaryColor,
                Color(0xffFFE8A9),
                secondaryColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xFF0A0A0A),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipRect(
              child: Image.network(
                member.profileURL,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2A2A2A),
                          Color(0xFF1A1A1A),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.grey.withOpacity(0.4),
                      size: 80,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 20 : 10),
        Text(
          member.name,
          style: TextStyle(
            fontSize: isMobile ? 22 : 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              secondaryColor,
              Color(0xffFFE8A9),
            ],
          ).createShader(bounds),
          child: Text(
            member.designation.toUpperCase(),
            style: TextStyle(
              fontSize: isMobile ? 12 : 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 8),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: secondaryColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: secondaryColor.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 6 : 10),
              Text(
                member.department,
                style: TextStyle(
                  fontSize: isMobile ? 8 : 12,
                  color: secondaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            secondaryColor.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    return Column(
      children: [
        if (member.email.isNotEmpty)
          _buildContactInfo(
            label: 'Email',
            value: member.email,
            icon: Icons.email_rounded,
            isMobile: isMobile,
          ),
        if (member.email.isNotEmpty &&
            member.phoneNumber != null &&
            member.phoneNumber!.isNotEmpty)
          const SizedBox(height: 24),
        if (member.phoneNumber != null && member.phoneNumber!.isNotEmpty)
          _buildContactInfo(
            label: 'Phone',
            value: member.phoneNumber ?? '',
            icon: Icons.phone_rounded,
            isMobile: isMobile,
          ),
      ],
    );
  }

  Widget _buildContactInfo({
    required String label,
    required String value,
    required IconData icon,
    required bool isMobile,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: secondaryColor.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            color: secondaryColor,
            size: isMobile ? 12 : 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 12,
                  color: Colors.grey.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkedInButton({required bool isMobile}) {
    if (member.linkedInProfileURL.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () async {
        final url = Uri.parse(member.linkedInProfileURL);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: SizedBox(
        width: isMobile ? 150 : 200,
        height: isMobile ? 30 : 45,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secondaryColor.withOpacity(0.2),
                const Color.fromARGB(255, 199, 199, 0).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: secondaryColor.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.link_rounded,
                color: secondaryColor,
                size: isMobile ? 8 : 16,
              ),
              const SizedBox(width: 12),
              Text(
                'View LinkedIn Profile',
                style: TextStyle(
                  fontSize: isMobile ? 8 : 12,
                  fontWeight: FontWeight.w700,
                  color: secondaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for animated dialog background
class _DialogBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create animated gradient mesh in dialog
    final gradients = [
      Offset(size.width * 0.2, size.height * 0.1),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.9),
    ];

    for (var i = 0; i < gradients.length; i++) {
      paint.shader = RadialGradient(
        colors: [
          (i % 2 == 0 ? secondaryColor : const Color(0xFF6366f1))
              .withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6],
      ).createShader(
        Rect.fromCircle(
          center: gradients[i],
          radius: size.width * 0.35,
        ),
      );

      canvas.drawCircle(gradients[i], size.width * 0.35, paint);
    }
  }

  @override
  bool shouldRepaint(_DialogBackgroundPainter oldDelegate) => false;
}
