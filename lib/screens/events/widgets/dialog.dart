import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/evntdetails.dart';
import 'package:flutter/material.dart';

class ShowEventBox {
  ShowEventBox(BuildContext context, int index) {
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
                  ? _buildMobileLayout(context, size)
                  : _buildDesktopLayout(context, size),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGradientTitle(context, size, isDesktop: true),
              const SizedBox(height: 10),
              _buildDescription(size, isDesktop: true),
              const SizedBox(height: 15),
              _buildReadMoreButton(context,size, isDesktop: true),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildImageContainer(size, isDesktop: true),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGradientTitle(context, size, isDesktop: false),
          const SizedBox(height: 10),
          // if(!isMobile)  _buildImageContainer(size, isDesktop: false),
          const SizedBox(height: 15),
          _buildDescription(size, isDesktop: false),
          const SizedBox(height: 15),
          Center(child: _buildReadMoreButton(context, size, isDesktop: false)),
        ],
      ),
    );
  }

  Widget _buildGradientTitle(BuildContext context, Size size,
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
        'TechSprouts 2K25',
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

  Widget _buildDescription(Size size, {required bool isDesktop}) {
    return SelectableText(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.....",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: isDesktop ? size.width * 0.012 : 14,
        height: 1.5,
        color: Colors.white,
      ),
    );
  }

  Widget _buildReadMoreButton(BuildContext context,Size size, {required bool isDesktop}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Eventdetails()));
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

  Widget _buildImageContainer(Size size, {required bool isDesktop}) {
    return Container(
      height: isDesktop ? size.height * 0.50 : size.height * 0.2,
      width: isDesktop ? size.width * 0.2 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Text(
          "hello",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
