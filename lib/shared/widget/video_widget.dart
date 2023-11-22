import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final _defaultUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;

  VideoWidget({Key? key, this.videoUrl}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  Future<void> generateThumbnail() async {
    thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl ?? _defaultUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return thumbnailPath == null
        ? Center(child: CircularProgressIndicator())
        : InkWell(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => _VideoPlayPage(
                        videoUrl: widget.videoUrl ?? _defaultUrl),
                  ));
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.file(File(thumbnailPath!)),
                    Icon(Icons.play_circle_outline,
                        size: 64, color: Colors.white),
                  ],
                ),
              ),
            ),
          );
  }
}

class _VideoPlayPage extends StatefulWidget {
  final String videoUrl;

  _VideoPlayPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<_VideoPlayPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: true,
      videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          videoPlayerOptions: VideoPlayerOptions()),
    );

    // flickManager.flickControlManager?.enterFullscreen();

    // flickManager.flickVideoManager?.videoPlayerController?.addListener(() {
    //   if (flickManager.flickVideoManager?.isPlaying == true) {
    //     flickManager.flickControlManager?.enterFullscreen();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: FlickVideoPlayer(flickManager: flickManager),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
}
