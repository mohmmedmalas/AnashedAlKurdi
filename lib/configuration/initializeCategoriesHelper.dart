// initialize_categories.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home/dynamicHomePage.dart';
import 'images.dart';

class InitializeCategoriesHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Call this function ONCE to initialize all categories
  static Future<void> initializeAllCategories(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('جاري إنشاء الفئات...'),
            ],
          ),
        ),
      );

      // 1. Create Main Category: ديوان سيدي الكردي
      await _firestore.collection('menu_categories').add({
        'name': 'ديوان سيدي الكردي',
        'contains': 'files',
        'isMain': true,
        'order': 1,
        'parentId': null,
        'linkedCategoryId': 'Xu7D8m9y4dorZu2BuDEJ',
        'bannerImage': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Create Main Category: قصائد الحضرة
      final hadraDoc = await _firestore.collection('menu_categories').add({
        'name': 'قصائد الحضرة',
        'contains': 'categories',
        'isMain': true,
        'order': 2,
        'parentId': null,
        'linkedCategoryId': null,
        'bannerImage': 'ImagePath.awrad',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2.1 Create Subcategories of قصائد الحضرة
      final hadraSubcategories = [
        {'name': 'القيام', 'order': 1},
        {'name': 'الركوع', 'order': 2},
      ];

      for (var subcat in hadraSubcategories) {
        await _firestore.collection('menu_categories').add({
          'name': subcat['name'],
          'contains': 'files',
          'isMain': false,
          'order': subcat['order'],
          'parentId': hadraDoc.id,
          'linkedCategoryId': null, // TODO: Add actual category IDs if you have them
          'bannerImage': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 3. Create Main Category: قصائد حسب المقامات
      final maqamatDoc = await _firestore.collection('menu_categories').add({
        'name': 'قصائد حسب المقامات',
        'contains': 'categories',
        'isMain': true,
        'order': 3,
        'parentId': null,
        'linkedCategoryId': null,
        'bannerImage': 'ImagePath.awrad',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3.1 Create all Maqamat subcategories
      final maqamatList = [
        {'name': 'مقام الصبا', 'categoryId': '4F5NaRyX1YY7Wgu5HBTT', 'order': 1},
        {'name': 'مقام النهاوند', 'categoryId': 'VU6CRKTXJzsdSe9LEiHD', 'order': 2},
        {'name': 'مقام العجم', 'categoryId': 'VPL1YahhBpHebgpHSDQj', 'order': 3},
        {'name': 'مقام البيات', 'categoryId': 'rwaOL69J0XU0bjSISu2d', 'order': 4},
        {'name': 'مقام السيكا', 'categoryId': 'y4Dhad7nnn6o30DJ8Dt7', 'order': 5},
        {'name': 'مقام الحجاز', 'categoryId': 'fcUc3en2pH05Fq4uvqou', 'order': 6},
        {'name': 'مقام الرست', 'categoryId': 'ldgwhOQSIiBPeft8HLPm', 'order': 7},
        {'name': 'مقام الكرد', 'categoryId': 'pbLctXukVR2pVXnTGjUI', 'order': 8},
      ];

      for (var maqam in maqamatList) {
        await _firestore.collection('menu_categories').add({
          'name': maqam['name'],
          'contains': 'files',
          'isMain': false,
          'order': maqam['order'],
          'parentId': maqamatDoc.id,
          'linkedCategoryId': maqam['categoryId'],
          'bannerImage': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إنشاء جميع الفئات بنجاح! ✅'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      print('✅ All categories initialized successfully!');
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );

      print('❌ Error initializing categories: $e');
    }
  }

  // Helper function to check if categories already exist
  static Future<bool> categoriesExist() async {
    try {
      final snapshot = await _firestore
          .collection('menu_categories')
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking categories: $e');
      return false;
    }
  }

  // Safe initialization - only runs if no categories exist
  static Future<void> safeInitialize(BuildContext context) async {
    final exist = await categoriesExist();

    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الفئات موجودة بالفعل!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await initializeAllCategories(context);
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

// Example 1: Add a button in your admin page
class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('تأكيد'),
                    content: Text('هل تريد إنشاء جميع الفئات؟\nهذا سيتم مرة واحدة فقط.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('إلغاء'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('نعم'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await InitializeCategoriesHelper.safeInitialize(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'إنشاء الفئات',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ملاحظة: استخدم هذا الزر مرة واحدة فقط',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Example 2: Add to settings or drawer
Widget _buildInitCategoriesOption(BuildContext context) {
  return ListTile(
    leading: Icon(Icons.category, color: Colors.blue),
    title: Text('إنشاء الفئات الافتراضية'),
    subtitle: Text('استخدم هذا مرة واحدة فقط'),
    onTap: () async {
      await InitializeCategoriesHelper.safeInitialize(context);
    },
  );
}

// Example 3: Automatic initialization on first app launch
class SplashScreenWithInit extends StatefulWidget {
  @override
  State<SplashScreenWithInit> createState() => _SplashScreenWithInitState();
}

class _SplashScreenWithInitState extends State<SplashScreenWithInit> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Check if categories exist
    final exist = await InitializeCategoriesHelper.categoriesExist();

    if (!exist) {
      // First time app launch - initialize categories
      await InitializeCategoriesHelper.initializeAllCategories(context);
    }

    // Wait 2 seconds then navigate
    await Future.delayed(Duration(seconds: 2));

    // Navigate to home or login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DynamicHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.qubah1, height: 150),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('جاري التحميل...'),
          ],
        ),
      ),
    );
  }
}