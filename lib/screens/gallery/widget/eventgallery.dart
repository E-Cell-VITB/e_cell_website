import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/const/theme.dart';
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

    int ind;

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
              eventname,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                          initialIndex: index, noOfPhotos: noofphotos);
                    },
                  ),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: size.height * 0.28,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: "https://picsum.photos/seed/$index/500/300",
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
