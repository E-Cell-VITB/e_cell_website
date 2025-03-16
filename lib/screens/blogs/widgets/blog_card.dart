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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.blog.thumbnailUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                      child: Icon(Icons.broken_image,
                          color: Colors.grey.shade500, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SelectableText(
                widget.blog.title,
                style: TextStyle(
                  fontSize: isHovered ? 19 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              SelectableText(
                widget.blog.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isHovered ? Colors.white : Colors.white70,
                ),
                maxLines: 4,
                // overflow: TextOverflow.ellipsis,
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
