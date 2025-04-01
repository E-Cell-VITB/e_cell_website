import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'subscription_form.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 720;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 1,
            width: size.width * 0.95,
            color: secondaryColor,
          ),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60,
              vertical: 30,
            ),
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ),

          // Copyright section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              '© ${DateTime.now().year} E-Cell, Vishnu Institute of Technology. All Rights Reserved.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and description section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              const SizedBox(height: 15),
              _buildDescription(),
              const SizedBox(height: 20),
              _buildSocialIcons(),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        // Quick links section
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Quick Links'),
              const SizedBox(height: 15),
              _buildQuickLinks(context),
            ],
          ),
        ),

        // Stay Updated section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Stay Updated!'),
              const SizedBox(height: 15),
              _buildSubscribeForm(),
              const SizedBox(height: 25),
              _buildSectionTitle('Connect With Us'),
              const SizedBox(height: 15),
              _buildContactInfo(),
            ],
          ),
        ),
      ],
    );
  }

  // Mobile layout
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and description section
        Center(child: _buildLogo()),
        const SizedBox(height: 15),
        _buildDescription(),
        const SizedBox(height: 20),
        Center(child: _buildSocialIcons()),
        const SizedBox(height: 30),

        // Quick links section
        _buildSectionTitle('Quick Links'),
        const SizedBox(height: 15),
        _buildQuickLinks(context),
        const SizedBox(height: 30),

        // Stay Updated section
        _buildSectionTitle('Stay Updated!'),
        const SizedBox(height: 15),
        _buildSubscribeForm(),
        const SizedBox(height: 25),

        // Connect with us section
        _buildSectionTitle('Connect With Us'),
        const SizedBox(height: 15),
        _buildContactInfo(),
      ],
    );
  }

  // Logo
  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/logo.png',
          height: 40,
          width: 40,
        ),
        const SizedBox(width: 10),
        const Text(
          'E-Cell VITB',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Description
  Widget _buildDescription() {
    return const SelectableText(
      """E-Cell, Vishnu Institute of Technology, empowers
students to turn ideas into startups through
mentorship, networking, and industry collaborations.""",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  // Social icons
  Widget _buildSocialIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _socialIcon('assets/icons/linkdein_icon.png',
            'https://www.linkedin.com/company/ecellvitb/'),
        const SizedBox(width: 15),
        _socialIcon(
            'assets/icons/instagram.png', 'https://instagram.com/ecell_vitb'),
        const SizedBox(width: 15),
        _socialIcon(
            'assets/icons/youtube.png', 'https://www.youtube.com/@ECellVITB'),
        const SizedBox(width: 15),
        _socialIcon('assets/icons/twitter.png', 'https://x.com/Ecellvitb'),
        const SizedBox(width: 15),
        _socialIcon('assets/icons/whatsapp.png',
            'https://whatsapp.com/channel/0029VatSc1XGufJ2ObNHI33M'),
      ],
    );
  }

  // Individual social icon
  Widget _socialIcon(String iconPath, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(6),
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   borderRadius: BorderRadius.circular(5),
        //   border: Border.all(color: const Color(0xFFC79200), width: 1),
        // ),
        child: Image.asset(
          iconPath,
          // color: const Color(0xFFC79200),
        ),
      ),
    );
  }

  // Section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFC79200),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Quick links
  Widget _buildQuickLinks(BuildContext context) {
    final links = [
      {'name': 'About', 'route': '/about'},
      {'name': 'Gallery', 'route': '/gallery'},
      {'name': 'Events', 'route': '/events'},
      {'name': 'Blogs', 'route': '/blogs'},
      {'name': 'Team', 'route': '/team'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links
          .map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, link['route']!);
                    context.go(link['route']!);
                  },
                  child: Text(
                    link['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  // Subscribe form
  Widget _buildSubscribeForm() {
    return const SubscriptionForm();

    //  Row(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         height: 40,
    //         decoration: BoxDecoration(
    //           color: const Color(0xFF333333),
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         child: const TextField(
    //           style: TextStyle(color: Colors.white),
    //           decoration: InputDecoration(
    //             contentPadding: EdgeInsets.symmetric(horizontal: 15),
    //             hintText: 'Enter your email',
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none,
    //           ),
    //         ),
    //       ),
    //     ),
    //     const SizedBox(width: 12),
    //     InkWell(
    //       onTap: () {},
    //       child: Container(
    //         height: 40,
    //         padding: const EdgeInsets.symmetric(horizontal: 15),
    //         decoration: BoxDecoration(
    //           gradient: const LinearGradient(colors: linerGradient),
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         child: const Center(
    //           child: Text(
    //             'Subscribe',
    //             style: TextStyle(
    //               color: Colors.black,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 14,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  // Contact info
  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Row(
        //   children: [
        //     Icon(
        //       Icons.phone,
        //       color: Color(0xFFC79200),
        //       size: 18,
        //     ),
        //     SizedBox(width: 10),
        //     SelectableText(
        //       '+91 9490 538 442',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 14,
        //       ),
        //     ),
        //   ],
        // ),
        InkWell(
          onTap: () => _launchUrl('mailto:e-cell@vishnu.edu.in'),
          child: const Row(
            children: [
              Icon(
                Icons.email,
                color: Color(0xFFC79200),
                size: 18,
              ),
              SizedBox(width: 10),
              Text(
                'e-cell@vishnu.edu.in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _launchUrl('mailto:president.ecell@vishnu.edu.in'),
          child: const Row(
            children: [
              Icon(
                Icons.email,
                color: Color(0xFFC79200),
                size: 18,
              ),
              SizedBox(width: 10),
              Text(
                'president.ecell@vishnu.edu.in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
