// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'model/generalFireBaseList.dart';
//
// // class ActiveFileService extends ChangeNotifier {
// //   GeneralFireBaseList? _activeFile;
// //   GeneralFireBaseList? get activeFile => _activeFile;
// //
// //   bool _hasShownAlert = false;
// //
// //   ActiveFileService() {
// //     _listenToActiveFile();
// //   }
// //
// //   void _listenToActiveFile() {
// //     FirebaseFirestore.instance
// //         .collection('ActiveFiles')
// //         .doc('current')
// //         .snapshots()
// //         .listen((snapshot) {
// //       if (snapshot.exists) {
// //         final newFile = GeneralFireBaseList.fromMap(snapshot.data()!);
// //         if (_activeFile?.id != newFile.id) {
// //           _activeFile = newFile;
// //           _hasShownAlert = false; // Reset alert for new file
// //           notifyListeners();
// //         }
// //       }
// //     });
// //   }
// //
// //   bool get shouldShowAlert => !_hasShownAlert;
// //
// //   void markAlertShown() {
// //     _hasShownAlert = true;
// //   }
// // }
// ///
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ActiveFileService extends ChangeNotifier {
//   GeneralFireBaseList? _activeFile;
//   bool _hasShownAlert = false;
//   bool _isMinimized = false; // ✅ this is the only flag now
//
//   GeneralFireBaseList? get activeFile => _activeFile;
//   bool get shouldShowAlert => !_hasShownAlert;
//   bool get isMinimized => _isMinimized;
//
//   ActiveFileService() {
//     _listenToActiveFile();
//   }
//
//   void _listenToActiveFile() {
//     FirebaseFirestore.instance
//         .collection('ActiveFiles')
//         .doc('current')
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.exists) {
//         final newFile = GeneralFireBaseList.fromMap(snapshot.data()!);
//         if (_activeFile?.id != newFile.id) {
//           _activeFile = newFile;
//           _hasShownAlert = false;
//           _isMinimized = false; // ✅ reset on new file push
//           notifyListeners();
//         }
//       }
//     });
//   }
//
//   void markAlertShown() {
//     _hasShownAlert = true;
//   }
//
//   void minimize() {
//     _isMinimized = true;
//     notifyListeners();
//   }
//
//   void restore() {
//     _isMinimized = false;
//     notifyListeners();
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'configuration/theme.dart';
import 'configuration/userService.dart';
import 'contant/pdfViewerPage.dart';
import 'model/generalFireBaseList.dart';

// ============================================
// 1. SIMPLE ACTIVE FILE SERVICE
// ============================================

class ActiveFileService extends ChangeNotifier {
  GeneralFireBaseList? _activeFile;
  bool _hasShownAlertThisSession = false; // Only show once per app session
  bool _isMinimized = false;

  GeneralFireBaseList? get activeFile => _activeFile;
  bool get shouldShowAlert => !_hasShownAlertThisSession && _activeFile != null;
  bool get isMinimized => _isMinimized;

  ActiveFileService() {
    _listenToActiveFile();
  }

  void _listenToActiveFile() {
    FirebaseFirestore.instance
        .collection('ActiveFiles')
        .doc('current')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final newFile = GeneralFireBaseList.fromMap(snapshot.data()!);

        // If it's a different file, show alert again
        if (_activeFile?.id != newFile.id) {
          _activeFile = newFile;
          _hasShownAlertThisSession = false; // Reset for new file
          _isMinimized = false;
          notifyListeners();
        }
      } else {
        // No active file
        _activeFile = null;
        _isMinimized = false;
        notifyListeners();
      }
    });
  }

  void markAlertShown() {
    _hasShownAlertThisSession = true;
    notifyListeners();
  }

  void minimize() {
    _isMinimized = true;
    notifyListeners();
  }

  void restore() {
    _isMinimized = false;
    notifyListeners();
  }
}

// ============================================
// 2. BASE PAGE (Shows alert once)
// ============================================

class BasePage extends StatefulWidget {
  final Widget child;
  final bool showAppBar;
  final String? title;

