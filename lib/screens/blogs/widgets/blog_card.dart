import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/backend/models/blog.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/url_launcher_fn.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isHovered = false;

  void _showBlogDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? 16 : 40),
          child: Container(
            width: isMobile ? size.width * 0.9 : size.width * 0.6,
            constraints: BoxConstraints(
              maxHeight: isMobile ? size.height * 0.8 : size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: secondaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        secondaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.blog.title,
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 24),
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Blog image
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: widget.blog.thumbnailUrl,
                                height: isMobile ? 180 : 280,
                                width: isMobile
                                    ? double.infinity
                                    : size.width * 0.54,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Container(
                                  height: isMobile ? 220 : 320,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 48),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                errorWidget: (context, error, stackTrace) =>
                                    Container(
                                  height: isMobile ? 220 : 320,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 48),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Failed to load image',
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Blog description
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: secondaryColor,
                                    size: isMobile ? 20 : 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.blog.description,
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 17,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.6,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                // Action buttons
                Container(
                  width: isMobile ? size.width * 0.7 : size.width * 0.4,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        secondaryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                secondaryColor.withOpacity(0.8),
                                secondaryColor.withOpacity(0.6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              launchURL(widget.blog.postUrl);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 12 : 16,
                                horizontal: 24,
                              ),
                            ),
                            icon: Icon(
                              Icons.open_in_new_rounded,
                              color: Colors.white,
                              size: isMobile ? 22 : 24,
                            ),
                            label: Text(
                              'Read Full Article',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width > 600 ? 320 : 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered ? secondaryColor : const Color(0xffA6A0A0),
            width: isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? secondaryColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              spreadRadius: isHovered ? 3 : 2,
              blurRadius: isHovered ? 12 : 8,
              offset: isHovered ? const Offset(0, 8) : const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _showBlogDialog(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.blog.thumbnailUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(Icons.image,
                            color: Colors.grey.shade500, size: 40),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(Icons.image,
                            color: Colors.grey.shade500, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _showBlogDialog(context),
                child: Text(
                  widget.blog.title,
                  style: TextStyle(
                    fontSize: isHovered ? 19 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _showBlogDialog(context),
                child: Text(
                  widget.blog.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isHovered ? Colors.white : Colors.white70,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      secondaryColor.withOpacity(isHovered ? 0.3 : 0.2),
                      Colors.black.withOpacity(0.4)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    launchURL(widget.blog.postUrl);
                  },
                  icon: Icon(
                    Icons.article_outlined,
                    color: secondaryColor,
                    size: isHovered ? 22 : 20,
                  ),
                  label: Text(
                    'Read More',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: isHovered ? 15 : 14,
                      fontWeight:
                          isHovered ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
