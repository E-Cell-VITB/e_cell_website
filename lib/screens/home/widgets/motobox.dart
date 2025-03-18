import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Motobox extends StatelessWidget {
  final String heading;
  final String info;
  final String image;
  const Motobox({
    required this.image,
    required this.heading,
    required this.info,
    super.key});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: (size.width>450)?380:300,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: eventBoxLinearGradient),
        borderRadius: BorderRadius.circular(70),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: (size.width>450)?60:50,
              width: (size.width>450)?60:50,
              child: CircleAvatar(
                backgroundColor: secondaryColor,
                backgroundImage: AssetImage(image)
                ),
            ),
            
            Container(
              width: (size.width>500)?260: 220,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$heading",style: TextStyle(fontWeight: FontWeight.w500,fontSize:(size.width>450)? size.width*0.01:size.width*0.02),),
                  SizedBox(height: 1,),
                  Text("$info",style: TextStyle(fontSize:(size.width>450)? size.width*0.008:size.width*0.02,color: Colors.grey),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}