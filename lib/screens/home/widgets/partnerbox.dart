import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Partnerbox extends StatelessWidget {
  final String heading;
  final String info;
  const Partnerbox({
    required this.heading,
    required this.info,
    super.key});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      height: (size.width>450)?size.width*0.25:size.width*0.55,
      width:(size.width>450)? size.width*0.19:size.width*0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: eventBoxLinearGradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding:  EdgeInsets.all((size.width>450)?size.width*0.01:12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              SelectableText("$heading",style: TextStyle(fontSize:(size.width>450)?size.width*0.015:size.width*0.035,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              SelectableText("$info",style: TextStyle(fontSize:(size.width>450)? size.width*0.01:size.width*0.03,color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}