import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/album_model.dart';
import '../common/common_post_method.dart';

class GalleryProvider extends ChangeNotifier {
  bool isLoading = false;
  PhotoAlbumResponse? photoAlbumResponse;
  List<PhotoAlbum> photoAlbum = [];
  

  Future<void> getGallery(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(ApiEndpoints.getPhotoAlbum, body);

      if (data != null) {
        log("This data is for the student notification :$data");
        final photoList = PhotoAlbumResponse.fromJson(data);
        photoAlbumResponse = photoList;
        photoAlbum = photoList.data ?? [];
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student notification: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
}