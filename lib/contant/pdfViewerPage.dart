import 'package:bookapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:audioplayers/audioplayers.dart';

import '../commenwidget/customAppBar.dart';

class PdfViewerPage extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfViewerPage({required this.assetPath,required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  AudioPlayer? _player;


  @override
  void initState() {
    super.initState();




  // Set preferred orientations here (portrait and landscape)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  @override
  void dispose() {
    _player?.dispose();
    // Remove the preferred orientations when the page is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("fsd ${widget.title}");
    return Scaffold(
      appBar: myAppBar(
        title: widget.title,
        context: context
      ),
      /// voice
      // bottomNavigationBar: widget.title == "حزب البحر" ?
      // Container(
      //   color: Theme_Information.Primary_Color,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //
      //       // Play Button
      //       MaterialButton(
      //         onPressed: () {
      //           // if (_player = PlayerState.PLAYING) {
      //           //   playMusic();
      //           // }
      //           if (_player?.state== null) {
      //             playMusic();
      //           }else if (_player?.state.name == "stopped") {
      //             playMusic();
      //           }else if (_player?.state.name == "playing") {
      //             pauseMusic();
      //           } else if (_player?.state.name == "paused") {
      //             resumeMusic();
      //           }
      //
      //         },
      //         child: Icon(getIcon() , color: Theme_Information.Color_1),
      //       ),
      //
      //       MaterialButton(
      //         onPressed: () async {
      //           // await _player?.stop();
      //           print("_resumeMusic_");
      //           print("_player?.state ${_player?.state.name}");
      //           if (_player?.state.name == "playing") {
      //           // if (_player?.state.name == PlayerState.PLAYING) {
      //             stopMusic();
      //             // resumeMusic();
      //           }
      //         },
      //         child: Icon(Icons.stop , color: Theme_Information.Color_1),
      //       ),
      //
      //       Text(":الملف الصوتي" , style: ourTextStyle(color: Theme_Information.Color_1),),
      //     ],
      //   ),
      // ) :
      // SizedBox(),
      ///
      body: pdfLocal(),
      // body: buildSfPdfViewer(),
    );
  }
  Widget buildSfPdfViewer(){
    return SfPdfViewer.asset(widget.assetPath , );
  }

  IconData getIcon() {
    print("eee ${_player?.state.name}");
    if(_player?.state == null){
      return Icons.play_arrow ;
    }
     else if(_player?.state.name == "paused"){
      return Icons.play_arrow ;
    }  else {
      return Icons.pause ;
    }
  }

  // Widget pdf(){
  Widget pdfLocal(){
    return  const PDF(
      // swipeHorizontal: true,
      autoSpacing: false,
      enableSwipe: true,
      pageFling: false,
      pageSnap: false,
    ).fromAsset(widget.assetPath);
  }


  void playMusic() async {
    _player?.dispose();
    final player = _player = AudioPlayer();
   await player.play(AssetSource('audioFiles/bahr.m4a'));
    setState(() {});
    // if (result == 1) {
    //   // success
    //   print("Music is playing.");
    // } else {
    //   // failure
    //   print("Error playing music.");
    // }
  }
  Future<void> pauseMusic() async {
    await _player?.pause();
    setState(() {});
  }

  Future<void> stopMusic() async {
    await _player?.stop();
    setState(() {});
  }
  Future<void> resumeMusic() async {
    await _player?.resume();
    setState(() {});
    // await _player?.pause();
  }
}
enum PlayerState {
  PLAYING,
  STOPPED,
  PAUSED,
}