import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A widget that displays a video from a file at the given [filePath].
///
/// The video is played automatically when initialized.
class VideoPlayerWidget extends StatefulWidget {
  /// The file path of the video to be played.
  final String filePath;

  /// Creates a [VideoPlayerWidget] with the given [filePath].
  const VideoPlayerWidget({super.key, required this.filePath});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

// ignore: public_member_api_docs
class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  /// Initializes the state of the widget, setting up the video player and
  /// playing the video at the file path provided in [widget.filePath].
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  /// Returns a widget that displays a video from a file at the given
  /// [widget.filePath].
  ///
  /// The widget is an [AspectRatio] of the video, with a
  /// [CircularProgressIndicator] displayed until the video is initialized.
  ///
  /// The video is played automatically when initialized.
  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }

  /// Disposes the video player controller and the state of the widget.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
