// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common_menu_model.dart';
import '../../../../providers/common/get_api_kay.dart';

class MenuGrid extends StatefulWidget {
  final List<StudentMenuItem>? menuItems;
  final Function(String screenName) onMenuItemTap;

  const MenuGrid({
    super.key,
    required this.menuItems,
    required this.onMenuItemTap,
  });

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  static final Map<String, Widget> _svgCache = {};

  Future<Widget> loadSvgWithHeader(String url) async {
    if (_svgCache.containsKey(url)) {
      return _svgCache[url]!;
    }
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'ApiKey': apiKey ?? ''},
      );
      Widget widget;

      if (response.statusCode == 200 && response.body.contains("<svg")) {
        widget = SvgPicture.string(
          response.body,
          colorFilter: ColorFilter.mode(
              CustomColor.primaryColor,
              BlendMode.srcIn
          ),
        );
      } else {
        widget = Icon(
          Icons.grid_view,
          size: 30.h,
          color: CustomColor.barYellow,
        );
      }
      _svgCache[url] = widget;
      return widget;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      return loadSvgWithHeader(url);
    }
  }

  Widget _buildCachedSvgWidget(String iconUrl) {
    if (_svgCache.containsKey(iconUrl)) {
      return _svgCache[iconUrl]!;
    }

    return FutureBuilder(
      future: loadSvgWithHeader(iconUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return SizedBox(
          height: 50.h,
          width: 50.h,
          child: Lottie.asset(
            'assets/animation/menu_load.json',
            width: 150,
            height: 150,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleMenus =
        widget.menuItems!.where((e) => e.isVisible == "True").toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 20.h,
              mainAxisSpacing: 35.w,
              childAspectRatio: 0.8,
              physics: const BouncingScrollPhysics(),
              children: visibleMenus.map((item) {
                return GestureDetector(
                  onTap: () => widget.onMenuItemTap(item.menuKey ?? ""),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(22.h),
                        decoration: BoxDecoration(
                          color: CustomColor.colorWhite,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: SizedBox(
                          height: 55.h,
                          width: 55.h,
                          child: (item.iconUrl ?? "").endsWith(".svg")
                              ? _buildCachedSvgWidget(item.iconUrl!)
                              : Image.network(
                                  item.iconUrl ?? "",
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.error_outline,
                                    size: 60.h,
                                    color: CustomColor.primaryColor,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        item.menuName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.colorWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          /// FOOTER AREA (same as second design)
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance,
                  color: CustomColor.colorWhite.withOpacity(0.9),
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "St. Jude School",
                  style: TextStyle(
                    color: CustomColor.colorWhite.withOpacity(0.9),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
