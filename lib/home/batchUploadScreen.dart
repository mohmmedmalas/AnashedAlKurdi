import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BatchUploadScreen extends StatefulWidget {
  @override
  _BatchUploadScreenState createState() => _BatchUploadScreenState();
}

class _BatchUploadScreenState extends State<BatchUploadScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool isUploading = false;
  List<String> uploadLogs = [];
  int totalFiles = 0;
  int uploadedFiles = 0;

  // Your existing upload methods
  Future<String> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    final ref = storage.ref().child('nasheeds/$fileName');
    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  // Future<void> addDataToFirebase(String fileName, String downloadUrl) async {
  //   DocumentReference documentReference = firestore.collection("Nasheed").doc();
  //   await documentReference.set({
  //     'id': documentReference.id,
  //     'name': fileName.replaceAll('.pdf', ''),
  //     'file_pdf': downloadUrl,
  //     'uploadedAt': FieldValue.serverTimestamp(),
  //   });
  // }

  // Pick folder and upload all PDFs
  Future<void> pickFolderAndUpload() async {
    try {
      // Pick directory
      String? selectedDirectory = "/storage/emulated/0/Download/PairDrop_files_20251017_2223/";
      // String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        addLog('❌ No directory selected');
        return;
      }


      setState(() {
        isUploading = true;
        uploadLogs.clear();
        uploadedFiles = 0;
      });

      addLog('📁 Selected directory: $selectedDirectory');

      final directory = Directory(selectedDirectory);
      final pdfFiles = directory
          .listSync()
          .where((item) => item.path.endsWith('.pdf'))
          .toList();

      setState(() {
        totalFiles = pdfFiles.length;
      });

      addLog('📄 Found $totalFiles PDF files\n');

      for (var file in pdfFiles) {
        final fileName = file.path.split('/').last;

        addLog('⏳ Uploading: $fileName...');

        try {
          String downloadUrl = await uploadFile(file.path, fileName);
          await addDataToFirebase(fileName, downloadUrl);

          setState(() {
            uploadedFiles++;
          });

          addLog('✅ Success: $fileName');
        } catch (e) {
          addLog('❌ Failed: $fileName - $e');
        }

        await Future.delayed(Duration(milliseconds: 300));
      }

      addLog('\n🎉 Upload completed!');
      addLog('✅ Uploaded: $uploadedFiles / $totalFiles');

    } catch (e) {
      addLog('❌ Error: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void addLog(String message) {
    setState(() {
      uploadLogs.add(message);
    });
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batch Upload Nasheeds'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload Button
            ElevatedButton.icon(
              onPressed: isUploading ? null : uploadAllNasheeds,
              // onPressed: isUploading ? null : pickFolderAndUpload,
              icon: Icon(isUploading ? Icons.hourglass_empty : Icons.upload_file),
              label: Text(isUploading ? 'Uploading...' : 'Select Folder & Upload'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.teal,
              ),
            ),

            SizedBox(height: 16),

            // Progress Indicator
            if (isUploading)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: totalFiles > 0 ? uploadedFiles / totalFiles : 0,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$uploadedFiles / $totalFiles files uploaded',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

            SizedBox(height: 16),

            // Logs
            Text(
              'Upload Logs:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: uploadLogs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        uploadLogs[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Courier',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  final List<Map<String, String>> nasheedFiles = [
    {
      'fileName': 'أبحب أحبابي ألام.pdf',
      'displayName': 'أبحب أحبابي ألام',
    },
    {
      'fileName': 'ألا يا الله بنظرة من العين الرحيمة.pdf',
      'displayName': 'ألا يا الله بنظرة من العين الرحيمة',
    },
    {
      'fileName': 'أيها المشتاق لا تنم.pdf',
      'displayName': 'أيها المشتاق لا تنم',
    },
    {
      'fileName': 'بشرى لنا نلنا المنى.pdf',
      'displayName': 'بشرى لنا نلنا المنى',
    },
    {
      'fileName': 'خَيْرَ البَرِيَّةِ.pdf',
      'displayName': 'خَيْرَ البَرِيَّةِ',
    },
    {
      'fileName': 'عطفا أيا جيرة الحرم .pdf',
      'displayName': 'عطفا أيا جيرة الحرم',
    },
    {
      'fileName': 'فطِب يا أيها القلبُ المُعنّى.pdf',
      'displayName': 'فطِب يا أيها القلبُ المُعنّى',
    },
    {
      'fileName': 'قد تمم الله مقاصدنا.pdf',
      'displayName': 'قد تمم الله مقاصدنا',
    },
    {
      'fileName': 'لاح نور النُور مِن خَلف الخِبا.pdf',
      'displayName': 'لاح نور النُور مِن خَلف الخِبا',
    },
    {
      'fileName': 'يا إمام الرسل يا سنــدي.pdf',
      'displayName': 'يا إمام الرسل يا سنــدي',
    },
    {
      'fileName': 'يا كِثير الملامْ.pdf',
      'displayName': 'يا كِثير الملامْ',
    },
    {
      'fileName': 'ﻳﺎﺑﻨﻲ ﺍﻟﻤﺼﻄﻔﻰ.pdf',
      'displayName': 'ﻳﺎﺑﻨﻲ ﺍﻟﻤﺼﻄﻔﻰ',
    },
  ];

// Usage example - Add this method to your widget/controller
  Future<void> uploadAllNasheeds() async {
    const basePath = '/storage/emulated/0/Download/PairDrop_files_20251017_2223';
    // const basePath = '/Users/mohmmed/Documents/nasheed_alkirdi/pdf';

    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      // return {
      //   'success': false,
      //   'message': 'Storage permission denied',
      // };
      return ;
    }



    for (var nasheed in nasheedFiles) {
      try {
        print('Uploading: ${nasheed['displayName']}');

        // Set the file path
        String filePath = '$basePath/${nasheed['fileName']}';

        // Upload file to Firebase Storage
        String downloadUrl = await uploadFile(filePath, nasheed['fileName']!);

        // Add to Firestore with the display name
        await addDataToFirebase(nasheed['displayName']!, downloadUrl);

        print('✅ Successfully uploaded: ${nasheed['displayName']}');

        // Small delay to avoid overwhelming Firebase
        await Future.delayed(Duration(milliseconds: 500));

      } catch (e) {
        print('❌ Failed to upload ${nasheed['displayName']}: $e');
      }
    }

    print('🎉 All nasheeds uploaded!');
  }

// Modified addDataToFirebase to accept name as parameter
  Future<void> addDataToFirebase(String name, String path) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection("Nasheed").doc();

    await documentReference.set({
      'id': documentReference.id,
      'name': name,
      'file_pdf': path,
      'uploadedAt': FieldValue.serverTimestamp(),
    });

    print('Item added to Firestore successfully!');
  }


  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.photos.request().isGranted ||
          await Permission.videos.request().isGranted) {
        return true;
      }

      // For older Android versions
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Try manage external storage for Android 11+
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      return false;
    }
    return true; // iOS doesn't need these permissions for file picker
  }


}