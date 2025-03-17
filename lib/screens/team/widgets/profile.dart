import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 320,
        width: 210,
        decoration: BoxDecoration(color: containerBgColor),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 210,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 80, 80, 80)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 4,
              child: ClipRRect(
                  child: Image.asset(
                "assets/icons/ecell_sample.png",
                height: 260,
                width: 200,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    width: 208,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                      color: Colors.black,
                      boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.96),  // Shadow color (with some transparency)
                      offset: Offset(0, -15),                  // Negative y-offset to move shadow to the top
                      blurRadius: 16,                         // Blur radius to soften the shadow
                    ),
                  ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearGradientText(
                                  child: Text(
                                "LEAD",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                              Text(
                                "Dhruti",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.amber,
                          ),
                          Icon(Icons.abc)
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
