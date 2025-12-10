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
        ? 1.4
        : isTablet
            ? 0.7
            : 0.88;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isMobile
            ? 24
            : isTablet
                ? 32
                : 40,
        mainAxisSpacing: isMobile
            ? 32
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
                    padding: EdgeInsets.all(widget.isMobile ? 28 : 32),
                    child: Column(
                      children: [
                        _buildProfileSection(),
                        _buildInfoSection(),
                        const Spacer(),
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
    return Column(
      children: [
        // Profile image with hexagonal border
        Stack(
          alignment: Alignment.center,
          children: [
            // Animated ring
            if (_isHovered)
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.rotate(
                    angle: value * 2 * math.pi,
                    child: Container(
                      width: widget.isMobile ? 130 : 150,
                      height: widget.isMobile ? 130 : 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Color(0xffC79200),
                            Color(0xffFFE8A9),
                            Color(0xffC79200),
                            Color(0xffFFE8A9),
                          ],
                          stops: [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),

            Container(
              width: widget.isMobile ? 120 : 140,
              height: widget.isMobile ? 120 : 140,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0D0D0D),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? secondaryColor.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
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
                            Color(0xFF2A2A2A),
                            Color(0xFF1A1A1A),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.grey.withOpacity(0.4),
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
          ],
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Text(
          widget.member.name,
          style: TextStyle(
            fontSize: widget.isMobile ? 20 : 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // const SizedBox(height: 12),

        // // Animated gradient text for designation
        // ShaderMask(
        //   shaderCallback: (bounds) => const LinearGradient(
        //     colors: [secondaryColor, Color(0xFF6366f1)],
        //   ).createShader(bounds),
        //   child: Text(
        //     widget.member.designation.toUpperCase(),
        //     style: TextStyle(
        //       fontSize: widget.isMobile ? 13 : 14,
        //       fontWeight: FontWeight.w700,
        //       color: Colors.white,
        //       letterSpacing: 2.0,
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),

        // const SizedBox(height: 16),

        // // Modern department chip
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: secondaryColor.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(
        //       color: secondaryColor.withOpacity(0.3),
        //       width: 1.5,
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: 8,
        //         height: 8,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: secondaryColor,
        //           boxShadow: [
        //             BoxShadow(
        //               color: secondaryColor.withOpacity(0.8),
        //               blurRadius: 8,
        //               spreadRadius: 2,
        //             ),
        //           ],
        //         ),
        //       ),
        //       const SizedBox(width: 10),
        //       Text(
        //         widget.member.department,
        //         style: const TextStyle(
        //           fontSize: 12,
        //           color: secondaryColor,
        //           fontWeight: FontWeight.w700,
        //           letterSpacing: 1.0,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildIconButton(
              icon: Icons.link_rounded,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            'View Profile',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.withOpacity(0.5),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              secondaryColor.withOpacity(0.15),
              const Color(0xFF6366f1).withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: secondaryColor.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: secondaryColor,
          size: 20,
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    _buildProfileSection(),
                    // const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 15),
                    _buildContactSection(),
                    const SizedBox(height: 15),
                    _buildLinkedInButton(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_rounded,
                size: 16,
                color: secondaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'PROFILE',
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
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
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

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0A0A0A),
            ),
            padding: const EdgeInsets.all(5),
            child: ClipOval(
              child: Image.network(
                member.profileURL,
                fit: BoxFit.cover,
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
        const SizedBox(height: 28),
        Text(
          member.name,
          style: const TextStyle(
            fontSize: 32,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              const SizedBox(width: 12),
              Text(
                member.department,
                style: const TextStyle(
                  fontSize: 14,
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

  Widget _buildContactSection() {
    return Column(
      children: [
        if (member.email.isNotEmpty)
          _buildContactInfo(
            label: 'Email',
            value: member.email,
            icon: Icons.email_rounded,
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
          ),
      ],
    );
  }

  Widget _buildContactInfo({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
            size: 20,
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
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText(
                value,
                style: const TextStyle(
                  fontSize: 16,
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

  Widget _buildLinkedInButton() {
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              secondaryColor.withOpacity(0.2),
              const Color(0xFF6366f1).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secondaryColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.link_rounded,
              color: secondaryColor,
              size: 22,
            ),
            SizedBox(width: 12),
            Text(
              'View LinkedIn Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: secondaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
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
