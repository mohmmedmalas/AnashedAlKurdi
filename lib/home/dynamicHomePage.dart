import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nasheedapp/configuration/images.dart';
import 'package:nasheedapp/home/sendNasheed.dart';
import 'package:nasheedapp/home/subCategoriesPage.dart';
import 'package:nasheedapp/home/userManagementPage.dart';
import 'package:nasheedapp/model/dhikrItemsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';

import '../commenwidget/boxesHome.dart';
import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../commenwidget/imageSlider.dart';
import '../configuration/basePage.dart';
import '../configuration/initializeCategoriesHelper.dart';
import '../configuration/theme.dart';
import '../configuration/userService.dart';
import '../contant/awradAndZker.dart';
// import '../contant/beadsCounterPage.dart';
// import '../contant/beadsPrivetCounterPage.dart';
// import '../contant/contactUs.dart';
import '../contant/files.dart';
import '../contant/filesBurda.dart';
// import '../contant/filesMauled.dart';
import '../contant/filesYoutube.dart';
// import '../contant/licensesTime.dart';
import '../contant/nasheedList.dart';
import '../contant/nasheedListByCategory.dart';
import '../contant/nasheedListHadra.dart';
import '../contant/nasheedListMaqamat.dart';
import '../contant/pdfViewerPage.dart';
import '../starting/phoneLoginPage.dart';
import '../starting/splashScreen.dart';
// import '../model.dart';
// import '../contant/pdfViewerPageMix.dart';
// import '../pages/pages/newIamge.dart';
// import '../pages/renewBox/RequestBulkFromBoxes.dart';


import '../commenwidget/boxesHomeOneLine.dart';


// dynamic_categories_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adminMenuCategoriesPage.dart';
import 'batchUploadScreen.dart';

class DynamicHomePage extends StatefulWidget {
  const DynamicHomePage({Key? key}) : super(key: key);

  @override
  State<DynamicHomePage> createState() => _DynamicHomePageState();
}

class _DynamicHomePageState extends State<DynamicHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // bool _isAdmin = false;
  bool _isSuperAdmin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      bool superAdmin = await UserService.isCurrentUserSuperAdmin();
      _isSuperAdmin = superAdmin ;
      setState(() {});
    });
  }

  // Redirect to login page
  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        endDrawer: buildDrawer(context),
        appBar: myAppBar(
          leadingWidget: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          // onTap: () {
          //
          // },
          title: "الصفحة الرئيسية",
          context: context,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(height: size_H(10)),

              // Slider
              Container(
                height: size_H(210),
                child: ImageSlider(
                  imagePaths: [
                    ImagePath.tareqa,
                  ],
                ),
              ),

              SizedBox(height: size_H(15)),

              // Static "All Nasheeds" button
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BoxWidgetLine(
                        box: Boxes(
                          name: "كافة القصائد",
                          onTap: () {
                            Navigator.push(
                              context,
                              MyCustomRoute(
                                builder: (BuildContext context) => NasheedListPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 15),

                      // Dynamic Categories from Firestore
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('menu_categories')
                            .where('isMain', isEqualTo: true)
                            .orderBy('order', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('حدث خطأ في تحميل الفئات'),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme_Information.Primary_Color,
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return SizedBox.shrink();
                          }

                          final categories = snapshot.data!.docs;

                          return Column(
                            children: categories.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final categoryName = data['name'] ?? 'بدون اسم';
                              final categoryId = doc.id;
                              final containsType = data['contains'] ?? 'files';
                              final linkedCategoryId = data['linkedCategoryId'];
                              final bannerImage = data['bannerImage'];

                              return Column(
                                children: [
                                  BoxWidgetLine(
                                    box: Boxes(
                                      name: categoryName,
                                      onTap: () {
                                        Widget page;

                                        if (containsType == 'categories') {
                                          // Navigate to subcategories page
                                          page = SubCategoriesPage(
                                            parentCategoryId: categoryId,
                                            parentCategoryName: categoryName,
                                            bannerImage: bannerImage,
                                          );
                                        } else {
                                          // Navigate to nasheed list
                                          page = NasheedListByCategoryPage(
                                            categoryID: linkedCategoryId ?? categoryId,
                                            categoryName: categoryName,
                                          );
                                        }

                                        Navigator.push(
                                          context,
                                          MyCustomRoute(
                                            builder: (BuildContext context) => page,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),

                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(context) {
    print("_isAdmin ${_isSuperAdmin}");
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Drawer Header
              Container(
                height: size_H(200),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme_Information.Primary_Color!,
                      Theme_Information.Color_1!.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size_W(100),
                      height: size_H(100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      // child: Icon(
                      //   Icons.mosque,
                      //   size: size_W(40),
                      //   color: Theme_Information.Primary_Color,
                      // ),
                      child: Image.asset("${ImagePath.qubah2}" ,scale: 2,
                      ),

                    ),
                    SizedBox(height: size_H(15)),
                    Text(
                      "قصائد الكردي",
                      style: ourTextStyle(
                        color: Theme_Information.Primary_Color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Zawiyat Al-Kurdi",
                      style: ourTextStyle(
                        color: Theme_Information.Primary_Color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if(_isSuperAdmin)
                    _buildDrawerItem(
                      icon: Icons.menu_book,
                      title: "ارسال قصيدة جديدة",
                      onTap: () {
                        Navigator.pop(context); // Close drawer
                        Navigator.push(
                          context,
                          MyCustomRoute(
                            builder: (BuildContext context) => SendNasheed(),
                          ),
                        );
                      },
                    ),

                    // if(_isSuperAdmin)
                    // _buildDrawerItem(
                    //   icon: Icons.menu_book,
                    //   title: "ارسال قصائد جديدة",
                    //   onTap: () {
                    //     Navigator.pop(context); // Close drawer
                    //     Navigator.push(
                    //       context,
                    //       MyCustomRoute(
                    //         builder: (BuildContext context) => BatchUploadScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),

                    if(_isSuperAdmin)
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: "صفحة المستخدمين",
                      onTap: () {
                        Navigator.pop(context); // Close drawer
                        Navigator.push(
                          context,
                          MyCustomRoute(
                            builder: (BuildContext context) => UserManagementPage(),
                          ),
                        );
                      },
                    ),
                    if(_isSuperAdmin)
                    _buildDrawerItem(
                      icon: Icons.file_copy_outlined,
                      title: "إدارة الفئات",
                      onTap: () {
                        Navigator.pop(context); // Close drawer
                        Navigator.push(
                          context,
                          MyCustomRoute(
                            builder: (BuildContext context) => AdminMenuCategoriesPage(),
                          ),
                        );
                      },
                    ),


                    // ElevatedButton(
                    //   onPressed: () {
                    //     InitializeCategoriesHelper.safeInitialize(context);
                    //   },
                    //   child: Text('إنشاء الفئات'),
                    // ),

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Divider(color: Colors.grey[300]),
                    ),

                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: "تسجيل الخروج",
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        // Clear session
                        await prefs.clear();


                        Navigator.pop(context);
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => SplashScreen()));

                        // Add settings page navigation if you have one
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Divider(color: Colors.grey[300]),
                    Text(
                      "Version 1.0.0",
                      style: ourTextStyle(
                        color: Colors.grey[600]!,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "© 2024 Zawiyat Al-Kurdi",
                      style: ourTextStyle(
                        color: Colors.grey[600]!,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme_Information.Primary_Color!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme_Information.Primary_Color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: ourTextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

