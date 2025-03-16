import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Imagebox extends StatefulWidget {
  final int initialIndex;
  final int noOfPhotos;

  const Imagebox(
      {required this.initialIndex, required this.noOfPhotos, super.key});

  @override
  _ImageboxState createState() => _ImageboxState();
}

class _ImageboxState extends State<Imagebox> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Container(
            height: size.height * 0.65,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (currentIndex > 0)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex -= 1;
                      });
                    },
                    icon:
                        const Icon(Icons.arrow_circle_left_outlined, size: 60),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                const SizedBox(width: 60),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Container(
                    key: ValueKey<int>(currentIndex),
                    height: size.height * 0.6,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://picsum.photos/seed/$currentIndex/500/300",
                          placeholder: (context, url) => const SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: secondaryColor,
                              ))),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                        // Image.network(
                        //   'https://picsum.photos/seed/$currentIndex/500/300',
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ),
                ),
                const SizedBox(width: 60),
                if (currentIndex < widget.noOfPhotos - 1)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex += 1;
                      });
                    },
                    icon:
                        const Icon(Icons.arrow_circle_right_outlined, size: 60),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
