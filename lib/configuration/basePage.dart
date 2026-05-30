import 'package:flutter/material.dart';
import 'package:nasheedapp/configuration/theme.dart';
import 'package:provider/provider.dart';

import '../contant/pdfViewerPage.dart';
import '../provider.dart';
// import 'pdf_viewer_page.dart';
// import 'active_file_service.dart'; // Make sure to import this
// import 'general_firebase_list.dart'; // Your model class

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final activeFileService = Provider.of<ActiveFileService>(context);
    if (activeFileService.activeFile != null
        && activeFileService.shouldShowAlert
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewFileAlert(activeFileService);
      });
    }
  }

  // void _showNewFileAlert(ActiveFileService service) {
  //   final file = service.activeFile!;
  //   service.markAlertShown();
  //
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("تنبيه"),
  //       content: Text("تم نشر قصيدة جديدة: ${file.name}"),
  //       actions: [
  //         TextButton(
  //           child: const Text("عرض"),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             Navigator.of(context).push(MaterialPageRoute(
  //               builder: (_) => PdfViewerPage(pdfFile: file),
  //             ));
  //           },
  //         ),
  //         TextButton(
  //           child: const Text("لاحقاً"),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _showNewFileAlert(ActiveFileService service) {
    final file = service.activeFile!;
    final contentType = file.contentType ?? 'pdf';

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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.new_releases, color: Theme_Information.Primary_Color, size: 26),
              SizedBox(width: 10),
              Text('قصيدة جديدة'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تم نشر قصيدة جديدة:',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),

              // Nasheed preview card
// Replace the nasheed preview card with this simple version:
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme_Information.Primary_Color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme_Information.Primary_Color.withOpacity(0.3)),
                ),
                child: Text(
                  file.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              SizedBox(height: 14),
              Text(
                'هل تريد عرضها الآن؟',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('لاحقاً', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                service.markAlertShown();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.visibility, size: 16),
              label: Text('عرض الآن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme_Information.Primary_Color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
    final activeFileService = Provider.of<ActiveFileService>(context);

    return Scaffold(
      // appBar:
      // widget.showAppBar
      //     ? AppBar(title: Text(widget.title ?? ""))
      //     : null,
      body: widget.child,
      // floatingActionButton: activeFileService.activeFile == null
      //     ? null
      //     : buildFloatingActionButton(context, activeFileService),
      floatingActionButton: Consumer<ActiveFileService>(
        builder: (context, service, _) {
          final file = service.activeFile;
          if (file == null) return const SizedBox.shrink();

          if (service.isMinimized) {
            // Show minimized arrow
            return Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 10),
                child: FloatingActionButton.small(
                  heroTag: "restore_fab",
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
                  onPressed: () => service.restore(),
                ),
              ),
            );
          }

          // Show full FAB + ❌ close button
          return SizedBox(
            width: 180,
            height: 100,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: // In the expanded FAB section, replace the icon:
                  FloatingActionButton.extended(
                    heroTag: "main_fab",
                    // backgroundColor: Theme_Information.Primary_Color,
                    icon: Icon(Icons.menu_book, color: Colors.black), // fixed icon
                    label: const Text(
                      'عرض القصيدة',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PdfViewerPage(pdfFile: file),
                      ));
                    },
                  ),
                ),
                Positioned(
                  bottom: 65,
                  right: 10,
                  child: FloatingActionButton.small(
                    heroTag: "close_fab",
                    backgroundColor: Colors.redAccent,
                    tooltip: "إخفاء",
                    child: const Icon(Icons.close),
                    onPressed: () => service.minimize(),
                  ),
                ),
              ],
            ),
          );
        },
      ),


    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context, ActiveFileService activeFileService) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text("عرض القصيدة الحالية"),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              PdfViewerPage(pdfFile: activeFileService.activeFile!),
        ));
      },
    );
  }
}

