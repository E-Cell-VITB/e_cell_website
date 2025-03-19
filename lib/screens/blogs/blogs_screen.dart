import 'package:e_cell_website/backend/models/blog.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/blogs_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
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
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Lessons, Strategies, and Success Stories! ",
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
                    height: 40,
                  ),
                  // Stream builder with Wrap instead of ListView
                  StreamBuilder<List<Blog>>(
                    stream: blogProvider.blogsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                            height: size.height * 0.6,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No blogs available',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final blogs = snapshot.data!;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children:
                            blogs.map((blog) => BlogCard(blog: blog)).toList(),
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
