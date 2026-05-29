import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasheedapp/configuration/theme.dart';

import '../commenwidget/customAppBar.dart';

class SendNasheed extends StatefulWidget {
  const SendNasheed({Key? key}) : super(key: key);

  @override
  State<SendNasheed> createState() => _SendNasheedState();
}

class _SendNasheedState extends State<SendNasheed> {

  TextEditingController titleController = TextEditingController();
  String? filePathNasheed;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          leadingWidget: SizedBox(),
          title: "تحميل قصيدة جديدة",
          context: context
        // title: "Home Page",
        // title: Text(titles[_currentIndex] , style: ourTextStyle(color: Theme_Information.Color_1, fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'العنوان'),
                ),
                SizedBox(height: 16),

                Column(
                  children: [
                    MaterialButton(
                      minWidth: 200,
                     color: Theme_Information.Primary_Color,
                      // controller: TextEditingController(),
                      child: Text("اختيار ملف القصيدة" , style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        // _showActionSheet(context);

                        final act = CupertinoActionSheet(
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
                                child: CupertinoActionSheetAction(
                                  child: Text('تحميل' , style: ourTextStyle(fontSize: 17),),
                                  onPressed: () async {
                                    String? path = await pickFile();
                                    if (path != null) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                              if(filePathNasheed != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
                                  child: CupertinoActionSheetAction(
                                    child: Text('حذف الملف' , style: ourTextStyle(fontSize: 17),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        filePathNasheed = null ;
                                      });
                                    },
                                  ),
                                )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text('إلغاء', style: ourTextStyle(fontSize: 17 ,color: Colors.red , fontWeight: FontWeight.w500),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ));
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => act);



                      },
                    ),
                    if(filePathNasheed != null)
                      Padding(
                        padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("${filePathNasheed!.split("/").last}" , style: TextStyle(),),
                              GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
                                        title: Text('تأكيد'),
                                        content: Text('هل تريد حذف الملف'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('رجوع'),
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('موافق'),
                                          ),
                                        ],
                                      )),
                                    );

                                    // MyConfirmationDialog().showConfirmationDialog(
                                    //   context: context,
                                    //   title: "Confirmation",
                                    //   body: "Do you want to remove your CV?",
                                    //   saveBtn: "Remove",
                                    //   onSave: (){
                                    //     setState(() {
                                    //       filePathNasheed = null ;
                                    //     });
                                    //   },
                                    // );
                                  },
                                  child: Icon(Icons.remove_circle_outline_sharp))
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 16),


                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Theme_Information.Primary_Color)
                  ),
                  onPressed: () {
                    // _sendNotification();

                    if(filePathNasheed != null)
                    _showConfirmationDialog("${filePathNasheed!.split("/").last}");

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ارسال القصيدة' , style: ourTextStyle(color: Theme_Information.Color_1),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(name) {
    if (titleController.text.isEmpty || filePathNasheed == null || filePathNasheed!.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
          title: Text('خطأ'),
          content: Text('يرجى تعبئة كافة المعلومات'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('موافق'),
            ),
          ],
        )),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
        title: Text('تأكيد الارسال'),
        content: Text('هل انتا متأكد من ارسال القصيدة'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: Text('الغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog

              showDialog(
                context: context,
                builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
                  title: const Text('ارسال القصيدة'),
                  content:  Container(
                    width: 30, // Adjust the width as needed
                    height: 30, // Adjust the height as needed
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )),
                barrierDismissible: false, // Prevent dismissing the dialog
              );

              _sendNasheed(name); // Call the _sendNotification method


            },
            child: Text('ارسال'),
          ),
        ],
      )),
    );
  }

  _sendNasheed(name)async {
    try{
      String downloadUrl = await uploadFile(filePathNasheed! , "${name}");
      await addDataToFirebase(downloadUrl);
      whenOk();
    } catch (e){
    }
  }

  Future addDataToFirebase(String path) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference documentReference = firestore.collection("Nasheed").doc();
      await documentReference.set({
        'id': documentReference.id,
        'name': titleController.text,
        'file_pdf': path,
      });
    print('Items added to Firestore successfully!');
  }

  Future<String> uploadFile(String filePath , String name) async {
    File file = File(filePath);

    try {
      // Generate a unique name for the file including user ID, date, and time
      String fileName = name;

      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('nasheed').child(fileName);

      await storageReference.putFile(file);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }



  void whenOk() {
    showDialog(
      context: context,
      builder: (_) => Directionality(textDirection: TextDirection.rtl,child: AlertDialog(
        title: const Text('ارسال الاشعار'),
        content: const Text('تم ارسال الاشعار بنجاح'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close success message
              Navigator.pop(context);
              titleController.clear(); // Clear title text field
              filePathNasheed = null  ;  // Clear details text field
            },
            child: Text('موافق'),
          ),
        ],
      )),
    );
  }




  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePathNasheed = result.files.single.path;
      });

      return filePathNasheed;
    }

    return null;
  }



}
