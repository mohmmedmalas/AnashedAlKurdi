import 'package:flutter/material.dart';

import '../configuration/theme.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imagePaths;
  ImageSlider({required this.imagePaths});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    // swiping right
                    if (_currentPageIndex == 0) {
                      // if on first image, loop back to last image
                      setState(() {
                        _currentPageIndex = widget.imagePaths.length - 1;
                      });
                    } else {
                      setState(() {
                        _currentPageIndex -= 1;
                      });
                    }
                  } else if (details.delta.dx < 0) {
                    // swiping left
                    if (_currentPageIndex == widget.imagePaths.length - 1) {
                      // if on last image, loop back to first image
                      setState(() {
                        _currentPageIndex = 0;
                      });
                    } else {
                      setState(() {
                        _currentPageIndex += 1;
                      });
                    }
                  }
                },
                child: PageView.builder(
                  controller: PageController(initialPage: _currentPageIndex),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemCount: widget.imagePaths.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: size_H(210),
                      child: Image.asset(
                        widget.imagePaths[index],
                        width: size_W(350),
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),


              // Positioned.fill(
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Padding(
              //       padding: const EdgeInsets.only(bottom: 15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: _buildPageIndicator(),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        // SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: _buildPageIndicator(),
        // ),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < widget.imagePaths.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPageIndex == i
                ? Theme_Information.Primary_Color
                : Colors.grey[400],
          ),
        ),
      );
    }

    return indicators;
  }
}