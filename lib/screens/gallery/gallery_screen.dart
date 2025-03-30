import 'package:e_cell_website/backend/models/gallery.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/gallery/widget/eventgallery.dart';
import 'package:e_cell_website/services/providers/gallery_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const String galleryScreenRoute = "/gallery";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final galleryProvider = Provider.of<GalleryProvider>(context);
    return ParticleBackground(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                StreamBuilder<List<Gallery>>(
                  stream: galleryProvider.getGalleriesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading galleries: ${snapshot.error}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.red),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No galleries available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    final galleries = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: galleries.length,
                      itemBuilder: (context, index) {
                        // return GalleryItem(gallery: galleries[index]);
                        if (galleries[index].allPhotos.isEmpty) {
                          return const SizedBox();
                        }
                        return Eventgallery(
                          gallery: galleries[index],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
