import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowEventBox {
  ShowEventBox(BuildContext context, int index, Event event) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 60,
            vertical: isMobile ? 24 : 40,
          ),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: linerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              height: isMobile ? null : size.height * 0.65,
              width: isMobile ? size.width * 0.9 : size.width * 0.6,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: eventBoxLinearGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.all(isMobile ? 20.0 : 35.0),
              child: isMobile
                  ? _buildMobileLayout(context, size, event)
                  : _buildDesktopLayout(context, size, event),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Size size, Event event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGradientTitle(event.name, size, isDesktop: true),
              const SizedBox(height: 10),
              _buildDescription(event.description, size, isDesktop: true),
              const SizedBox(height: 15),
              _buildReadMoreButton(context, size, event, isDesktop: true),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildImageContainer(event.bannerPhotoUrl, size, isDesktop: true),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, Size size, Event event) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGradientTitle(event.name, size, isDesktop: false),
          const SizedBox(height: 10),
          const SizedBox(height: 15),
          _buildDescription(event.description, size, isDesktop: false),
          const SizedBox(height: 15),
          Center(
            child: _buildReadMoreButton(context, size, event, isDesktop: false),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientTitle(String title, Size size,
      {required bool isDesktop}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: linerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: SelectableText(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: isDesktop ? size.width * 0.02 : 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildDescription(String description, Size size,
      {required bool isDesktop}) {
    return SelectableText(
      description.trim(),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: isDesktop ? size.width * 0.012 : 14,
        height: 1.5,
        color: Colors.white,
      ),
      maxLines: 8,
    );
  }

  Widget _buildReadMoreButton(BuildContext context, Size size, Event event,
      {required bool isDesktop}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.go('/events/${event.name.replaceAll(' ', '-')}',
              extra: event);
        },
        child: Container(
          height: isDesktop ? size.height * 0.05 : 40,
          width: isDesktop ? size.width * 0.09 : 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(colors: linerGradient),
          ),
          child: const Center(
            child: Text(
              "Read More",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl, Size size,
      {required bool isDesktop}) {
    return Container(
      height: isDesktop ? size.height * 0.50 : size.height * 0.2,
      width: isDesktop ? size.width * 0.2 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: imageUrl != ""
              ? NetworkImage(imageUrl)
              : const AssetImage("assets/icons/logo.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
