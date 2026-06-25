import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/gallery_provider.dart';
import 'albums_detail_screen.dart';
import 'widgets/event_card.dart';
import 'widgets/loader.dart';

class AlbumsMainScreen extends StatefulWidget {
  const AlbumsMainScreen({super.key});

  @override
  State<AlbumsMainScreen> createState() => _AlbumsMainScreenState();
}

class _AlbumsMainScreenState extends State<AlbumsMainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPhotoAlbums());
  }

  Future<void> _fetchPhotoAlbums() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final photoAlbumProvider =
          Provider.of<GalleryProvider>(context, listen: false);

      await photoAlbumProvider.getGallery(
        auth.loginData!.regno,
        auth.loginData!.currentyearfrom,
        auth.loginData!.currentyearto,
      );
    } catch (e, s) {
      log('Error fetching photo albums: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<GalleryProvider>(context);

    return Scaffold(
      backgroundColor: CustomColor.primaryColor,
      appBar: AppBar(
        title: const Text('Albums'),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: CustomColor.colorWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: 
      albumProvider.isLoading
          ? buildAlbumShimmer()
          : albumProvider.photoAlbum!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/animation/lottie_files/no_data.json',
                      //   width: 150,
                      //   height: 150,
                      // ),
                      SizedBox(height: 10.h),
                      Text(
                        "No albums found.",
                        style: TextStyle(color: CustomColor.colorWhite, fontSize: 14.sp),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 760.h,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.175,
                      viewportFraction: 0.85,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                    ),
                    items: albumProvider.photoAlbum!.map((album) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AlbumsDetailScreen(
                                  album: album,
                                ),
                              ),
                            );
                          },
                          child: EventCard(
                            imageUrl: album.coverImage ?? '',
                            title: album.heading ?? '',
                            date: album.uploadDate ?? '',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
