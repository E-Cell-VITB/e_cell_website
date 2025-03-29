import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/evntdetails.dart';
import 'package:flutter/material.dart';

class Speakerbox extends StatelessWidget {
  final String spearkername;
  final String speakerrole;
  const Speakerbox({
    required this.spearkername,
    required this.speakerrole,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: linerGradient),
      ),
      padding: EdgeInsets.all(1),
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            GradientBox(
              radius: 20,
              height: 200,
              width: 200,
              child: Center(child: Text("photo")),
            ),
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(spearkername,style: TextStyle(fontSize: 16),),
                  Text(speakerrole,style: TextStyle(fontSize: 8),)
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}