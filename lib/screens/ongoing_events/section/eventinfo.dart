import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Eventinfo extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const Eventinfo(
      {required this.event,
      required this.isMobile,
      required this.isTablet,
      required this.screenWidth,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientBox(
            width: isMobile ? screenWidth * 0.85 : screenWidth * 0.7,
            height: isMobile ? 100 : 150,
            radius: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: isMobile ? 80 : 180,
                  width: isMobile ? 80 : 180,
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/prizepool.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: isMobile
                      ? screenWidth * 0.1
                      : isTablet
                          ? screenWidth * 0.1
                          : screenWidth * 0.2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("PRIZE POOL",
                        style: isMobile
                            ? Theme.of(context).textTheme.bodyMedium
                            : Theme.of(context).textTheme.headlineSmall),
                    Text("₹ ${event.prizePool}",
                        style: isMobile
                            ? Theme.of(context).textTheme.headlineSmall
                            : Theme.of(context).textTheme.headlineLarge),
                  ],
                )
              ],
            )),
        SizedBox(height: isMobile ? 20 : 40),
        Row(
            spacing: isMobile ? 10 : 50,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientBox(
                  width: isMobile ? screenWidth * 0.43 : screenWidth * 0.33,
                  height: isMobile ? 100 : 150,
                  radius: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: isMobile ? 40 : 150 ,
                        width: isMobile ? 40 : 150,
                        
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/team.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isMobile
                            ? screenWidth * 0.05
                            : isTablet
                                ? screenWidth * 0.05
                                : screenWidth * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("TEAM SIZE",
                              style:TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 12 : 15,
                                  fontWeight: FontWeight.w500)),
                          Text("${event.minTeamSize}-${event.maxTeamSize}",
                              style:TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 30,
                                  fontWeight: FontWeight.w500) ),
                        ],
                      )
                    ],
                  )),
              GradientBox(
                  width: isMobile ? screenWidth * 0.43 : screenWidth * 0.33,
                  height: isMobile ? 100 : 150,
                  radius: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: isMobile ? 40 : 100,
                        width: isMobile ? 40 : 100,
                        
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/location.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isMobile
                            ? screenWidth * 0.05
                            : isTablet
                                ? screenWidth * 0.05
                                : screenWidth * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("VENUE",
                              style:TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 12 : 15,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            width: isMobile ? 100 : 250,
                            child: SelectableText("${event.place}",
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 8 : 16,
                                    
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      )
                    ],
                  )),
            ])
      ],
    );
  }
}
