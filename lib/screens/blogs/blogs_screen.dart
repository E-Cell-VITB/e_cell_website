import 'package:e_cell_website/backend/models/blog.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/blogs_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/blog_card.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<BlogProvider>(builder: (context, blogProvider, _) {
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
                      "Blogs",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: size.width > 600
                                  ? "Lessons, Strategies, and Success Stories! "
                                  : "Lessons, Strategies, and\nSuccess Stories! ",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: "✨",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<List<Blog>>(
                    stream: blogProvider.blogsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                            height: size.height * 0.6,
                            child: const Center(
                              child: LoadingIndicator(),
                            ));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: size.width > 600 ? 80 : 60,
                                  color: Colors.white38,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No blogs available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white70,
                                        fontSize: size.width > 600 ? 24 : 20,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back later for new content!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white54,
                                        fontSize: size.width > 600 ? 16 : 14,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final blogs = snapshot.data!;
                      return SizedBox(
                        width:
                            size.width > 600 ? size.width * 0.82 : size.width,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          alignment: WrapAlignment.center,
                          children: blogs
                              .map((blog) => BlogCard(blog: blog))
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Footer(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
