import 'package:e_cell_website/backend/firebase_services/gallery_service.dart';
import 'package:e_cell_website/backend/models/gallery.dart';
import 'package:flutter/material.dart';

class GalleryProvider extends ChangeNotifier {
  final GalleryService _galleryService = GalleryService();

  String? _error;
  Gallery? _selectedGallery;
  int _currentPhotoIndex = 0;

  String? get error => _error;
  Gallery? get selectedGallery => _selectedGallery;
  int get currentPhotoIndex => _currentPhotoIndex;

  Stream<List<Gallery>> getGalleriesStream({bool descending = true}) {
    return _galleryService.getGalleries(descending: descending);
  }

  void setSelectedGallery(Gallery gallery) {
    _selectedGallery = gallery;
    _currentPhotoIndex = 0;
    notifyListeners();
  }

  void setCurrentPhotoIndex(int index) {
    _currentPhotoIndex = index;
    notifyListeners();
  }

  List<String> getAllPhotos(Gallery gallery) {
    // Combine winner photos and all photos, removing duplicates
    final Set<String> allPhotosSet = {
      ...gallery.winnerPhotosWithOrder.map((e) => e.photoUrl),
      ...gallery.allPhotos
    };
    return allPhotosSet.toList();
  }

  void nextPhoto() {
    if (_selectedGallery != null) {
      final photos = getAllPhotos(_selectedGallery!);
      if (_currentPhotoIndex < photos.length - 1) {
        _currentPhotoIndex++;
      } else {
        _currentPhotoIndex = 0; // Loop back to the first photo
      }
      notifyListeners();
    }
  }

  void previousPhoto() {
    if (_selectedGallery != null) {
      final photos = getAllPhotos(_selectedGallery!);
      if (_currentPhotoIndex > 0) {
        _currentPhotoIndex--;
      } else {
        _currentPhotoIndex = photos.length - 1; // Loop to the last photo
      }
      notifyListeners();
    }
  }
}
