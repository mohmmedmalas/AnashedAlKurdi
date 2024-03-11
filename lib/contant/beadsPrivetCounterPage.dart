import 'dart:math';

import 'package:bookapp/commenwidget/customAppBar.dart';
import 'package:bookapp/configuration/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';
import '../model/dhikrItemsModel.dart'; // For vibration

class BeadsPrivetCounter extends StatefulWidget {
  final String? title;
  final String? description;
  final String? dhikr;
  final String? image;
  final String? id;
  const BeadsPrivetCounter({required this.title,required this.image,required this.description , required this.dhikr , required this.id});

  @override
  _BeadsPrivetCounterState createState() => _BeadsPrivetCounterState();
}

///
class _BeadsPrivetCounterState extends State<BeadsPrivetCounter> {
  // DhikrItems? data  ;
  // int count = 0;
  ScrollController _scrollController = ScrollController();
  double borderWidth = 2.0; // Initial border width

  void incrementCount() {
    setState(() {
      countPrivet++;
    if (countPrivet % 100 == 0) {
      _vibrate();
    }
    });
    increaseCount("${widget.id}" , 1);
  }
  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 200);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(const Duration(milliseconds: 3), () async {
    //   data = await getDhikrStream("${widget.id}");
    //   setState(() {});
    // });
    // // getDhikrStream
    // data
  }

  // Future<Stream<DhikrItems?>> getDhikrStream(String documentId) async {
  //   try {
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //
  //     if (connectivityResult == ConnectivityResult.none) {
  //       throw Exception("No internet connection");
  //     }
  //
  //     return FirebaseFirestore.instance
  //         .collection('dhikr_bars')
  //         .doc(documentId)
  //         .snapshots()
  //         .map((docSnapshot) {
  //       if (docSnapshot.exists) {
  //         // Parse the document data into a DhikrItems object
  //         return DhikrItems.fromJson(docSnapshot.data() as Map<String, dynamic>);
  //       } else {
  //         // Document does not exist, return null
  //         return null;
  //       }
  //     });
  //   } catch (e) {
  //     print('Error fetching data from Firestore: $e');
  //     return Stream.empty();
  //   }
  // }

  Future<void> increaseCount(String dhikrItemId , int count) async {
    try {
      await FirebaseFirestore.instance.collection('dhikr_bars').doc(dhikrItemId).update({
        'count': FieldValue.increment(count),
      });
    } catch (e) {
      print('Error incrementing count: $e');
    }
  }

  void _showNumberInputDialog(BuildContext context) {
    int enteredNumber = 0; // Initialize this to the default value if needed.

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Adjust the value for more or less rounded corners.
            ),
            title: Text("ادخل العدد الكلي الذي تم ذكره سابقاَ"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "ادخل العدد الكامل",
                  ),
                  onChanged: (value) {
                    // Parse the entered text to an integer or validate it as needed.
                    enteredNumber = int.tryParse(value) ?? 0;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                      "يرجو العلم أن هذه الأرقام سيتم اضافتها مباشرة الى المجموع الكلي ولا يمكن التراجع عن هذا الإجراء"
                  , textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                )
              ],
            ),
            actions: <Widget>[

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Change the color as needed.
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog when "Cancel" is pressed.
                },
                child: Text("رجوع" , style: ourTextStyle(color: Theme_Information.Color_1),),
              ),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Change the color as needed.
                ),
                onPressed: () {
                  // Add your code to handle the "Add" button click here.
                  print("Entered number: $enteredNumber");
                  increaseCount("${widget.id}" , enteredNumber);
                  countPrivet =    countPrivet + enteredNumber ;
                  setState(() {});
                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text("اضافة", style: ourTextStyle(color: Theme_Information.Color_1),),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "المسبحة الإلكترونية"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dhikr_bars').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError || snapshot.data == null) {
              return Text('');
            } else {
              // Access the data from the QuerySnapshot
              List<DocumentSnapshot> documents = snapshot.data!.docs;

              // Process the documents as needed
              List<DhikrItems> dhikrItemsList = documents.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return DhikrItems.fromJson(data);
              }).toList();
              return GestureDetector(
                onTap: incrementCount,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('${widget.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (dhikrItemsList.isNotEmpty && dhikrItemsList.first.count != null)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "العداد الكلي ${formatNumber(dhikrItemsList.first.count??0)}",
                            style:
                                ourTextStyle(color: Theme_Information.Color_1 , fontSize: 20),
                          ),
                        ),


                      if (dhikrItemsList.isNotEmpty && dhikrItemsList.first.dhikr != null)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "${dhikrItemsList.first.dhikr}",
                            textAlign: TextAlign.center,
                            style:
                            ourTextStyle(color: Theme_Information.Color_1 , fontSize: 30 , fontWeight: FontWeight.bold),
                          ),
                        ),



                      Expanded(
                        child: CustomPaint(
                          foregroundPainter: CircleProgressPainter(
                            counter: countPrivet,
                            total: 100,
                          ),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme_Information.Color_1!,
                                // color: Theme_Information.Color_7!,
                                width: 4, // Use the dynamically updated width
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$countPrivet',
                                // style: ourTextStyle(fontSize: 50 , color: Theme_Information.Primary_Color),
                                style: ourTextStyle(
                                    fontSize: 50,
                                    color: Theme_Information.Color_1),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (dhikrItemsList.isNotEmpty && dhikrItemsList.first.description != null)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "${dhikrItemsList.first.description}",
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              style:
                              ourTextStyle(color: Theme_Information.Color_1 , fontSize: 18),
                            ),
                          ),
                        ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                  color: Theme_Information.Primary_Color,
                                  minWidth: size_W(120),
                                  onPressed: () {
                                    _showNumberInputDialog(context);
                                  },
                                  child: Text("أضافة المشاركة يدوياً" , style: ourTextStyle(color: Theme_Information.Color_1),)

                                // Text(
                                //   '+',
                                //   style: ourTextStyle(color: Theme_Information.Color_1),
                                // ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                  color: Theme_Information.Primary_Color,
                                  minWidth: size_W(120),
                                  onPressed: () {
                                    incrementCount();
                                  },
                                  child: Image.asset("assets/images/plus.png",
                                      width: size_W(18),
                                      color: Theme_Information.Color_1)

                                  // Text(
                                  //   '+',
                                  //   style: ourTextStyle(color: Theme_Information.Color_1),
                                  // ),
                                  ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
  String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else {
      String formattedNumber = number.toString();
      String result = '';
      int count = 0;

      for (int i = formattedNumber.length - 1; i >= 0; i--) {
        result = formattedNumber[i] + result;
        count++;

        if (count == 3 && i > 0) {
          result = '.' + result;
          count = 0;
        }
      }

      return result;
    }
  }
}


class CircleProgressPainter extends CustomPainter {
  final int counter;
  final int total;

  CircleProgressPainter({required this.counter, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Theme_Information.Primary_Color // Color for the progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final double progress = counter % 100 / total;
    // final double progress = counter / total;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}