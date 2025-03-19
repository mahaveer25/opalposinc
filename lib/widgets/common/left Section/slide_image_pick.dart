import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalsystem/main.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/utils.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class SlideImagePick extends StatefulWidget {
  const SlideImagePick({super.key});

  @override
  State<SlideImagePick> createState() => _SlideImagePickState();
}

class _SlideImagePickState extends State<SlideImagePick> {
  File? _mediaFile;
  List<String> _mediaPaths = [];
  List<String> _frontScreenMedia = [];
  List<String> _mediaOrder = [];

  int count = 0;

  bool isVideo = false;
  late VideoPlayerController _videoController;
  VideoPlayerController? _videoPlayerControllerForLoadingVide;

  Future<void> loadSavedContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mediaPaths = prefs.getStringList('slideImages') ?? [];
      _frontScreenMedia = prefs.getStringList('frontScreen') ?? [];
      // _videoDuration = prefs.getStringList('videoDuration') ?? [];
      _mediaOrder = prefs.getStringList('mediaOrder') ?? [];
      if (_mediaOrder.length != _frontScreenMedia.length) {
        reset();
      }
      updateMax();
    });
  }

  Future<void> saveMediaPaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('slideImages', _mediaPaths);
    // await prefs.setStringList('videoDuration', _videoDuration);
    await prefs.setStringList('frontScreen', _frontScreenMedia);
    await prefs.setStringList(
        'mediaOrder', _mediaOrder.map((e) => e.toString()).toList());

    displayManager.transferDataToPresentation(
        {'type': 'slideImages', 'slideImages': _mediaPaths});
    // displayManager.transferDataToPresentation({'type': 'videoDuration', 'videoDuration': _videoDuration});
    displayManager.transferDataToPresentation(
        {'type': 'mediaOrder', 'mediaOrder': _mediaOrder});
    _mediaOrder = prefs.getStringList('mediaOrder') ?? [];
    updateMax();
  }

  void updateMax() {
    setState(() {
      if (_mediaOrder.isNotEmpty) {
        List<int> list = _mediaOrder
            .where((e) => e.trim().isNotEmpty && int.tryParse(e.trim()) != null)
            .map((e) => int.parse(e.trim()))
            .toList();

        if (list.isNotEmpty) {
          count = MyUtility.getMaxValue(list);
          log("Max Value is " + count.toString());
        } else {
          count = 0;
        }
      } else {
        count = 0;
      }
    });
  }

  Future<void> _pickMedia(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
    );

    if (result != null) {
      for (var file in result.files) {
        String? filePath;
        String? extension;
        setState(() {
          filePath = file.path;
          extension = file.extension?.toLowerCase();
        });
        if (filePath != null && extension != null) {
          if (['jpg', 'jpeg', 'png'].contains(extension)) {
            final decodedImage =
                await decodeImageFromList(await File(filePath!).readAsBytes());
            final height = decodedImage.height; // Image height
            final width = decodedImage.width;
            double imageAspectRatio = width / height;
            double requiredAspectRatio = 850 / 530;
            double tolerance = 0.07;

            // log("imageAspectRatio: $imageAspectRatio requiredAspectRatio: $requiredAspectRatio");
            if ((imageAspectRatio - requiredAspectRatio).abs() < tolerance) {
              setState(() {
                if (!MyUtility.checkVideoMimeType(filePath!)) {
                  // _videoDuration.add("3");
                }
                _mediaFile = File(filePath!);
                _mediaPaths.add(filePath!);
                _frontScreenMedia.add(filePath!);
                count = count + 1;
                _mediaOrder.add(count.toString());

                saveMediaPaths();
                isVideo = false;
              });
            } else {
              ConstDialog(context).showErrorDialog(
                  error:
                      "Provided image is ${width}px X ${height}px \nbut required is 850px X 530px");
              // log("Provided image is ${width}px X ${height}px but required is 850px X 530px");
            }
          } else if (['mp4', 'mov'].contains(extension)) {
            // final videoInfo = FlutterVideoInfo();

            // var info = await videoInfo.getVideoInfo(filePath!);
            // log("info!.duration!.toString()------->" + (info!.duration! / 1000).toString());

            setState(() {
              // int durationInSeconds = (info.duration! / 1000).toInt();
              _mediaPaths.add(filePath!);
              _frontScreenMedia.add(filePath!);
              // _videoDuration.add(durationInSeconds.toString());
              _mediaFile = File(filePath!);
              count = count + 1;
              _mediaOrder.add(count.toString());
              saveMediaPaths();
              isVideo = true;
            });

            await initializeVideoPlayer(File(filePath!));
          }
        }
      }
    } else {}
  }

  void _deleteImage(int index) {
    setState(() {
      for (int i = 0; i < _mediaOrder.length; i++) {
        setState(() {
          if (_mediaOrder[i].isNotEmpty) {
            try {
              int currentIndexValue = int.parse(_mediaOrder[i]);
              int targetIndexValue = int.parse(_mediaOrder[index]);

              if (currentIndexValue > targetIndexValue) {
                _mediaOrder[i] = (currentIndexValue - 1).toString();
              }
            } catch (e) {
              log("Invalid number format for _mediaOrder[i]: ${_mediaOrder[i]}");
            }
          }
        });
      }
      // _videoDuration[index] = "";
      _mediaPaths[index] = "";
      _mediaOrder[index] = "";

      updateMax();
      saveMediaPaths();
    });
  }

  Future<void> initializeVideoPlayer(File file) async {
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true); // Set looping if needed

        _videoController.play();
      });
  }

  @override
  void initState() {
    super.initState();
    loadSavedContent();
    // reset();
  }

  Future<void> addData(int index) async {
    String filePath = _frontScreenMedia[index];
    if (_mediaPaths.contains(filePath)) {
      setState(() {
        _deleteImage(index);
      });
    } else {
      int newIndex = _frontScreenMedia.indexOf(filePath);

      if (!MyUtility.checkVideoMimeType(filePath)) {
        final decodedImage =
            await decodeImageFromList(await File(filePath).readAsBytes());
        final height = decodedImage.height; // Image height
        final width = decodedImage.width;
        double imageAspectRatio = width / height;
        double requiredAspectRatio = 850 / 530;
        double tolerance = 0.07;
        if ((imageAspectRatio - requiredAspectRatio).abs() < tolerance) {
          setState(() {
            if (!MyUtility.checkVideoMimeType(filePath)) {
              // _videoDuration[newIndex]="3";
              _mediaPaths[newIndex] = filePath;
              int val = count + 1;
              _mediaOrder[newIndex] = (val).toString();

              saveMediaPaths();
            }
          });
        } else {
          ConstDialog(context).showErrorDialog(
              error:
                  "Provided image is ${width}px X ${height}px \nbut required is 850px X 530px");
          // log("Provided image is ${width}px X ${height}px but required is 850px X 530px ");
        }
      } else {
        // final videoInfo = FlutterVideoInfo();
        // var info = await videoInfo.getVideoInfo(filePath);
        setState(() {
          // int durationInSeconds = (info!.duration!/1000).toInt();  // Convert double to int
          _mediaPaths[newIndex] = filePath;
          // _videoDuration[newIndex]=durationInSeconds.toString();

          _mediaOrder[newIndex] = (count + 1).toString();

          saveMediaPaths();
        });
      }
    }
  }

  void reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('slideImages', []);
    await prefs.setStringList('videoDuration', []);
    await prefs.setStringList('frontScreen', []);
    await prefs.setStringList('mediaOrder', []);

    displayManager
        .transferDataToPresentation({'type': 'slideImages', 'slideImages': []});
    displayManager.transferDataToPresentation(
        {'type': 'videoDuration', 'videoDuration': []});
    displayManager
        .transferDataToPresentation({'type': 'mediaOrder', 'mediaOrder': []});
    setState(() {
      _mediaFile = null;
      count = 0;
    });

    loadSavedContent();
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              Text("Are you sure you want to permanently delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                log("index when deleted permenentally " + index.toString());

                setState(() {
                  _mediaPaths.removeAt(index);
                  // _videoDuration.removeAt(index);
                  _frontScreenMedia.removeAt(index);
                  _mediaFile = null;

                  updateMax();

                  for (int i = 0; i < _mediaOrder.length; i++) {
                    setState(() {
                      if (_mediaOrder[i].isNotEmpty) {
                        try {
                          int currentIndexValue = int.parse(_mediaOrder[i]);
                          int targetIndexValue = int.parse(_mediaOrder[index]);

                          if (currentIndexValue > targetIndexValue) {
                            _mediaOrder[i] = (currentIndexValue - 1).toString();
                          }
                        } catch (e) {
                          log("Invalid number format for _mediaOrder[i]: ${_mediaOrder[i]}");
                        }
                      }
                    });
                  }
                  // _videoDuration[index]="";
                  // _mediaPaths[index]="";
                  //
                  // updateMax();
                  //
                  // _mediaOrder.removeAt(count);
                  _mediaOrder.removeAt(index);

                  saveMediaPaths();
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Item deleted successfully!'),
                ));
              },
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pick Image from Gallery',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.cancel_rounded,
                        size: 30,
                        color: Constant.colorPurple,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: isMobile ? 10 : 20,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickMedia(context);
                      },
                      child: DottedBorder(
                        color: Constant.colorPurple,
                        strokeWidth: 2,
                        dashPattern: [6, 3],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: Container(
                          width: 440,
                          height: 250,
                          child: _mediaFile == null
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Tap to add Image / Video"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.add_a_photo,
                                          color: Constant.colorPurple,
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Image size must be: 530px x 850px",
                                      style: TextStyle(
                                          color: Constant.colorPurple),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Supported Types: [ jpg, jpeg, png, mp4, mov ]",
                                      style: TextStyle(
                                          color: Constant.colorPurple,
                                          fontSize: 10),
                                    ),
                                  ],
                                ))
                              : isVideo
                                  ? _videoController != null &&
                                          _videoController.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: _videoController
                                              .value.aspectRatio,
                                          child: VideoPlayer(_videoController),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator())
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _mediaFile!,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () async {
                          // saveMediaPaths();
                          reset();
                          // loadSavedContent();
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          margin: const EdgeInsets.only(left: 3, right: 3),
                          decoration: BoxDecoration(
                            color: Constant.colorPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Reset",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                    _frontScreenMedia.length > 0
                        ? Text("Saved Media")
                        : Container(),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        _frontScreenMedia.length ?? 0,
                        (index) => GestureDetector(
                          onLongPress: () {
                            showDeleteDialog(context, index);
                          },
                          onTap: () async {
                            addData(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (_frontScreenMedia[index].isNotEmpty)
                                  Stack(
                                    children: [
                                      if (MyUtility.checkVideoMimeType(
                                          _frontScreenMedia[index]))
                                        SizedBox(
                                            height: 85,
                                            child: ThumbnailWidget(
                                              videoPath:
                                                  _frontScreenMedia[index],
                                            ))
                                      else
                                        Image.file(
                                          File(_frontScreenMedia[index]),
                                          height: 85,
                                          fit: BoxFit.cover,
                                        ),
                                      _mediaOrder[index] != ""
                                          ? Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        // _mediaPaths.contains(_frontScreenMedia[index])?

                                                        Constant.colorPurple,
                                                    // :Colors.transparent
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    (_mediaOrder[index])
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          // _mediaPaths.contains(_frontScreenMedia[index])?
                                                          Colors.black,
                                                      // :
                                                      // Colors.transparent,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))))
                                          : Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Center(
                                                child: Icon(
                                                  Icons.square_outlined,
                                                  color: Constant.colorPurple,
                                                ),
                                              )),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class ThumbnailWidget extends StatefulWidget {
  final String videoPath;

  const ThumbnailWidget({super.key, required this.videoPath});

  @override
  State<ThumbnailWidget> createState() => _ThumbState();
}

class _ThumbState extends State<ThumbnailWidget> {
  Uint8List? image;

  void getThumbnail() async {
    image = await MyUtility.getThumbnailPath(widget.videoPath);
    setState(() {});
  }

  void showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoDialogWidget(
          videoPath: widget.videoPath,
        );
      },
    );
  }

  @override
  void initState() {
    Future.microtask(() => getThumbnail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: 135,
      child: Stack(
        children: [
          if (image != null)
            GestureDetector(
              onTap: () {
                showVideoDialog(context);
              },
              child: Image.memory(height: 85, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/ErrorImage.png');
              }, image!),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  showVideoDialog(context);
                },
                icon: Icon(Icons.play_circle_filled,
                    size: 30, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoDialogWidget extends StatefulWidget {
  final String videoPath;

  const VideoDialogWidget({super.key, required this.videoPath});
  @override
  _VideoDialogWidgetState createState() => _VideoDialogWidgetState();
}

class _VideoDialogWidgetState extends State<VideoDialogWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));

    _videoPlayerController?.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          bufferingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          showOptions: false,
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
        );
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(10), // Padding around the dialog
        child: Stack(
          children: [
            _chewieController != null
                ? Chewie(controller: _chewieController!)
                : Center(child: CircularProgressIndicator()),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
