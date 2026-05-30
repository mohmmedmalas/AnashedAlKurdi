import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nasheedapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isUploaderOnly = false;
  bool _canPush = false;


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
      // bool adminPermission = await UserService.isCurrentUserSuperAdminAdmin();
      // _isAdminPermission = adminPermission ;
      ///
      bool adminPermission = await UserService.isCurrentUserSuperAdminAdmin();
      bool canUpload = await UserService.canCurrentUserUpload();
      bool canPush = await UserService.canCurrentUserPush();

      bool uploaderOnly = await UserService.isUploaderOnly();
      _isUploaderOnly = uploaderOnly;


      _isAdminPermission = adminPermission || canUpload;
      _canPush = canPush;

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
            // actions: _isAdminPermission
            //     ? [
            //         // if (isAdmin)
            //         IconButton(
            //           icon: Icon(Icons.vpn_key), // Key icon
            //           onPressed: () => _openCategoryEditor(context),
            //         ),
            //         IconButton(
            //           icon: Icon(Icons.broadcast_on_home), // Push to all users
            //           onPressed: pushFileToAllUsers,
            //           // onPressed: _pushToAllUsers,
            //         ),
            //       ]
            //     : [])

          actions: [
            // Category editor — only admins
            if (_isAdminPermission && !_isUploaderOnly) // 🔑 hidden from uploaders
              IconButton(
                icon: Icon(Icons.vpn_key),
                onPressed: () => _openCategoryEditor(context),
              ),
            // Push button — admins OR users with can_push flag
            if (_isAdminPermission || _canPush) // push visible to uploaders with can_push
              IconButton(
                icon: Icon(Icons.broadcast_on_home),
                onPressed: pushFileToAllUsers,
              ),
          ])
        ,

        /// voice
        ///
        // body: pdfLocal(),
        body: Container(
          color: const Color(0xFFFDF6E3), child: _buildContent()),


        // body: buildSfPdfViewer(),
      ),
    );
  }

  Widget _buildContent() {
    final contentType = widget.pdfFile.contentType ?? 'pdf';

    if (contentType == 'image') {
      return _buildImageViewer();
    } else if (contentType == 'text') {
      return _buildTextViewer();
    } else if (contentType == 'wasla') {
      return _buildWaslaViewer(); // NEW
    } else {
      return pdfLocal();
    }
  }

