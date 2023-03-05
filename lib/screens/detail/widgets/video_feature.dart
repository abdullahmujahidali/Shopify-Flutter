import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../common/config.dart' show kLoadingWidget;
import '../../../common/constants.dart';

class FeatureVideoPlayer extends StatefulWidget {
  final String url;
  final bool? autoPlay;
  final double? aspectRatio;
  final bool enableTimeIndicator;
  final bool tapToPlayPause;
  final bool holdToPlayPause;

  const FeatureVideoPlayer(
    this.url, {
    Key? key,
    this.autoPlay,
    this.aspectRatio,
    this.enableTimeIndicator = false,
    this.tapToPlayPause = true,
    this.holdToPlayPause = false,
  }) : super(key: key);

  @override
  State<FeatureVideoPlayer> createState() => _FeatureVideoPlayerState();
}

class _FeatureVideoPlayerState extends State<FeatureVideoPlayer> {
  VideoPlayerController? _controller;
  bool initialized = false;
  double? aspectRatio;
  bool isYoutube = false;

  YoutubePlayerController? _youtubeController;

  Timer? _timer;

  void _cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _cancelTimer();

    _timer = Timer(const Duration(milliseconds: 100), () async {
      if (_controller != null && _controller!.value.isPlaying) {
        await _controller!.pause();
      }
      if (_youtubeController != null &&
          (await _youtubeController?.playerState) == PlayerState.playing) {
        await _youtubeController?.pauseVideo();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    /// Enable below to use the youtube video
    /// Compatible with: https://pub.dev/packages/youtube_player_iframe
    if (!isDesktop &&
        (widget.url.contains('youtu.be') || widget.url.contains('youtube'))) {
      isYoutube = true;
      final videoId = YoutubePlayerController.convertUrlToId(widget.url)!;
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: false,
          strictRelatedVideos: true,
          loop: true,
          showFullscreenButton: false,
          showVideoAnnotations: false,
          enableCaption: false,
        ),
      );
      return;
    }

    _controller = VideoPlayerController.network(widget.url)
      ..initialize()
      ..setLooping(true).then(
        (_) {
          if (mounted) {
            setState(() {
              initialized = true;
              aspectRatio =
                  widget.aspectRatio ?? _controller?.value.aspectRatio;
            });

            if (widget.autoPlay == true) _controller?.play();
          }
        },
      );
    _controller?.addListener(_listener);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (!isYoutube) {
      _controller?.removeListener(_listener);
      _controller?.dispose();
    } else {
      _youtubeController?.close();
    }
    _cancelTimer();
    super.dispose();
  }

  Widget playPauseButton(bool playStatus) {
    return playStatus
        ? const SizedBox.shrink()
        : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (!isYoutube) {
      if (initialized && _controller != null) {
        return Center(
          child: AspectRatio(
            aspectRatio: aspectRatio ?? _controller!.value.aspectRatio,
            child: Listener(
              onPointerDown: (_) {
                if (widget.holdToPlayPause) {
                  _startTimer();
                }
              },
              onPointerUp: (_) {
                if (widget.holdToPlayPause) {
                  _cancelTimer();
                  _controller!.play();
                }
                if (widget.tapToPlayPause) {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                }
              },
              child: Stack(
                children: [
                  VideoPlayer(_controller!),
                  if (widget.tapToPlayPause)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 50),
                      reverseDuration: const Duration(milliseconds: 200),
                      child: playPauseButton(_controller!.value.isPlaying),
                    ),
                  if (widget.enableTimeIndicator)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VideoProgressIndicator(_controller!,
                          allowScrubbing: true),
                    ),
                ],
              ),
            ),
          ),
        );
      }

      return Container(
        height: MediaQuery.of(context).size.width * 0.8,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: kLoadingWidget(context),
        ),
      );
    }

    if (isDesktop) {
      /// Desktop not support webview for YouTube iframe.
      return const SizedBox();
    }

    /// Enable below to use the youtube video
    /// Compatible with: https://pub.dev/packages/youtube_player_iframe
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          _youtubeController?.pauseVideo();
        }
      },
      key: ValueKey('youtube_player_iframe-${widget.url}'),
      child: Listener(
        onPointerDown: (_) {
          if (widget.holdToPlayPause) {
            _startTimer();
          }
        },
        onPointerUp: (_) async {
          if (widget.holdToPlayPause) {
            _cancelTimer();
            await _youtubeController?.playVideo();
          }
          if (widget.tapToPlayPause) {
            if ((await _youtubeController?.playerState) ==
                PlayerState.playing) {
              await _youtubeController?.pauseVideo();
            } else {
              await _youtubeController?.playVideo();
            }
          }
        },
        child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: YoutubePlayer(
                controller: _youtubeController,
                aspectRatio: aspectRatio ?? 16 / 9,
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width,
            child: YoutubePlayerControllerProvider(
              controller: _youtubeController!,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: YoutubePlayer(
                      controller: _youtubeController,
                      aspectRatio: aspectRatio ?? 16 / 9,
                    ),
                  ),
                  if (widget.tapToPlayPause)
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        builder: (context, value) {
                          return playPauseButton(
                              value.playerState == PlayerState.playing);
                        },
                      ),
                    ),
                  if (widget.enableTimeIndicator)
                    const Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: VideoPositionSeeker(),
                    )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return StreamBuilder<Duration>(
      stream: context.ytController.getCurrentPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final position = snapshot.data?.inSeconds ?? 0;
        final duration = context.ytController.metadata.duration.inSeconds;

        value = position == 0 || duration == 0 ? 0 : position / duration;

        return StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              activeColor: const Color.fromRGBO(255, 0, 0, 0.7),
              value: value,
              onChanged: (positionFraction) {
                value = positionFraction;
                setState(() {});

                context.ytController.seekTo(
                  seconds: (value * duration).toDouble(),
                  allowSeekAhead: true,
                );
              },
              min: 0,
              max: 1,
            );
          },
        );
      },
    );
  }
}
