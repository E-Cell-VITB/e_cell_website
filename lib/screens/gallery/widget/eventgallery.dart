import 'package:e_cell_website/backend/models/gallery.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/gallery/widget/imagebox.dart';

import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class Eventgallery extends StatelessWidget {
  // final String eventname;
  // final int noofphotos;
  final Gallery gallery;
  const Eventgallery({
    // required this.noofphotos,
    // required this.eventname,
    required this.gallery,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<String> images = gallery.winnerPhotos + gallery.allPhotos;
    int ind;
    int noofphotos = images.length;

    if (size.width < 700) {
      ind = (noofphotos > 3) ? 3 : noofphotos;
    } else {
      ind = (noofphotos > 6) ? 6 : noofphotos;
    }
    return SizedBox(
      width: size.width * 0.72,
      child: Column(
        children: [
          LinearGradientText(
            child: Text(
              gallery.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
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
                      return Imagebox(
                        noOfPhotos: images.length,
                        images: images,
                        initialIndex: index,
                        // noOfPhotos: noofphotos,
                      );
                    },
                  ),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: size.height * 0.28,
                    width: size.width > 600 ? size.width * 0.25 : 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: secondaryColor,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image),
                        )

                        //  Image.network(
                        //     'https://picsum.photos/seed/$ind/500/300',
                        //     fit: BoxFit.cover,
                        //   )
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
