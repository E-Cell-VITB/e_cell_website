import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/gallery/widget/eventgallery.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const String galleryScreenRoute = "/gallery";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
      child: SingleChildScrollView(
        physics:
            const ClampingScrollPhysics(), // Provides more web-like scrolling
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16,
          ),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text(
                    "Gallery",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Moments from Our Iconic Events! ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: "✨",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                
                Eventgallery(eventname: "Techsprouts",noofphotos: 10,),
                SizedBox(height: 60,),
                Eventgallery(eventname: "InnoVit 2k25",noofphotos: 7,),
                SizedBox(height: 60,),
                Eventgallery(eventname: "Techsprouts",noofphotos: 5,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
