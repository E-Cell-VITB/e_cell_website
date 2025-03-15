import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: EdgeInsets.all(20),
        width: 700,
        height: 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Center(
            child:ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: linerGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Design',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: primaryColor,
                  ),
                ),
              ),
          ),
          Center(
              child: Text(
            "Team Lead",
            style: TextStyle(fontSize: 30),
          )),
        ],
      ),
    ));
  }
}
