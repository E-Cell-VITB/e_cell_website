import 'package:e_cell_website/backend/firebase_services/blogs_service.dart';
import 'package:e_cell_website/backend/models/blog.dart';
import 'package:flutter/material.dart';

class BlogProvider extends ChangeNotifier {
  final BlogService _blogService = BlogService();

  Stream<List<Blog>> get blogsStream => _blogService.getBlogs();
}
