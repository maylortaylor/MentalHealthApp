import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:video_player/video_player.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VideoScreen extends StatefulWidget {
  // const VideoScreen({Key? key}) : super(key: key);
  const VideoScreen({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  Future<void> init() async {
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text(widget.videoUrl),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: TextStyle(
          color: Colors.white
        ),
      ),
      body: Column(
        children:[
          Flexible(
            child: Row(
              children: [
                Container(
                  child: _buildBodySection(context),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
  
  Widget _buildBodySection(BuildContext context) {
    return _buildItem(context);
  }

  Widget _buildItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Center(
                      child: VimeoVideoPlayer(
                        vimeoPlayerModel: VimeoPlayerModel(
                          url: widget.videoUrl,
                          deviceOrientation: DeviceOrientation.portraitUp,
                          systemUiOverlay: const [
                            SystemUiOverlay.top,
                            SystemUiOverlay.bottom,
                            ],
                        ),
                      )
                    )
                  ]
                ),
              ),
            ),
            // Flexible(
            //   flex: 3,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            //     child: Row(
            //       children: [
            //         Container(
            //           child: Expanded(
            //             child: Container()
            //           )
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

}

