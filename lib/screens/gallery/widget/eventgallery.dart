import 'package:e_cell_website/screens/gallery/widget/imagebox.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class Eventgallery extends StatelessWidget {
  final String eventname;
  final int noofphotos;
 
  const Eventgallery({
    required this.noofphotos,
    required this.eventname,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ind=(noofphotos>6)?6:noofphotos;
    return Column(
      children: [
        LinearGradientText(
          child: Text(
            eventname,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),

      
        Wrap(
          spacing: 25,
          runSpacing: 25,
          children: List.generate(
            ind, 
            (index) {
              return InkWell(
                 onTap: () => showDialog(
                 context: context,
                 barrierDismissible: true,
                 builder: (BuildContext context) {
                   return Imagebox(initialIndex: index, noOfPhotos: noofphotos);
               },),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: size.height * 0.28,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Colors.white,
                    
                  ),
                  
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network('https://picsum.photos/seed/$ind/500/300',fit: BoxFit.cover,)),


                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
