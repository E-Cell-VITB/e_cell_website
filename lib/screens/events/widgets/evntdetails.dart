// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/speakerbox.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Eventdetails extends StatefulWidget {
  const Eventdetails({super.key});
  @override
  State<Eventdetails> createState() => _EventdetailsState();
}

class _EventdetailsState extends State<Eventdetails> {
 final List<String> position = [
     "First",
     "Second",
     "Third",
  ]; 
  final List<String> images = [
     "Box1",
     "Box2",
     "Box3",
  ]; 

  final List<String> teams = [
     "Team1",
     "Team2",
     "Team3",
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    bool isMobile=(size.width<500)?true:false;
    return Scaffold(
      body: ParticleBackground(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width:(isMobile)?400: size.width * 0.9,
                        height:(isMobile)?80: size.width * 0.13,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(colors: linerGradient),
                            borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.all(2),
                      ),
                    ),
                    SizedBox(
                      height:(isMobile)?70: 180,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeadingWidget(text: "200+", theme: "Participants"),
                          HeadingWidget(text: "50+", theme: "Teams"),
                          HeadingWidget(text: "\u20B9 10000", theme:"Prize pool")
                        ],
                      ),
                    ),
                    SizedBox(
                      height:(isMobile)?30: 60,
                    ),

                    //location block
                    SizedBox(
                      width:(isMobile)?250: size.width * 0.55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GradientBox(
                            height:(isMobile)?30: 50,
                            width:(isMobile)?100: 200,
                            radius: 120,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.calendar_month_outlined,size: (isMobile)?8:20,),
                                  Text("Feb 4 , 2025",style: TextStyle(fontSize: (isMobile)?8:20),),
                                ],
                              ),
                            ),
                          ),
                          GradientBox(
                            height:(isMobile)?30: 50,
                            width:(isMobile)?100: 200,
                            radius: 120,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.location_on_outlined,size: (isMobile)?8:20,),
                                  Text("COE , VITB",style: TextStyle(fontSize: (isMobile)?8:20),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height:(isMobile)?30: 60,
                    ),

                    //event Speakers Block
                    LinearGradientText(
                        child: Text("Event Speakers",
                            style: TextStyle(
                                fontSize:(isMobile)?20: 36, fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: size.width * 0.7,
                      child: Center(
                        child: Wrap(
                          spacing: 30,
                          runSpacing: 40,
                          alignment: WrapAlignment.center,
                          children: List.generate(4, (index) {
                            return Speakerbox(
                              speakerrole: "designer${index}",
                              spearkername: "abshabkj",
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:(isMobile)?30: 60,
                    ),

                    //Gallery Block
                    SizedBox(
                      width: size.width * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearGradientText(
                              child: Text(
                            "Gallery",
                            style: TextStyle(
                               fontSize:(isMobile)?20: 36, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: size.height*0.8,

                            width: size.width*0.7,
                            child: MasonryGridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                 // Number of columns
                              ),
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                              
                                return Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height:
                                      200, // Varying heights
                                  child: Center(
                                    child: Text(
                                      "Box ${index + 1}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:(isMobile)?30: 60,
                    ),



                    //winners Block
                    SizedBox(
                      width:(isMobile)?size.width*0.9: size.width * 0.7,
                      child: Column(
                        children: [
                          LinearGradientText(
                              child: Text(
                            "Winners",
                            style: TextStyle(
                                fontSize:(isMobile)?20: 36 , fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          GradientBox(
                              radius: 10,
                              height:(isMobile)?260: size.height * 0.7,
                              width:(isMobile)?300: size.width * 0.6,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(3, (index) {
                                        return Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(15),
                                                height:(isMobile)?18: 40,
                                                width:(isMobile)?35: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: backgroundColor,
                                                ),
                                                child: (selectedIndex != index)
                                                    ? Center(
                                                        child: Text("${position[index]}",style: TextStyle(fontSize: (isMobile)?8:16)))
                                                    : GradientBox(
                                                        radius: 30,
                                                        child: Center(
                                                            child: LinearGradientText(
                                                                child: Text(
                                                                    "${position[index]}",style: TextStyle(fontSize: (isMobile)?8:16),))),
                                                        height:(isMobile)?18: 40,
                                                        width:(isMobile)?35: 110)),
                                          ),
                                        );
                                      })),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    child: Container(
                                      height:(isMobile)?150: size.height * 0.4,
                                      width:(isMobile)?250: size.width * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: Text("Box${selectedIndex}",
                                              style: TextStyle(
                                                  color: Colors.black))),
                                    ),
                                  ),
                                  LinearGradientText(
                                      child: Text("${teams[selectedIndex]}",
                                          style: TextStyle(
                                              fontSize:(isMobile)?10: 30,
                                              fontWeight: FontWeight.bold)))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:(isMobile)?70: size.width * 0.10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width:(isMobile)?300: size.width * 0.7,
                      height:(isMobile)?80: size.width * 0.11,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: linerGradient),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width:(isMobile)?350: size.width * 0.7,
                        height:(isMobile)?100: size.width * 0.11,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: Colors.black),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("TechSprouts 2K25",
                                  style: TextStyle(
                                      
                                      fontSize:(isMobile)?12: 35,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height:(isMobile)?0: 12,
                              ),
                              Text(
                                "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. Its purpose is to permit a page layout to be designed, independently of the copy that will subsequently populate it, or to demonstrate various fonts of a typeface without meaningful text that could be distracting.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey,fontSize: (isMobile)?6:14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  }
}

class HeadingWidget extends StatelessWidget {
  final String text;
  final String theme;

  const HeadingWidget({
    Key? key,
    required this.text,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile=(size.width<500)?true:false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LinearGradientText(
          child: Text(
            text,
            style: TextStyle(fontSize:(isMobile)?10: 40, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          theme,
          style: TextStyle(fontSize:(isMobile)?6: 14, color: Colors.white),
        ),
      ],
    );
  }
}

class GradientBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final double radius;
  const GradientBox({
    Key? key,
    required this.radius,
    required this.child,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(colors: linerGradient),
      ),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(colors: eventBoxLinearGradient),
          ),
          child: child,
        ),
      ),
    );
  }
}
