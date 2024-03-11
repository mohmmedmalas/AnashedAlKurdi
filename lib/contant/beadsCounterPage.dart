import 'dart:math';

import 'package:bookapp/commenwidget/customAppBar.dart';
import 'package:bookapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // For vibration

class BeadsCounter extends StatefulWidget {
  @override
  _BeadsCounterState createState() => _BeadsCounterState();
}

///
class _BeadsCounterState extends State<BeadsCounter> {
  int count = 0;
  ScrollController _scrollController = ScrollController();
  double borderWidth = 2.0; // Initial border width

  void incrementCount() {
    setState(() {
      count++;
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    if (count % 100 == 0) {
      // Trigger vibration when the counter reaches 100
      _vibrate();
    }
    // Update the border width based on the counter
    });
  }
  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 200);
    }
  }


  void resetCount() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "المسبحة الإلكترونية"),
      body: GestureDetector(
        onTap: incrementCount,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: NetworkImage('https://media.istockphoto.com/id/104297712/photo/silhouette-of-nabawi-mosque-minarets-al-madinah-arabia.jpg'),
              image: AssetImage('assets/images/back2.jpeg'),
              // image: AssetImage('assets/images/back2.png'),
              // image: AssetImage('assets/images/back1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Expanded(
              //   child: Stack(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(30.0),
              //         child: Align(alignment: Alignment.centerRight, child: Text(count.toString() , style: ourTextStyle())),
              //       ),
              //       Center(child: Container(height: MediaQuery.of(context).size.height , width: 5 ,color: Theme_Information.Color_1)),
              //       ListView.builder(
              //         controller: _scrollController,
              //
              //         physics: NeverScrollableScrollPhysics(), // Prevent scrolling
              //         itemCount: count,
              //         itemBuilder: (context, index) {
              //           return AnimatedContainer(
              //             curve: Curves.easeInOut,
              //             duration: Duration(milliseconds: 300),
              //             margin: EdgeInsets.symmetric(vertical: 10),
              //             width: 20,
              //             height: 20,
              //             decoration: BoxDecoration(
              //               color: Theme_Information.Primary_Color,
              //               shape: BoxShape.circle,
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              Expanded(
                child: CustomPaint(
                  foregroundPainter: CircleProgressPainter(
                    counter: count,
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
                        '$count',
                        // style: ourTextStyle(fontSize: 50 , color: Theme_Information.Primary_Color),
                        style: ourTextStyle(fontSize: 50 , color: Theme_Information.Color_1),
                      ),
                    ),
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
                    MaterialButton(
                      color: Theme_Information.Color_1,
                      minWidth: size_W(120),
                      onPressed: () {
                        resetCount();
                      },
                      child: Image.asset("assets/images/reset.jpeg" , width: size_W(50),)
                      // Text(
                      //   'تصفير',
                      //   style: ourTextStyle(),
                      // ),
                    ),
                    SizedBox(width: 20),
                    MaterialButton(
                      color: Theme_Information.Primary_Color,
                      minWidth: size_W(120),
                      onPressed: () {
                        incrementCount();
                      },
                      child: Image.asset("assets/images/plus.png" , width: size_W(18),color: Theme_Information.Color_1)

                // Text(
                      //   '+',
                      //   style: ourTextStyle(color: Theme_Information.Color_1),
                      // ),
                    ),



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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