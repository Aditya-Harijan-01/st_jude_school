import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/library_details.dart';
import 'widget/library_book_card.dart';
import 'widget/library_shimmer.dart';
import 'widget/top_toggle_bar.dart';

class LibraryScreenEmp extends StatefulWidget {
  const LibraryScreenEmp({super.key});

  @override
  State<LibraryScreenEmp> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreenEmp> {
  String selectedTab = "1"; // 1 = Issued, 2 = Returned

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchLibraryData());
  }

  Future<void> _fetchLibraryData() async {
    final provider = Provider.of<LibraryDetailsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await provider.getLibraryDataEmp(authProvider.loginData!.empId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LibraryDetailsProvider>(context);
    final issued = provider.issuedBooks;
    final returned = provider.returnedBooks;
    final books = selectedTab == "1" ? issued : returned;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
          "Library",
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 22.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          TopToggleBar(
            selectedTab: selectedTab,
            issuedCount: issued.length,
            returnedCount: returned.length,
            onTabChange: (tab) {
              setState(() => selectedTab = tab);
            },
            title: const ["Issued", "Returned"],
          ),
          SizedBox(height: 5.h),

          // --- Shimmer or Data ---
          Expanded(
            child: provider.isLoading
                ? const LibraryShimmerLoader()
                : books.isEmpty
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              color: CustomColor.colorGrey,
                              size: 80,
                            ),
                            Text(
                              "No books found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: CustomColor.colorBlack
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return LibraryBookCard(
                            title: book.bookTitle,
                            author: book.author,
                            date: selectedTab == "1"
                                ? book.issueDate
                                : book.actualReturnDate,
                            image: book.imageUrl,
                            isIssued: selectedTab == "1",
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
