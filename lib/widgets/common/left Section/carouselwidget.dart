// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCarouselCustom extends StatefulWidget {
  final List<String> mediaUrls;
  const VideoCarouselCustom({required this.mediaUrls, super.key});
  @override
  _VideoCarouselCustomState createState() => _VideoCarouselCustomState();
}

class _VideoCarouselCustomState extends State<VideoCarouselCustom> {
  late PageController _pageController;
  late List<VideoPlayerController?> _videoControllers;
  int _currentIndex = 0;
  Timer? _imageTimer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initializeMediaControllers();
    if (widget.mediaUrls.isNotEmpty) {
      _playCurrentMedia(_currentIndex);
    }
  }

  //
  @override
  void didUpdateWidget(covariant VideoCarouselCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaUrls != widget.mediaUrls) {
      _replaceMedia(widget.mediaUrls);
    }
  }

  void _replaceMedia(List<String> newUrls) {
    _imageTimer?.cancel();
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    setState(() {
      try {
        _isLoading = true;
        _videoControllers.clear();
        _currentIndex = 0;
        _initializeMediaControllers();
        _isLoading = false;
        _playCurrentMedia(_currentIndex);
      } catch (e) {
        log("Error occured in initializing videos agian:" + e.toString());
      } finally {
        _isLoading = false;
      }
    });
  }

  void _initializeMediaControllers() {
    _videoControllers = widget.mediaUrls.map((url) {
      if (_isVideo(url)) {
        return VideoPlayerController.file(File(url))
          ..initialize().then((_) {
            setState(() {});
          });
      }
      return null;
    }).toList();
  }

  bool _isVideo(String url) {
    return url.contains(".mp4") || url.contains(".mov");
  }

  void _playCurrentMedia(int index) {
    if (_isVideo(widget.mediaUrls[index])) {
      _playCurrentVideo(index);
    } else {
      _showImageForDuration(index);
    }
  }

  void _playCurrentVideo(int index) {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (_videoControllers[i] != null) {
        if (i == index) {
          if (!_videoControllers[i]!.value.isPlaying) {
            _videoControllers[i]?.play();
          }
          _videoControllers[i]?.addListener(_videoListener);
        } else {
          _videoControllers[i]?.pause();
          _videoControllers[i]?.seekTo(Duration.zero);
          _videoControllers[i]?.removeListener(_videoListener);
        }
      }
    }
  }

  void _showImageForDuration(int index) {
    _imageTimer?.cancel();
    _imageTimer = Timer(const Duration(seconds: 5), () {
      _moveToNextMedia();
    });
  }

  void _moveToNextMedia() {
    setState(() {
      if (_currentIndex < widget.mediaUrls.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        if (_videoControllers[_currentIndex]?.value.isInitialized ?? true) {
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
          _playCurrentMedia(_currentIndex);
        }
      }
    });
  }

  void _videoListener() {
    final currentController = _videoControllers[_currentIndex];
    if (currentController != null &&
        currentController.value.isInitialized &&
        currentController.value.position >= currentController.value.duration) {
      _moveToNextMedia();
    }
  }

  bool _isLoading = false; // To track if new media is being loaded
  @override
  void dispose() {
    _pageController.dispose();
    _imageTimer?.cancel();
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: _isLoading // Check if still loading
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : PageView.builder(
                controller: _pageController,
                itemCount: widget.mediaUrls.length,
                itemBuilder: (context, index) {
                  final mediaUrl = widget.mediaUrls[index];
                  if (_isVideo(mediaUrl)) {
                    final videoController = _videoControllers[index];
                    return videoController?.value.isInitialized ?? false
                        ? AspectRatio(
                            aspectRatio: videoController!.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                                Text("Getting Videos")
                              ],
                            ),
                          );
                  } else {
                    return Image.file(
                      File(mediaUrl),
                      fit: BoxFit.cover,
                    );
                  }
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _playCurrentMedia(index);
                },
              ),
      ),
    );
  }
}
