
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nasheedapp/configuration/images.dart';
import 'package:nasheedapp/home/sendNasheed.dart';
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
// import 'package:share_plus/share_plus.dart';

import '../commenwidget/boxesHome.dart';
import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../commenwidget/imageSlider.dart';
import '../configuration/basePage.dart';
import '../configuration/theme.dart';
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
import '../starting/splashScreen.dart';
// import '../model.dart';
// import '../contant/pdfViewerPageMix.dart';
// import '../pages/pages/newIamge.dart';
// import '../pages/renewBox/RequestBulkFromBoxes.dart';


import '../commenwidget/boxesHomeOneLine.dart';


// dynamic_categories_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoriesPage extends StatelessWidget {
  final String parentCategoryId;
  final String parentCategoryName;
  final String? bannerImage;

  const SubCategoriesPage({
    Key? key,
    required this.parentCategoryId,
    required this.parentCategoryName,
    this.bannerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: parentCategoryName,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Banner Image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size_H(160),
                  child: ImageSlider(
                    imagePaths: [
                      ImagePath.awrad,
                    ],
                  ),
                ),
              ),

              SizedBox(height: size_H(15)),

              // Get subcategories
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menu_categories')
                    .where('parentId', isEqualTo: parentCategoryId)
                    .orderBy('order', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('حدث خطأ في تحميل الفئات الفرعية'),
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
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('لا توجد فئات فرعية'),
                    );
                  }

                  final subCategories = snapshot.data!.docs;

                  return Column(
                    children: subCategories.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final subCategoryName = data['name'] ?? 'بدون اسم';
                      final subCategoryId = doc.id;
                      final containsType = data['contains'] ?? 'files';
                      final linkedCategoryId = data['linkedCategoryId'];
                      final bannerImage = data['bannerImage'];

                      return Column(
                        children: [
                          BoxWidgetLine(
                            box: Boxes(
                              name: subCategoryName,
                              onTap: () {
                                Widget page;

                                if (containsType == 'categories') {
                                  // Another level of subcategories
                                  page = SubCategoriesPage(
                                    parentCategoryId: subCategoryId,
                                    parentCategoryName: subCategoryName,
                                    bannerImage: bannerImage,
                                  );
                                } else {
                                  // Navigate to nasheed list
                                  page = NasheedListByCategoryPage(
                                    categoryID: linkedCategoryId ??
                                        subCategoryId,
                                    categoryName: subCategoryName,
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
                          SizedBox(height: size_H(15)),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),

              SizedBox(height: size_H(15)),
            ],
          ),
        ),
      ),
    );
  }
}