import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class ShowEventBox{
   ShowEventBox(BuildContext context,int index){
    final size=MediaQuery.of(context).size;
     showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
            child: Container(
                height: size.width>600?size.height * 0.65:size.height*0.5,
                width: size.width>600? size.width * 0.50:size.height*0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: eventBoxLinearGradient),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: linerGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              'TechSprouts 2K25',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.....",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: size.width * 0.012,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.09,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient:
                                      LinearGradient(colors: linerGradient),
                                ),
                                child: Center(
                                  child: Text(
                                    "Read More",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ))
                        ])),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                        height: size.height * 0.50,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "hello",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ))
                  ],
                )));
      },
    );

  }
}