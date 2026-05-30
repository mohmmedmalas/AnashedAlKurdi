// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nasheedapp/configuration/theme.dart';
//
// import '../commenwidget/customAppBar.dart';
//
// class SendNasheed extends StatefulWidget {
//   const SendNasheed({Key? key}) : super(key: key);
//
//   @override
//   State<SendNasheed> createState() => _SendNasheedState();
// }
//
// class _SendNasheedState extends State<SendNasheed> {
//
//   TextEditingController titleController = TextEditingController();
//   String? filePathNasheed;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar(
//           // leadingWidget: SizedBox(),
//           title: "تحميل قصيدة جديدة",
//           context: context
//         // title: "Home Page",
//         // title: Text(titles[_currentIndex] , style: ourTextStyle(color: Theme_Information.Color_1, fontSize: 18),),
//       ),
//       body: SingleChildScrollView(
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(labelText: 'العنوان'),
//                 ),
//                 SizedBox(height: 16),
//
//                 Column(
//                   children: [
//                     MaterialButton(
//                       minWidth: 200,
//                      color: Theme_Information.Primary_Color,
//                       // controller: TextEditingController(),
//                       child: Text("اختيار ملف القصيدة" , style: TextStyle(color: Colors.white),),
//                       onPressed: () async {
//                         // _showActionSheet(context);
//
//                         final act = CupertinoActionSheet(
//                             actions: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
//                                 child: CupertinoActionSheetAction(
//                                   child: Text('تحميل' , style: ourTextStyle(fontSize: 17),),
//                                   onPressed: () async {
//                                     String? path = await pickFile();
//                                     if (path != null) {
//                                       Navigator.pop(context);
//                                     }
//                                   },
//                                 ),
//                               ),
//                               if(filePathNasheed != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
//                                   child: CupertinoActionSheetAction(
//                                     child: Text('حذف الملف' , style: ourTextStyle(fontSize: 17),),
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       setState(() {
//                                         filePathNasheed = null ;
//                                       });
//                                     },
//                                   ),
//                                 )
//                             ],
//                             cancelButton: CupertinoActionSheetAction(
//                               child: Text('إلغاء', style: ourTextStyle(fontSize: 17 ,color: Colors.red , fontWeight: FontWeight.w500),),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ));
//                         showCupertinoModalPopup(
//                             context: context,
//                             builder: (BuildContext context) => act);
//
//
//
//                       },
//                     ),
//                     if(filePathNasheed != null)
//                       Padding(
//                         padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
//                         child: Container(
//                           height: 50,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text("${filePathNasheed!.split("/").last}" , style: TextStyle(),),
//                               GestureDetector(
//                                   onTap: (){
//                                     showDialog(
//                                       context: context,
//                                       builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
//                                         title: Text('تأكيد'),
//                                         content: Text('هل تريد حذف الملف'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('رجوع'),
//                                           ),
//
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('موافق'),
//                                           ),
//                                         ],
//                                       )),
//                                     );
//
//                                     // MyConfirmationDialog().showConfirmationDialog(
//                                     //   context: context,
//                                     //   title: "Confirmation",
//                                     //   body: "Do you want to remove your CV?",
//                                     //   saveBtn: "Remove",
//                                     //   onSave: (){
//                                     //     setState(() {
//                                     //       filePathNasheed = null ;
//                                     //     });
//                                     //   },
//                                     // );
//                                   },
//                                   child: Icon(Icons.remove_circle_outline_sharp))
//                             ],
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//                 SizedBox(height: 16),
//
//
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all<Color>(Theme_Information.Primary_Color)
//                   ),
//                   onPressed: () {
//                     // _sendNotification();
//
//                     if(filePathNasheed != null)
//                     _showConfirmationDialog("${filePathNasheed!.split("/").last}");
//
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('ارسال القصيدة' , style: ourTextStyle(color: Theme_Information.Color_1),),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog(name) {
//     if (titleController.text.isEmpty || filePathNasheed == null || filePathNasheed!.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
//           title: Text('خطأ'),
//           content: Text('يرجى تعبئة كافة المعلومات'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('موافق'),
//             ),
//           ],
//         )),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
//         title: Text('تأكيد الارسال'),
//         content: Text('هل انتا متأكد من ارسال القصيدة'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the confirmation dialog
//             },
//             child: Text('الغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the confirmation dialog
//
//               showDialog(
//                 context: context,
//                 builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
//                   title: const Text('ارسال القصيدة'),
//                   content:  Container(
//                     width: 30, // Adjust the width as needed
//                     height: 30, // Adjust the height as needed
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 )),
//                 barrierDismissible: false, // Prevent dismissing the dialog
//               );
//
//               _sendNasheed(name); // Call the _sendNotification method
//
//
//             },
//             child: Text('ارسال'),
//           ),
//         ],
//       )),
//     );
//   }
//
//   _sendNasheed(name)async {
//     try{
//       String downloadUrl = await uploadFile(filePathNasheed! , "${name}");
//       await addDataToFirebase(downloadUrl);
//       whenOk();
//     } catch (e){
//     }
//   }
//
//   Future addDataToFirebase(String path) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//       DocumentReference documentReference = firestore.collection("Nasheed").doc();
//       await documentReference.set({
//         'id': documentReference.id,
//         'name': titleController.text,
//         'file_pdf': path,
//       });
//     print('Items added to Firestore successfully!');
//   }
//
//   Future<String> uploadFile(String filePath , String name) async {
//     File file = File(filePath);
//
//     try {
//       // Generate a unique name for the file including user ID, date, and time
//       String fileName = name;
//
//       firebase_storage.Reference storageReference =
//       firebase_storage.FirebaseStorage.instance.ref().child('nasheed').child(fileName);
//
//       await storageReference.putFile(file);
//       String downloadURL = await storageReference.getDownloadURL();
//       return downloadURL;
//     } catch (e) {
//       print('Error uploading file: $e');
//       return '';
//     }
//   }
//
//
//
//   void whenOk() {
//     showDialog(
//       context: context,
//       builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
//         title: const Text('ارسال الاشعار'),
//         content: const Text('تم ارسال الاشعار بنجاح'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close success message
//               Navigator.pop(context);
//               titleController.clear(); // Clear title text field
//               filePathNasheed = null  ;  // Clear details text field
//             },
//             child: Text('موافق'),
//           ),
//         ],
//       )),
//     );
//   }
//
//
//
//
//   Future<String?> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null) {
//       setState(() {
//         filePathNasheed = result.files.single.path;
//       });
//
//       return filePathNasheed;
//     }
//
//     return null;
//   }
//
//
//
// }
///

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasheedapp/configuration/theme.dart';

import '../commenwidget/customAppBar.dart';
import '../model/generalFireBaseList.dart';

// Content type enum

enum NasheedContentType { pdf, image, text, wasla }


class SendNasheed extends StatefulWidget {
  const SendNasheed({Key? key}) : super(key: key);

  @override
  State<SendNasheed> createState() => _SendNasheedState();
}

class _SendNasheedState extends State<SendNasheed> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  List<GeneralFireBaseList> _waslaItems = []; // selected nasheeds in order
  List<GeneralFireBaseList> _allNasheeds = []; // for picker
  bool _loadingNasheeds = false;

  @override
  void initState() {
    super.initState();
    _loadAllNasheeds();
  }

  Future<void> _loadAllNasheeds() async {
    setState(() => _loadingNasheeds = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Nasheed')
          .get();
      _allNasheeds = snapshot.docs.map((doc) {
        final data = doc.data();
        return GeneralFireBaseList(
          id: data['id'],
          name: data['name'],
          contentType: data['content_type'],
        );
      }).where((n) =>
      n.contentType != 'wasla' && // exclude other waslas
          n.name != null
      ).toList();
    } catch (e) {
      print('Error loading nasheeds: $e');
    }
    setState(() => _loadingNasheeds = false);
  }

  // PDF
  String? filePathNasheed;

  // Image
  File? imageFile;

  // Which mode is selected
  NasheedContentType _contentType = NasheedContentType.pdf;

  final ImagePicker _picker = ImagePicker();

  // ─── Pick image from camera or gallery ───────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );
      if (picked == null) return;

      // Crop after picking
      await _cropImage(picked.path);
    } catch (e) {
      _showError('خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _cropImage(String path) async {
    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'تعديل الصورة',
          toolbarColor: Theme_Information.Primary_Color,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'تعديل الصورة',
          cancelButtonTitle: 'إلغاء',
          doneButtonTitle: 'تم',
        ),
      ],
    );

    if (cropped != null) {
      setState(() {
        imageFile = File(cropped.path);
      });
    }
  }

  // ─── Show image source picker ─────────────────────────────────────
  void _showImageSourceSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text('اختر مصدر الصورة'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('الكاميرا', style: ourTextStyle(fontSize: 17)),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('معرض الصور', style: ourTextStyle(fontSize: 17)),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          if (imageFile != null)
            CupertinoActionSheetAction(
              child: Text('حذف الصورة',
                  style: ourTextStyle(fontSize: 17, color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                setState(() => imageFile = null);
              },
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('إلغاء',
              style: ourTextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.w500)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // ─── Show PDF picker ──────────────────────────────────────────────
  void _showPdfSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('تحميل ملف PDF', style: ourTextStyle(fontSize: 17)),
            onPressed: () async {
              Navigator.pop(context);
              await _pickPdf();
            },
          ),
          if (filePathNasheed != null)
            CupertinoActionSheetAction(
              child: Text('حذف الملف',
                  style: ourTextStyle(fontSize: 17, color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                setState(() => filePathNasheed = null);
              },
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('إلغاء',
              style: ourTextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.w500)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        filePathNasheed = result.files.single.path;
      });
    }
  }

  // ─── Validation ───────────────────────────────────────────────────
  // bool get _isReady {
  //   if (titleController.text.trim().isEmpty) return false;
  //   if (_contentType == NasheedContentType.pdf) return filePathNasheed != null;
  //   if (_contentType == NasheedContentType.image) return imageFile != null;
  //   if (_contentType == NasheedContentType.text) return _textController.text.trim().isNotEmpty;
  //   return false;
  // }
  bool get _isReady {
    if (titleController.text.trim().isEmpty) return false;
    if (_contentType == NasheedContentType.pdf) return filePathNasheed != null;
    if (_contentType == NasheedContentType.image) return imageFile != null;
    if (_contentType == NasheedContentType.text) return _textController.text.trim().isNotEmpty;
    if (_contentType == NasheedContentType.wasla) return _waslaItems.length >= 2;
    return false;
  }
  // ─── Upload & Save ────────────────────────────────────────────────
  Future<void> _sendNasheed() async {
    if (!_isReady) {
      _showError('يرجى تعبئة العنوان واختيار الملف');
      return;
    }

    final name = titleController.text.trim();

    // Confirm dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد الإرسال'),
          content: Text('هل أنت متأكد من إرسال القصيدة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme_Information.Primary_Color,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text('إرسال'),
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
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('جاري الرفع...'),
          content: SizedBox(
            width: 30,
            height: 30,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );

    try {
      String downloadUrl;
      String contentType;

      if (_contentType == NasheedContentType.pdf) {
        downloadUrl = await _uploadFile(filePathNasheed!, name);
        contentType = 'pdf';
      } else if (_contentType == NasheedContentType.image) {
        downloadUrl = await _uploadImage(imageFile!, name);
        contentType = 'image';
      } else if (_contentType == NasheedContentType.wasla) {
        // wasla — no upload needed
        downloadUrl = '';
        contentType = 'wasla';
      } else {
        // text — no upload needed
        downloadUrl = '';
        contentType = 'text';
      }
      await _saveToFirestore(downloadUrl, contentType);

      if (mounted) Navigator.pop(context); // close loading
      _showSuccess();
    } catch (e) {
      if (mounted) Navigator.pop(context); // close loading
      _showError('خطأ في الرفع: $e');
    }
  }

  Future<String> _uploadFile(String filePath, String name) async {
    File file = File(filePath);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('nasheed')
        .child('$name.pdf');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> _uploadImage(File image, String name) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('nasheed_images')
        .child('$name.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  // Future<void> _saveToFirestore(String url, String contentType) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final docRef = firestore.collection('Nasheed').doc();
  //   await docRef.set({
  //     'id': docRef.id,
  //     'name': titleController.text.trim(),
  //     if (contentType == 'pdf') 'file_pdf': url,
  //     if (contentType == 'image') 'image_url': url,
  //     if (contentType == 'text') 'text_content': _textController.text.trim(), // NEW
  //     'content_type': contentType,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  // }
  Future<void> _saveToFirestore(String url, String contentType) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('Nasheed').doc();
    await docRef.set({
      'id': docRef.id,
      'name': titleController.text.trim(),
      if (contentType == 'pdf') 'file_pdf': url,
      if (contentType == 'image') 'image_url': url,
      if (contentType == 'text') 'text_content': _textController.text.trim(),
      // NEW:
      if (contentType == 'wasla')
        'items': _waslaItems.asMap().entries.map((e) => {
          'order': e.key + 1,
          'nasheedId': e.value.id,
        }).toList(),
      'content_type': contentType,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تم الإرسال'),
          content: Text('تم رفع القصيدة بنجاح ✅'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
                _reset();
              },
              child: Text('موافق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _reset() {
    titleController.clear();
    _textController.clear();
    filePathNasheed = null;
    imageFile = null;
    _waslaItems.clear(); // ADD
  }
  // ─── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        // leadingWidget: SizedBox(),
        title: 'تحميل قصيدة جديدة',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ──
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان القصيدة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.title),
                  ),
                ),

                SizedBox(height: 20),

                // ── Content type toggle ──
                Text(
                  'نوع المحتوى',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                // Row(
                //   children: [
                //     Expanded(
                //       child: _typeButton(
                //         icon: Icons.picture_as_pdf,
                //         label: 'ملف PDF',
                //         selected: _contentType == NasheedContentType.pdf,
                //         color: Colors.red,
                //         onTap: () => setState(
                //                 () => _contentType = NasheedContentType.pdf),
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     Expanded(
                //       child: _typeButton(
                //         icon: Icons.image,
                //         label: 'صورة',
                //         selected: _contentType == NasheedContentType.image,
                //         color: Colors.blue,
                //         onTap: () => setState(
                //                 () => _contentType = NasheedContentType.image),
                //       ),
                //     ),
                //   ],
                // ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // SizedBox(
                    //   width: (MediaQuery.of(context).size.width - 56) / 2,
                    //   child: _typeButton(
                    //     icon: Icons.picture_as_pdf,
                    //     label: 'PDF',
                    //     selected: _contentType == NasheedContentType.pdf,
                    //     color: Colors.red,
                    //     onTap: () => setState(() => _contentType = NasheedContentType.pdf),
                    //   ),
                    // ),
                    ///
                    // SizedBox(
                    //   width: (MediaQuery.of(context).size.width - 56) / 2,
                    //   child: _typeButton(
                    //     icon: Icons.image,
                    //     label: 'صورة',
                    //     selected: _contentType == NasheedContentType.image,
                    //     color: Colors.blue,
                    //     onTap: () => setState(() => _contentType = NasheedContentType.image),
                    //   ),
                    // ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 56) / 2,
                      child: _typeButton(
                        icon: Icons.text_fields,
                        label: 'نص',
                        selected: _contentType == NasheedContentType.text,
                        color: Colors.green,
                        onTap: () => setState(() => _contentType = NasheedContentType.text),
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 56) / 2,
                      child: _typeButton(
                        icon: Icons.queue_music,
                        label: 'وصلة',
                        selected: _contentType == NasheedContentType.wasla,
                        color: Colors.purple,
                        onTap: () => setState(() => _contentType = NasheedContentType.wasla),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // ── PDF section ──
                if (_contentType == NasheedContentType.pdf) ...[
                  _sectionTitle('اختر ملف PDF', Icons.picture_as_pdf,
                      Colors.red),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showPdfSheet,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: filePathNasheed != null
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: filePathNasheed != null
                            ? Colors.green.withOpacity(0.05)
                            : Colors.grey.shade50,
                      ),
                      child: filePathNasheed == null
                          ? Column(
                        children: [
                          Icon(Icons.upload_file,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('اضغط لاختيار ملف PDF',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                          : Row(
                        children: [
                          Icon(Icons.picture_as_pdf,
                              color: Colors.red, size: 36),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filePathNasheed!.split('/').last,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('تم الاختيار ✅',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () =>
                                setState(() => filePathNasheed = null),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // ── Image section ──
                if (_contentType == NasheedContentType.image) ...[
                  _sectionTitle('اختر صورة', Icons.image, Colors.blue),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: imageFile != null
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: imageFile == null
                          ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 56, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('الكاميرا أو معرض الصور',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              'ستتمكن من اقتصاص الصورة بعد الاختيار',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      )
                          : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              imageFile!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Edit overlay
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Row(
                              children: [
                                _overlayBtn(
                                  icon: Icons.crop,
                                  label: 'اقتصاص',
                                  color: Colors.blue,
                                  onTap: () =>
                                      _cropImage(imageFile!.path),
                                ),
                                SizedBox(width: 8),
                                _overlayBtn(
                                  icon: Icons.refresh,
                                  label: 'تغيير',
                                  color: Colors.orange,
                                  onTap: _showImageSourceSheet,
                                ),
                                SizedBox(width: 8),
                                _overlayBtn(
                                  icon: Icons.delete,
                                  label: 'حذف',
                                  color: Colors.red,
                                  onTap: () =>
                                      setState(() => imageFile = null),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],


                // ── Text section ──
                if (_contentType == NasheedContentType.text) ...[
                  _sectionTitle('اكتب أو الصق نص القصيدة', Icons.text_fields, Colors.green),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _textController.text.isNotEmpty
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: 15,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        height: 2.0,
                        fontFamily: 'calibri',
                      ),
                      decoration: InputDecoration(
                        hintText: 'الصق نص القصيدة هنا...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 6),
                  // Character counter
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_textController.text.length} حرف',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ),
                ],


                // ── Wasla section ──
                if (_contentType == NasheedContentType.wasla) ...[
                  _sectionTitle('قصائد الوصلة', Icons.queue_music, Colors.purple),
                  SizedBox(height: 10),

                  // Add nasheed button
                  GestureDetector(
                    onTap: _showNasheedPicker,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade200, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.purple.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle, color: Colors.purple),
                          SizedBox(width: 8),
                          Text(
                            'إضافة قصيدة للوصلة',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Reorderable list of selected nasheeds
                  if (_waslaItems.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _waslaItems.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex--;
                            final item = _waslaItems.removeAt(oldIndex);
                            _waslaItems.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final nasheed = _waslaItems[index];
                          final contentType = nasheed.contentType ?? 'pdf';

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

                          return Container(
                            key: ValueKey(nasheed.id),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              title: Text(
                                nasheed.name ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(typeIcon, color: typeColor, size: 18),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() => _waslaItems.removeAt(index));
                                    },
                                  ),
                                  Icon(Icons.drag_handle, color: Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '${_waslaItems.length} قصائد • اسحب للترتيب',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ],

                SizedBox(height: 32),

                // ── Send button ──
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text(
                      'إرسال القصيدة',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isReady
                          ? Theme_Information.Primary_Color
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isReady ? _sendNasheed : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNasheedPicker() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Filter out already selected nasheeds
          final alreadySelectedIds = _waslaItems.map((n) => n.id).toSet();
          final available = _allNasheeds.where((n) =>
          !alreadySelectedIds.contains(n.id) &&
              (searchQuery.isEmpty ||
                  (n.name ?? '').contains(searchQuery))
          ).toList();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) => Column(
                children: [
                  // Handle
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'اختر قصيدة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Search
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'بحث...',
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                      onChanged: (val) {
                        setModalState(() => searchQuery = val);
                      },
                    ),
                  ),

                  SizedBox(height: 8),

                  // List
                  Expanded(
                    child: _loadingNasheeds
                        ? Center(child: CircularProgressIndicator())
                        : available.isEmpty
                        ? Center(child: Text('لا توجد قصائد'))
                        : ListView.builder(
                      controller: scrollController,
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final nasheed = available[index];
                        final contentType = nasheed.contentType ?? 'pdf';

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

                        return ListTile(
                          leading: Icon(typeIcon, color: typeColor),
                          title: Text(nasheed.name ?? ''),
                          onTap: () {
                            setState(() => _waslaItems.add(nasheed));
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Small helpers ────────────────────────────────────────────────
  Widget _typeButton({
    required IconData icon,
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : Colors.grey, size: 30),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : Colors.grey,
                fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700])),
      ],
    );
  }

  Widget _overlayBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(label,
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
