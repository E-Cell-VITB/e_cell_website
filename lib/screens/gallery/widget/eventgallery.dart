import 'package:cached_network_image/cached_network_image.dart';
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
    final ind = (images.length > 6) ? 6 : images.length;
    return Column(
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
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      //  "https://picsum.photos/seed/$index/500/300",
                      placeholder: (context, url) => const SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
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
    );
  }
}
