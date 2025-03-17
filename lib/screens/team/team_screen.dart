import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/team/widgets/card.dart';
import 'package:e_cell_website/services/enums/department.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
      child: SingleChildScrollView(
        physics:
            const ClampingScrollPhysics(), // Provides more web-like scrolling
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16,
          ),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text(
                    "Our Team",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Meet the changemakers of E-Cell VITB.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 40,
                ),
                Membercard(),
                ...Department.values.map((dept) {
                  return TeamContainer(
                    size: size,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        LinearGradientText(
                          child: Text(
                            dept.toString(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ]),
                    ),
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamContainer extends StatelessWidget {
  const TeamContainer({
    super.key,
    required this.size,
    this.child,
  });

  final Size size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        // width: size.width * 0.8,
        height: size.height * 0.5,
        constraints: BoxConstraints(minWidth: size.width * 0.4),
        decoration: BoxDecoration(
          color: containerBgColor,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}