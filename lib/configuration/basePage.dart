import 'package:flutter/material.dart';
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

  void _showNewFileAlert(ActiveFileService service) {
    final file = service.activeFile!;
    service.markAlertShown();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تنبيه"),
        content: Text("تم نشر قصيدة جديدة: ${file.name}"),
        actions: [
          TextButton(
            child: const Text("عرض"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PdfViewerPage(pdfFile: file),
              ));
            },
          ),
          TextButton(
            child: const Text("لاحقاً"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
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
                  child: FloatingActionButton.extended(
                    heroTag: "main_fab",
                    // backgroundColor: Colors.deepPurple,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("عرض القصيدة"),
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

