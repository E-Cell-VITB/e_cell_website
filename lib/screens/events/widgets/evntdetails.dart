
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class Eventdetails extends StatelessWidget {
  const Eventdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ParticleBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: linerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: SelectableText(
                    'TechSprouts',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