  const BasePage({
    required this.child,
    this.showAppBar = true,
    this.title,
    super.key,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _hasChecked = false; // Prevent multiple checks on same page

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only check once per page load
    if (!_hasChecked) {
      _hasChecked = true;
      final activeFileService = Provider.of<ActiveFileService>(context, listen: false);

      if (activeFileService.shouldShowAlert) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNewFileAlert(activeFileService);
        });
      }
    }
  }

  void _showNewFileAlert(ActiveFileService service) {
    final file = service.activeFile!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.new_releases, color: Theme_Information.Primary_Color, size: 28),
              SizedBox(width: 10),
              Text("قصيدة جديدة"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تم نشر قصيدة جديدة:",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme_Information.Primary_Color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf,
                        color: Theme_Information.Primary_Color,
                        size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        file.name??"",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme_Information.Primary_Color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "هل تريد عرضها الآن؟",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("لاحقاً"),
              onPressed: () {
                service.markAlertShown();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.visibility, size: 18),
              label: Text("عرض الآن"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme_Information.Primary_Color,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                service.markAlertShown();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PdfViewerPage(pdfFile: file),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: TextDirection.rtl,
      child: Scaffold(
        body: widget.child,
        floatingActionButton: Consumer<ActiveFileService>(
          builder: (context, service, _) {
            final file = service.activeFile;
            if (file == null) return const SizedBox.shrink();

            if (service.isMinimized) {
              // Minimized: Show small arrow button
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 10),
                    child: FloatingActionButton.small(
                      heroTag: "restore_fab",
                      backgroundColor: Theme_Information.Primary_Color,
                      tooltip: "عرض القصيدة",
                      child: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                      onPressed: () => service.restore(),
                    ),
                  ),
                ),
              );
            }

            // Expanded: Show full FAB with close button
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: 180,
                height: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main FAB
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton.extended(
                        heroTag: "main_fab",
                        backgroundColor: Theme_Information.Primary_Color,
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: const Text(
                          "عرض القصيدة",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PdfViewerPage(pdfFile: file),
                          ));
                        },
                      ),
                    ),
                    // Close button
                    Positioned(
                      bottom: 65,
                      right: 10,
                      child: FloatingActionButton.small(
                        heroTag: "close_fab",
                        backgroundColor: Colors.redAccent,
                        tooltip: "إخفاء",
                        child: const Icon(Icons.close, size: 18, color: Colors.white),
                        onPressed: () => service.minimize(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================
// 3. ADMIN: PUSH FILE TO ALL USERS
// ============================================

Future<void> pushFileToAllUsers(BuildContext context, GeneralFireBaseList pdfFile) async {
  // Show confirmation
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('تأكيد الإرسال'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل تريد إرسال هذه القصيدة لجميع المستخدمين؟'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pdfFile.name??"",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'سيرى جميع المستخدمين تنبيهاً عند فتح التطبيق',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.send),
            label: Text('إرسال'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );

  if (confirm != true) return;

  // Show loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // Get admin info
    String? adminUid = await UserService.getCurrentUserUid();
    UserData? adminData = await UserService.getCurrentUserData();

    // Push to ActiveFiles
    await FirebaseFirestore.instance
        .collection('ActiveFiles')
        .doc('current')
        .set({
      ...pdfFile.toMap(),
      'pushed_at': FieldValue.serverTimestamp(),
      'pushed_by_uid': adminUid,
      'pushed_by_name': adminData?.name ?? 'Admin',
    });

    if (context.mounted) Navigator.pop(context); // Close loading

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("تم إرسال القصيدة لجميع المستخدمين ✅"),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    if (context.mounted) Navigator.pop(context); // Close loading

    print("Error pushing file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("خطأ في إرسال القصيدة: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// ============================================
// 4. ADMIN: CLEAR ACTIVE FILE
// ============================================

Future<void> clearActiveFile(BuildContext context) async {
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('تأكيد الإزالة'),
        content: Text(
          'هل تريد إزالة القصيدة النشطة؟\n\nلن يرى المستخدمون أي تنبيه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إزالة'),
          ),
        ],
      ),
    ),
  );

  if (confirm != true) return;

  try {
    await FirebaseFirestore.instance
        .collection('ActiveFiles')
        .doc('current')
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم إزالة القصيدة النشطة"),
        backgroundColor: Colors.orange,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("خطأ: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// ============================================
// 5. USAGE EXAMPLE IN ADMIN PANEL
// ============================================

class AdminPdfCard extends StatelessWidget {
  final GeneralFireBaseList pdfFile;

  const AdminPdfCard({required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // PDF Icon
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
            ),

            SizedBox(width: 12),

            // File name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pdfFile.name??"",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // if (pdfFile.description != null)
                  //   Text(
                  //     pdfFile.description!,
                  //     style: TextStyle(fontSize: 12, color: Colors.grey),
                  //   ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Push button
            ElevatedButton.icon(
              icon: Icon(Icons.send, size: 18),
              label: Text("إرسال"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () => pushFileToAllUsers(context, pdfFile),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 6. ADMIN PANEL WITH CURRENT ACTIVE FILE
// ============================================

class AdminActiveFilePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ActiveFiles')
          .doc('current')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "لا توجد قصيدة نشطة حالياً",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final activeFile = GeneralFireBaseList.fromMap(data);
        final pushedAt = data['pushed_at'] as Timestamp?;
        final pushedBy = data['pushed_by_name'] as String?;

        return Card(
          margin: EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "القصيدة النشطة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),

                Divider(height: 24),

                // File info
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        activeFile.name??"",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (pushedAt != null) ...[
                  SizedBox(height: 8),
                  Text(
                    "تم النشر: ${_formatDate(pushedAt.toDate())}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],

                if (pushedBy != null) ...[
                  Text(
                    "بواسطة: $pushedBy",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],

                SizedBox(height: 16),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.visibility),
                        label: Text("معاينة"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfViewerPage(pdfFile: activeFile),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.clear),
                        label: Text("إزالة"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => clearActiveFile(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