// NEW:
  Widget _buildTextViewer() {
    final lines = (widget.pdfFile.textContent ?? '').split('\n');

    return   LayoutBuilder(
        builder: (context, constraints) {
        return Container(
            color: const Color(0xFFFDF6E3),
          width: constraints.maxWidth,  // exact screen width
          child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 3.0,
            child: Container(
              color: const Color(0xFFFDF6E3),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  children: [
                    _ornament(),
                    SizedBox(height: 6),
                    Text(
                      widget.pdfFile.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'calibri',
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    SizedBox(height: 6),
                    _ornament(),
                    SizedBox(height: 30),
                    ..._buildLines(lines),
                    SizedBox(height: 40),
                    _ornament(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildWaslaViewer() {
    final items = widget.pdfFile.items;

    if (items == null || items.isEmpty) {
      return Center(child: Text('لا توجد قصائد في هذه الوصلة'));
    }

    // Sort by order
    final sortedItems = List<WaslaItem>.from(items)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Container(
      color: const Color(0xFFFDF6E3),
      child: FutureBuilder<List<GeneralFireBaseList>>(
        future: _fetchWaslaItems(sortedItems),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme_Information.Primary_Color,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل الوصلة...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ في تحميل الوصلة'));
          }

          final nasheeds = snapshot.data ?? [];

          return LayoutBuilder(
            builder: (context, constraints) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 3.0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Wasla title ──
                        _ornament(),
                        SizedBox(height: 8),
                        Text(
                          widget.pdfFile.name ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri',
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${nasheeds.length} قصائد',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                        SizedBox(height: 8),
                        _ornament(),
                        SizedBox(height: 30),

                        // ── Nasheeds ──
                        ...nasheeds.asMap().entries.map((entry) {
                          final index = entry.key;
                          final nasheed = entry.value;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // nasheed block
                              _buildWaslaItemWidget(nasheed, index + 1, constraints.maxWidth),

                              // divider between nasheeds
                              if (index < nasheeds.length - 1) ...[
                                SizedBox(height: 20),
                                _waslaItemDivider(),
                                SizedBox(height: 20),
                              ],
                            ],
                          );
                        }).toList(),

                        SizedBox(height: 40),
                        _ornament(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

// ── Fetch all nasheeds in the wasla ──────────────────────────────
  Future<List<GeneralFireBaseList>> _fetchWaslaItems(
      List<WaslaItem> items) async {
    List<GeneralFireBaseList> result = [];

    for (final item in items) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('Nasheed')
            .doc(item.nasheedId)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          result.add(GeneralFireBaseList(
            id: doc.id,
            name: data['name'],
            filePdf: data['file_pdf'],
            imageUrl: data['image_url'],
            textContent: data['text_content'],
            contentType: data['content_type'],
          ));
        }
      } catch (e) {
        print('Error fetching wasla item: $e');
      }
    }

    return result;
  }

// ── Build each nasheed block ─────────────────────────────────────
  Widget _buildWaslaItemWidget(
      GeneralFireBaseList nasheed, int number, double maxWidth) {
    final contentType = nasheed.contentType ?? 'pdf';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Nasheed header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✦ ', style: TextStyle(color: Color(0xFFBCAAA4), fontSize: 14)),
            Text(
              nasheed.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'calibri',
                color: Color(0xFF5D4037),
              ),
            ),
            Text(' ✦', style: TextStyle(color: Color(0xFFBCAAA4), fontSize: 14)),
          ],
        ),

        SizedBox(height: 16),

        // ── Nasheed content ──
        if (contentType == 'text')
          _buildWaslaTextItem(nasheed)
        else if (contentType == 'image')
          _buildWaslaImageItem(nasheed)
        else
          _buildWaslaPdfItem(nasheed, maxWidth),
      ],
    );
  }

// ── Text item ────────────────────────────────────────────────────
  Widget _buildWaslaTextItem(GeneralFireBaseList nasheed) {
    final lines = (nasheed.textContent ?? '').split('\n');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildLines(lines),
    );
  }

// ── Image item ───────────────────────────────────────────────────
  Widget _buildWaslaImageItem(GeneralFireBaseList nasheed) {
    final imageUrl = nasheed.imageUrl ?? '';
    if (imageUrl.isEmpty) return SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 100,
          child: Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

// ── PDF item — rendered as images using pdfrx ────────────────────
//   Widget _buildWaslaPdfItem(GeneralFireBaseList nasheed, double maxWidth) {
//     String pdfUrl = nasheed.filePdf ?? '';
//     if (pdfUrl.isEmpty) return SizedBox.shrink();
//
//     // Fix old storage.googleapis.com URLs → convert to firebasestorage format
//     if (pdfUrl.startsWith('https://storage.googleapis.com/')) {
//       // Extract bucket and path
//       // From: https://storage.googleapis.com/BUCKET/PATH
//       // To:   https://firebasestorage.googleapis.com/v0/b/BUCKET/o/ENCODED_PATH?alt=media
//       final uri = Uri.parse(pdfUrl);
//       final pathSegments = uri.pathSegments; // [bucket, ...path]
//       final bucket = pathSegments[0];
//       final filePath = pathSegments.sublist(1).join('/');
//       final encodedPath = Uri.encodeComponent(filePath);
//       pdfUrl = 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
//     }
//
//     print('Normalized PDF URL: $pdfUrl');
//
//
//     return FutureBuilder<PdfDocument>(
//       future: PdfDocument.openUri(Uri.parse(pdfUrl)),
//
//       builder: (context, snapshot) {
//         // print('PDF URL: $pdfUrl');
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 120,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: Theme_Information.Primary_Color,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'جاري تحميل الملف...',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         if (snapshot.hasError || !snapshot.hasData) {
//           return Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.red.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.red.shade200),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.red),
//                 SizedBox(width: 8),
//                 Text('تعذر تحميل الملف',
//                     style: TextStyle(color: Colors.red)),
//               ],
//             ),
//           );
//         }
//
//         final doc = snapshot.data!;
//         final pageCount = doc.pages.length;
//         final pageWidth = maxWidth - 48;
//
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(pageCount, (pageIndex) {
//             final page = doc.pages[pageIndex];
//             final pageHeight = pageWidth * page.height / page.width;
//
//             return Padding(
//               padding: EdgeInsets.only(bottom: 8),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: PdfPageView(
//                   document: doc,          // FIX
//                   pageNumber: pageIndex + 1, // FIX — 1-based
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
  Widget _buildWaslaPdfItem(GeneralFireBaseList nasheed, double maxWidth) {
    String pdfUrl = nasheed.filePdf ?? '';
    if (pdfUrl.isEmpty) return SizedBox.shrink();

    // Fix old storage.googleapis.com URLs
    if (pdfUrl.startsWith('https://storage.googleapis.com/')) {
      final uri = Uri.parse(pdfUrl);
      final pathSegments = uri.pathSegments;
      final bucket = pathSegments[0];
      final filePath = pathSegments.sublist(1).join('/');
      final encodedPath = Uri.encodeComponent(filePath);
      pdfUrl = 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
    }

    final pageWidth = maxWidth - 48;

    return FutureBuilder<Uint8List>(
      future: _downloadPdfBytes(pdfUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Theme_Information.Primary_Color),
                  SizedBox(height: 8),
                  Text('جاري تحميل الملف...',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          print('PDF load error: ${snapshot.error}');
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('تعذر تحميل الملف', style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        }

        return FutureBuilder<PdfDocument>(
          future: PdfDocument.openData(snapshot.data!),
          builder: (context, docSnapshot) {
            if (docSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 80,
                child: Center(child: CircularProgressIndicator(
                  color: Theme_Information.Primary_Color,
                )),
              );
            }

            if (docSnapshot.hasError || !docSnapshot.hasData) {
              print('PDF parse error: ${docSnapshot.error}');
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('تعذر فتح الملف',
                    style: TextStyle(color: Colors.red)),
              );
            }

            final doc = docSnapshot.data!;
            final pageCount = doc.pages.length;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(pageCount, (pageIndex) {
                final page = doc.pages[pageIndex];
                final pageHeight = pageWidth * page.height / page.width;

                return Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    width: pageWidth,
                    height: pageHeight,
                    child: PdfPageView(
                      document: doc,
                      pageNumber: pageIndex + 1,
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

// Download PDF as bytes
  Future<Uint8List> _downloadPdfBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception('Failed to download PDF: ${response.statusCode}');
  }
// ── Divider between wasla items ──────────────────────────────────
  Widget _waslaItemDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFD7CCC8), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '✦',
            style: TextStyle(color: Color(0xFFBCAAA4), fontSize: 16),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFD7CCC8), thickness: 1)),
      ],
    );
  }
  List<Widget> _buildLines(List<String> lines) {
    List<Widget> widgets = [];
    bool lastWasEmpty = false;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) {
        if (!lastWasEmpty) {
          widgets.add(SizedBox(height: 10));
          widgets.add(_stanzaDivider());
          widgets.add(SizedBox(height: 10));
        }
        lastWasEmpty = true;
      } else {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            line,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'calibri',
              color: Color(0xFF3E2723),
              height: 1.8,
            ),
          ),
        ));
        lastWasEmpty = false;
      }
    }
    return widgets;
  }

  Widget _stanzaDivider() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (_) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 5, height: 5,
        decoration: BoxDecoration(
          color: Color(0xFFBCAAA4),
          shape: BoxShape.circle,
        ),
      ),
    )),
  );

  Widget _ornament() => Text(
    '✦',
    style: TextStyle(color: Color(0xFFBCAAA4), fontSize: 18),
  );

  Widget _buildImageViewer() {
    final imageUrl = widget.pdfFile.imageUrl ?? '';

    if (imageUrl.isEmpty) {
      return Center(child: Text('لا توجد صورة'));
    }

    return Container(
      color: const Color(0xFFFDF6E3), // ADD
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('تعذر تحميل الصورة'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> pushFileToAllUsers() async {
  //   // Show confirmation
  //   bool? confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => Directionality(
  //       textDirection: TextDirection.rtl,
  //       child: AlertDialog(
  //         title: Text('تأكيد الإرسال'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('هل تريد إرسال هذه القصيدة لجميع المستخدمين؟'),
  //             SizedBox(height: 12),
  //             Container(
  //               padding: EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.blue.shade50,
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(color: Colors.blue.shade200),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.picture_as_pdf, color: Colors.blue),
  //                   SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(
  //                       widget.pdfFile.name??"",
  //                       style: TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 12),
  //             Text(
  //               'سيرى جميع المستخدمين تنبيهاً عند فتح التطبيق',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: Text('إلغاء'),
  //           ),
  //           ElevatedButton.icon(
  //             icon: Icon(Icons.send),
  //             label: Text('إرسال'),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.green,
  //               foregroundColor: Colors.white,
  //             ),
  //             onPressed: () => Navigator.pop(context, true),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   if (confirm != true) return;
  //
  //
  //   _pushToAllUsers();
  //
  // }
  Future<void> pushFileToAllUsers() async {
    final file = widget.pdfFile;
    final contentType = file.contentType ?? 'pdf';

    // Icon and color based on content type
    IconData typeIcon = contentType == 'image'
        ? Icons.image
        : contentType == 'text'
        ? Icons.text_fields
        : Icons.picture_as_pdf;

    Color typeColor = contentType == 'image'
        ? Colors.blue
        : contentType == 'text'
        ? Colors.green
        : Colors.red;

    String typeLabel = contentType == 'image'
        ? 'صورة'
        : contentType == 'text'
        ? 'نص'
        : 'PDF';

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.broadcast_on_home, color: Colors.green, size: 26),
              SizedBox(width: 10),
              Text('إرسال للجميع'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nasheed preview card
              // Container(
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: typeColor.withOpacity(0.08),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: typeColor.withOpacity(0.3)),
              //   ),
              //   child: Row(
              //     children: [
              //       Container(
              //         padding: EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //           color: typeColor.withOpacity(0.15),
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: Icon(typeIcon, color: typeColor, size: 28),
              //       ),
              //       SizedBox(width: 12),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               file.name ?? '',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 15,
              //               ),
              //             ),
              //             SizedBox(height: 4),
              //             Container(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 8, vertical: 2),
              //               decoration: BoxDecoration(
              //                 color: typeColor.withOpacity(0.15),
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Text(
              //                 typeLabel,
              //                 style: TextStyle(
              //                   fontSize: 11,
              //                   color: typeColor,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Replace typeIcon/typeColor/typeLabel logic with just:
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme_Information.Primary_Color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme_Information.Primary_Color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Theme_Information.Primary_Color, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        file.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 14),

              // Info row
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سيرى جميع المستخدمين تنبيهاً عند فتح التطبيق',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.send, size: 16),
              label: Text('إرسال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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



  // void _pushToAllUsers() async {
  //   try {
  //     final file = widget.pdfFile;
  //
  //     await FirebaseFirestore.instance
  //         .collection('ActiveFiles')
  //         .doc('current') // Overwrite the single active file
  //         .set(file.toMap());
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("تم ارسال القصيدة لكل المستخدمين")),
  //     );
  //   } catch (e) {
  //     print("Error pushing file: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("خطأ في ارسال القصيدة")),
  //     );
  //   }
  // }

  void _pushToAllUsers() async {
    try {
      final file = widget.pdfFile;
      final prefs = await SharedPreferences.getInstance();
      final currentUid = prefs.getString('user_uid') ?? '';

      print("saving pushed_by_uid: $currentUid"); // debug

      await FirebaseFirestore.instance
          .collection('ActiveFiles')
          .doc('current')
          .set({
        ...file.toMap(),
        'pushed_by_uid': currentUid,
        'pushed_at': FieldValue.serverTimestamp(),
      });

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
    return  PDF(
      // autoSpacing: false,
      // enableSwipe: true,
      // pageFling: false,
      // pageSnap: false,

      autoSpacing: Platform.isIOS ? true : false,
      // autoSpacing: true,
      enableSwipe: true,
      pageFling: false,
      fitEachPage: true,
      // ✅ Automatically fits each page to the screen
      pageSnap: false,
    ).fromUrl(widget.pdfFile.filePdf??"");
  }
}
