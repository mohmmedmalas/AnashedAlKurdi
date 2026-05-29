import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nasheedapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:audioplayers/audioplayers.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/userService.dart';
import '../model/generalFireBaseList.dart';
import 'categoryEditor.dart';
import 'nasheedList.dart';

class PdfViewerPage extends StatefulWidget {
  // final String assetPath;
  // final String title;
  final GeneralFireBaseList pdfFile;

  const PdfViewerPage({required this.pdfFile});
  // const PdfViewerPage({required this.assetPath,required this.pdfFile,required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  // AudioPlayer? _player;


  bool _isAdminPermission = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Future.delayed(const Duration(milliseconds: 2), () async {
      bool adminPermission = await UserService.isCurrentUserSuperAdminAdmin();
      _isAdminPermission = adminPermission ;
      setState(() {});
    });
  }


  @override
  void dispose() {
    // Remove the preferred orientations when the page is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("fsd ${widget.pdfFile.id}");
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: myAppBar(
            title: widget.pdfFile.name ?? "",
            context: context,
            actions: _isAdminPermission
                ? [
                    // if (isAdmin)
                    IconButton(
                      icon: Icon(Icons.vpn_key), // Key icon
                      onPressed: () => _openCategoryEditor(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.broadcast_on_home), // Push to all users
                      onPressed: pushFileToAllUsers,
                      // onPressed: _pushToAllUsers,
                    ),
                  ]
                : []),

        /// voice
        ///
        body: pdfLocal(),
        // body: buildSfPdfViewer(),
      ),
    );
  }

  Future<void> pushFileToAllUsers() async {
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
                        widget.pdfFile.name??"",
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


    _pushToAllUsers();

  }


  void _pushToAllUsers() async {
    try {
      final file = widget.pdfFile;

      await FirebaseFirestore.instance
          .collection('ActiveFiles')
          .doc('current') // Overwrite the single active file
          .set(file.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم ارسال القصيدة لكل المستخدمين")),
      );
    } catch (e) {
      print("Error pushing file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في ارسال القصيدة")),
      );
    }
  }


  void _openCategoryEditor(BuildContext context) async {
    final doc = await FirebaseFirestore.instance
        .collection('Nasheed')
        .doc(widget.pdfFile.id??"")
        .get();

    final pdfFile = GeneralFireBaseList.fromMap(doc.data()!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: CategoryEditor(pdfFile: pdfFile , scaffoldContext : context),
      ),
    );
  }

  Widget buildSfPdfViewer(){
    return SfPdfViewer.asset(widget.pdfFile.filePdf??"" , );
  }

  // Widget pdf(){
  Widget pdfLocal(){
    return  const PDF(
      // swipeHorizontal: true,
      autoSpacing: false,
      enableSwipe: true,
      pageFling: false,
      pageSnap: false,
    ).fromUrl(widget.pdfFile.filePdf??"");
  }
}
