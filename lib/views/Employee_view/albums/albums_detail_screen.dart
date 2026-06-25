import 'dart:io';
import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/Students/album_model.dart';
import 'widgets/album_bottom_sheet.dart';

class AlbumsDetailScreenEmp extends StatefulWidget {
  final PhotoAlbum album;

  const AlbumsDetailScreenEmp({super.key, required this.album});

  @override
  State<AlbumsDetailScreenEmp> createState() => _AlbumsDetailScreenState();
}

class _AlbumsDetailScreenState extends State<AlbumsDetailScreenEmp> {
  late List<double> _imageHeights;
  final Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _imageHeights = List.generate(
      widget.album.images!.length,
      (index) => (150 + (index * 37) % 100).toDouble(),
    );
  }

  void toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) _selectedIndices.clear();
    });
  }

  void toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void selectAllImages() {
    setState(() {
      if (_selectedIndices.length == widget.album.images!.length) {
        _selectedIndices.clear();
      } else {
        _selectedIndices.addAll(
          List.generate(widget.album.images!.length, (i) => i),
        );
      }
    });
  }

  Future<void> shareSelectedImages() async {
    if (_selectedIndices.isEmpty) return;

    try {
      final tempDir = await getTemporaryDirectory();
      List<XFile> imageFiles = [];

      for (var index in _selectedIndices) {
        final imageUrl = widget.album.images![index].imgPath;
        final response = await http.get(Uri.parse(imageUrl!));

        final filePath = '${tempDir.path}/shared_image_$index.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        imageFiles.add(XFile(file.path));
      }

      await Share.shareXFiles(
        imageFiles,
      );

      setState(() {
        _selectedIndices.clear();
        _isSelectionMode = false;
      });
    } catch (e) {
      debugPrint('Error sharing grouped images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share images')),
      );
    }
  }

  void openImageViewer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: CustomColor.colorBlack,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: widget.album.images!.length,
                builder: (context, i) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        NetworkImage(widget.album.images![i].imgPath!),
                    heroAttributes: PhotoViewHeroAttributes(tag: i),
                  );
                },
                pageController: PageController(initialPage: index),
                backgroundDecoration:
                  BoxDecoration(
                    color: CustomColor.colorBlack
                  ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.close, 
                    color: CustomColor.colorWhite, 
                    size: 30
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;

    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: _isSelectionMode
          ? AppBar(
              backgroundColor: CustomColor.primaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: CustomColor.colorWhite,
                ),
                onPressed: toggleSelectionMode,
              ),
              title: Text(
                '${_selectedIndices.length} selected',
                style: TextStyle(
                  color: CustomColor.colorWhite
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _selectedIndices.length == album.images!.length
                        ? Icons.deselect
                        : Icons.select_all,
                        color: CustomColor.colorWhite,
                  ),
                  onPressed: selectAllImages,
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: CustomColor.colorWhite,
                  ),
                  onPressed: shareSelectedImages,
                ),
              ],
            )
          : AppBar(
              title: const Text('Album'),
              backgroundColor: CustomColor.primaryColor,
              foregroundColor: CustomColor.colorWhite,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childCount: album.images!.length,
              itemBuilder: (context, index) {
                final image = album.images![index].imgPath;
                final height = _imageHeights[index];
                final isSelected = _selectedIndices.contains(index);

                return GestureDetector(
                  onLongPress: () {
                    if (!_isSelectionMode) {
                      toggleSelectionMode();
                      toggleSelection(index);
                    }
                  },
                  onTap: () {
                    if (_isSelectionMode) {
                      toggleSelection(index);
                    } else {
                      openImageViewer(index);
                    }
                  },
                  child: Stack(
                    children: [
                      Hero(
                        tag: index,
                        child: Container(
                          height: height.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.r),
                            border: isSelected
                                ? Border.all(
                                    color: CustomColor.primaryColor,
                                    width: 3.w,
                                  )
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image,
                                    size: 40.sp, 
                                    color: CustomColor.colorGrey
                                  ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isSelectionMode)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? CustomColor.primaryColor
                                  : CustomColor.colorWhite,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? CustomColor.primaryColor
                                    : CustomColor.colorGrey,
                                width: 2.w,
                              ),
                            ),
                            child: isSelected
                                ? Icon(Icons.check,
                                    size: 16.sp, 
                                    color: CustomColor.colorWhite
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
      bottomSheet: AlbumBottomSheet(album: album),
    );
  }
}

