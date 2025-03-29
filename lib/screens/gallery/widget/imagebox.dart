import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Imagebox extends StatefulWidget {
  final int initialIndex;
  final int noOfPhotos;

  const Imagebox(
      {required this.initialIndex, required this.noOfPhotos, super.key});

  @override
  State<Imagebox> createState() => _ImageboxState();
}

class _ImageboxState extends State<Imagebox> {
  late int currentIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Dialog(
      backgroundColor: const Color.fromARGB(70, 0, 0, 0),
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Container(
          height: isMobile ? size.height * 0.6 : size.height,
          width: isMobile ? size.width * 0.9 : size.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(84, 0, 0, 0),
            borderRadius: BorderRadius.circular(18),
          ),
          child:
              isMobile ? _buildMobileLayout(size) : _buildDesktopLayout(size),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Size size) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: widget.noOfPhotos,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/seed/$index/500/300",
                    placeholder: (context, url) => const SizedBox(
                      height: 120,
                      width: 240,
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
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: currentIndex > 0
                    ? IconButton(
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    : const SizedBox(width: 40),
              ),

              // Image counter text
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "${currentIndex + 1}/${widget.noOfPhotos}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Right arrow
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: currentIndex < widget.noOfPhotos - 1
                    ? IconButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    : const SizedBox(width: 40),
              ),
            ],
          ),
        ),
        Positioned(
          top: 32,
          right: 4,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (currentIndex > 0)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex -= 1;
                  });
                },
                icon: const Icon(Icons.arrow_circle_left_outlined, size: 60),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            : const SizedBox(
                width: 77,
              ),
        const SizedBox(width: 60),
        Padding(
            padding:  const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Container(
                    key: ValueKey<int>(currentIndex),
                    height: size.height * 0.6,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
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
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                //image count
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${currentIndex + 1}/${widget.noOfPhotos}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(width: 60),
        currentIndex < widget.noOfPhotos - 1
            ? IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex += 1;
                  });
                },
                icon: const Icon(Icons.arrow_circle_right_outlined, size: 60),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            : const SizedBox(
                width: 77,
              )
      ],
    );
  }
}
