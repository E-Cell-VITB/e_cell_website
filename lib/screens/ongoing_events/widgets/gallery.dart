import 'dart:math';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/image_compressor.dart';
import 'package:e_cell_website/services/enums/device.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoGalleryWidget extends StatelessWidget {
  final List<String> photoUrls;
  final bool isMobile;
  final Size size;

  const PhotoGalleryWidget({
    required this.photoUrls,
    required this.isMobile,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
      ),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        final ratio = _getRandomAspectRatio();

        return Container(
          height: (isMobile ? 150 : 200) * ratio,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                getOptimizedImageUrl(
                    originalUrl: photoUrls[index],
                    device: isMobile ? Device.mobile : Device.desktop),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                          height: size.height * 0.6,
                          child: const Center(
                            child: LoadingIndicator(),
                          )));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _imageDialog(context, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _imageDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? 15 : 40),
          child: SizedBox(
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black87,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: primaryColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.network(
                          getOptimizedImageUrl(
                              originalUrl: photoUrls[index],
                              device:
                                  isMobile ? Device.mobile : Device.desktop),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                    height: size.height * 0.6,
                                    child: const Center(
                                      child: LoadingIndicator(),
                                    )));
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.error_outline,
                                  color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Photo ${index + 1} of ${photoUrls.length}",
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getRandomAspectRatio() {
    final ratios = [0.6, 0.8, 1.0, 1.2, 1.5, 1.8];
    return ratios[Random().nextInt(ratios.length)];
  }
}
