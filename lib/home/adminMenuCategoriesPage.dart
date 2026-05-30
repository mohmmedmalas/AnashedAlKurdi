
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
// import '../contant/beadsCounterPage.dart';
// import '../contant/beadsPrivetCounterPage.dart';
// import '../contant/contactUs.dart';
// import '../contant/filesMauled.dart';
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

class AdminMenuCategoriesPage extends StatelessWidget {
  const AdminMenuCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "إدارة فئات القائمة",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context, null, null);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme_Information.Primary_Color,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('menu_categories')
              .orderBy('order', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme_Information.Primary_Color,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('لا توجد فئات'));
            }

            final categories = snapshot.data!.docs;

            // Group by parent
            final mainCategories = categories.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['isMain'] == true;
            }).toList();

            final subCategories = categories.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['isMain'] != true;
            }).toList();

            return ListView(
              children: [
                // Main Categories
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'الفئات الرئيسية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme_Information.Primary_Color,
                    ),
                  ),
                ),
                ...mainCategories.map((doc) => _buildCategoryCard(context, doc, 0)),

                // Subcategories
                if (subCategories.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'الفئات الفرعية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme_Information.Primary_Color,
                      ),
                    ),
                  ),
                  ...subCategories.map((doc) => _buildCategoryCard(context, doc, 20)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, DocumentSnapshot doc, double indent) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['name'] ?? 'بدون اسم';
    final isMain = data['isMain'] ?? false;
    final contains = data['contains'] ?? 'files';
    final order = data['order'] ?? 0;
    final parentId = data['parentId'];

    return Container(
      margin: EdgeInsets.only(left: indent, right: 10, top: 5, bottom: 5),
      child: Card(
        child: ListTile(
          leading: Icon(
            contains == 'categories' ? Icons.folder : Icons.music_note,
            color: Theme_Information.Primary_Color,
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'النوع: ${contains == "files" ? "ملفات" : "فئات"} | الترتيب: $order${parentId != null ? " | فرعية" : ""}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (contains == 'categories')
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    _showAddCategoryDialog(context, null, doc.id);
                  },
                ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showAddCategoryDialog(context, doc, null);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteCategory(context, doc.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
///
//   void _showAddCategoryDialog(BuildContext context, DocumentSnapshot? doc, String? parentId) {
//     final isEdit = doc != null;
//     final data = doc?.data() as Map<String, dynamic>?;
//
//     final nameController = TextEditingController(text: data?['name'] ?? '');
//     final orderController = TextEditingController(text: (data?['order'] ?? 0).toString());
//     final linkedCategoryController = TextEditingController(text: data?['linkedCategoryId'] ?? '');
//     final bannerImageController = TextEditingController(text: data?['bannerImage'] ?? '');
//
//     String selectedContains = data?['contains'] ?? 'files';
//     bool isMain = data?['isMain'] ?? (parentId == null);
//     String? selectedParentId = data?['parentId'] ?? parentId;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text(isEdit ? 'تعديل الفئة' : 'إضافة فئة جديدة'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         labelText: 'اسم الفئة',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: orderController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'الترتيب',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<String>(
//                       value: selectedContains,
//                       decoration: InputDecoration(
//                         labelText: 'يحتوي على',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: [
//                         DropdownMenuItem(value: 'files', child: Text('ملفات (قصائد)')),
//                         DropdownMenuItem(value: 'categories', child: Text('فئات فرعية')),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           selectedContains = value!;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     if (selectedContains == 'files')
//                       TextField(
//                         controller: linkedCategoryController,
//                         decoration: InputDecoration(
//                           labelText: 'معرف الفئة المرتبطة',
//                           border: OutlineInputBorder(),
//                           hintText: '4F5NaRyX1YY7Wgu5HBTT',
//                         ),
//                       ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: bannerImageController,
//                       decoration: InputDecoration(
//                         labelText: 'مسار صورة البانر (اختياري)',
//                         border: OutlineInputBorder(),
//                         hintText: 'ImagePath.awrad',
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     SwitchListTile(
//                       title: Text('فئة رئيسية'),
//                       subtitle: Text('تظهر في الصفحة الرئيسية'),
//                       value: isMain,
//                       onChanged: selectedParentId == null ? (value) {
//                         setState(() {
//                           isMain = value;
//                         });
//                       } : null,
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('إلغاء'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _saveCategory(
//                       context,
//                       doc?.id,
//                       nameController.text,
//                       int.tryParse(orderController.text) ?? 0,
//                       selectedContains,
//                       isMain,
//                       selectedParentId,
//                       linkedCategoryController.text.isEmpty ? null : linkedCategoryController.text,
//                       bannerImageController.text.isEmpty ? null : bannerImageController.text,
//                     );
//                     Navigator.pop(context);
//                   },
//                   child: Text(isEdit ? 'تحديث' : 'إضافة'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
  ///

  void _showAddCategoryDialog(BuildContext context, DocumentSnapshot? doc, String? parentId) {
    final isEdit = doc != null;
    final data = doc?.data() as Map<String, dynamic>?;

    final nameController = TextEditingController(text: data?['name'] ?? '');
    final orderController = TextEditingController(text: (data?['order'] ?? 0).toString());
    final bannerImageController = TextEditingController(text: data?['bannerImage'] ?? '');

    String selectedContains = data?['contains'] ?? 'files';
    bool isMain = data?['isMain'] ?? (parentId == null);
    String? selectedParentId = data?['parentId'] ?? parentId;
    String? selectedLinkedCategoryId = data?['linkedCategoryId'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? 'تعديل الفئة' : 'إضافة فئة جديدة'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الفئة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: orderController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الترتيب',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedContains,
                      decoration: InputDecoration(
                        labelText: 'يحتوي على',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'files', child: Text('ملفات (قصائد)')),
                        DropdownMenuItem(value: 'categories', child: Text('فئات فرعية')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedContains = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    if (selectedContains == 'files')
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .orderBy('name')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('حدث خطأ في تحميل الفئات');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text('لا توجد فئات');
                          }

                          final categories = snapshot.data!.docs;

                          return DropdownButtonFormField<String>(
                            value: selectedLinkedCategoryId,
                            decoration: InputDecoration(
                              labelText: 'اختر الفئة المرتبطة',
                              border: OutlineInputBorder(),
                              helperText: 'الفئة من مجموعة categories',
                            ),
                            isExpanded: true,
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('-- اختر فئة --'),
                              ),
                              ...categories.map((doc) {
                                final categoryData = doc.data() as Map<String, dynamic>;
                                final categoryName = categoryData['name'] ?? 'بدون اسم';
                                final categoryId = doc.id;

                                return DropdownMenuItem<String>(
                                  value: categoryId,
                                  child: Text('$categoryName ($categoryId)'),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedLinkedCategoryId = value;
                              });
                            },
                          );
                        },
                      ),
                    SizedBox(height: 10),
                    TextField(
                      controller: bannerImageController,
                      decoration: InputDecoration(
                        labelText: 'مسار صورة البانر (اختياري)',
                        border: OutlineInputBorder(),
                        hintText: 'ImagePath.awrad',
                      ),
                    ),
                    SizedBox(height: 10),
                    SwitchListTile(
                      title: Text('فئة رئيسية'),
                      subtitle: Text('تظهر في الصفحة الرئيسية'),
                      value: isMain,
                      onChanged: selectedParentId == null ? (value) {
                        setState(() {
                          isMain = value;
                        });
                      } : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveCategory(
                      context,
                      doc?.id,
                      nameController.text,
                      int.tryParse(orderController.text) ?? 0,
                      selectedContains,
                      isMain,
                      selectedParentId,
                      selectedLinkedCategoryId,
                      bannerImageController.text.isEmpty ? null : bannerImageController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(isEdit ? 'تحديث' : 'إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveCategory(
      BuildContext context,
      String? docId,
      String name,
      int order,
      String contains,
      bool isMain,
      String? parentId,
      String? linkedCategoryId,
      String? bannerImage,
      ) async {
    try {
      final data = {
        'name': name,
        'order': order,
        'contains': contains,
        'isMain': isMain,
        'parentId': parentId,
        'linkedCategoryId': linkedCategoryId,
        'bannerImage': bannerImage,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (docId == null) {
        data['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('menu_categories').add(data);
      } else {
        await FirebaseFirestore.instance
            .collection('menu_categories')
            .doc(docId)
            .update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الحفظ بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  Future<void> _deleteCategory(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذه الفئة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('menu_categories')
            .doc(docId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم الحذف بنجاح')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }
}