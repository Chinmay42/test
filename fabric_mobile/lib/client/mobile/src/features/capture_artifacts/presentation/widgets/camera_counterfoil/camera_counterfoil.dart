import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera/camera.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_ID/shared/widgets/orientation_icon.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_ID/shared/widgets/rotate_icon.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_counterfoil/bloc/bloc_camera.dart';
import 'package:fabric_mobile/client/mobile/src/features/compressor/ImageCompressor.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/selfie_upload/presentation/widgets/camera/shared/widgets/orientation_icon.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

enum CameraOrientation { landscape, portrait, all }
enum CameraMode2 { fullscreen, normal }
enum CameraSide2 { front, back }

class CameraCounterfoil extends StatefulWidget {
  final Widget imageMask;
  final CameraMode2 mode;
  final Widget warning;
  final CameraOrientation orientationEnablePhoto;
  final bool enableCameraChange;
  final CameraSide2 initialCamera;
  final Function(CameraLensDirection direction, List<CameraDescription> cameras)
      onChangeCamera;

  const CameraCounterfoil({
    Key key,
    this.imageMask,
    this.mode = CameraMode2.normal,
    this.orientationEnablePhoto = CameraOrientation.all,
    this.warning,
    this.onChangeCamera,
    this.initialCamera = CameraSide2.front,
    this.enableCameraChange = true,
  }) : super(key: key);
  @override
  _CameraCounterfoilState createState() => _CameraCounterfoilState();
}

class _CameraCounterfoilState extends State<CameraCounterfoil> {
  var bloc = BlocCameraCounterfoil();
  var previewH;
  var previewW;
  var screenRatio;
  var previewRatio;
  Size tmp;
  Size sizeImage;

  @override
  void initState() {
    super.initState();
    bloc.getCameras();
    bloc.cameras.listen((data) {
      bloc.controllCamera = CameraController(
        data[0],
        ResolutionPreset.high,
      );
      bloc.cameraOn.sink.add(0);
      bloc.controllCamera.initialize().then((_) {
        bloc.selectCamera.sink.add(true);
        if (widget.initialCamera == CameraSide.front) bloc.changeCamera();
      });
    });
    /*SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);*/
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    bloc.dispose();
  }

  void _changeCamera() async {
    await bloc.changeCamera();

    if (widget.onChangeCamera != null) {
      widget.onChangeCamera(
        bloc.controllCamera.description.lensDirection,
        bloc.cameras.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size sizeImage = size;
    double width = size.width;
    double height = size.height;

    onfile(file) {
      print("-----------skjhfhjafhjasjfhahjkfahkjhjkasfhjasfjkhakjfhkjh");
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('crop_page', arguments: {'image': file});
    }

    return NativeDeviceOrientationReader(
      useSensor: true,
      builder: (context) {
        NativeDeviceOrientation orientation =
            NativeDeviceOrientationReader.orientation(context);

        _buttonPhoto() => CircleAvatar(
              child: IconButton(
                icon: OrientationWidgetID(
                  orientation: orientation,
                  child: Icon(
                    Icons.camera_alt,
                    color: LightColors.white,
                    size: MediaQuery.of(context).size.height / 35,
                  ),
                ),
                onPressed: () {
                  sizeImage = MediaQuery.of(context).size;
                  bloc.onTakePictureButtonPressed();
                },
              ),
              backgroundColor: LightColors.black,
              radius: MediaQuery.of(context).size.height / 30,
            );

        Widget _getButtonPhoto() {
          if (widget.orientationEnablePhoto == CameraOrientation.all) {
            return _buttonPhoto();
          } else if (widget.orientationEnablePhoto ==
              CameraOrientation.landscape) {
            if (orientation == NativeDeviceOrientation.landscapeLeft ||
                orientation == NativeDeviceOrientation.landscapeRight)
              return _buttonPhoto();
            else
              return Container(
                width: 0.0,
                height: 0.0,
              );
          } else {
            if (orientation == NativeDeviceOrientation.portraitDown ||
                orientation == NativeDeviceOrientation.portraitUp)
              return _buttonPhoto();
            else
              return Container(
                width: 0.0,
                height: 0.0,
              );
          }
        }

        if (orientation == NativeDeviceOrientation.portraitDown ||
            orientation == NativeDeviceOrientation.portraitUp) {
          sizeImage = Size(width, height);
        } else {
          sizeImage = Size(height, width);
        }

        return Scaffold(
          backgroundColor: LightColors.black,
          body: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: StreamBuilder<File>(
                      stream: bloc.imagePath.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return OrientationWidgetID(
                            orientation: orientation,
                            child: SizedBox(
                              height: sizeImage.height,
                              width: sizeImage.height,
                              child: Image.file(snapshot.data,
                                  fit: BoxFit.contain),
                            ),
                          );
                        } else {
                          return Stack(
                            children: <Widget>[
                              Center(
                                child: StreamBuilder<bool>(
                                    stream: bloc.selectCamera.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data) {
                                          previewRatio = bloc
                                              .controllCamera.value.aspectRatio;

                                          return widget.mode ==
                                                  CameraMode2.normal
                                              ? OverflowBox(
                                                  maxHeight: size.height,
                                                  maxWidth: size.height *
                                                      previewRatio,
                                                  child: CameraPreview(
                                                      bloc.controllCamera),
                                                )
                                              : AspectRatio(
                                                  aspectRatio: bloc
                                                      .controllCamera
                                                      .value
                                                      .aspectRatio,
                                                  child: CameraPreview(
                                                      bloc.controllCamera),
                                                );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ),
                              if (widget.imageMask != null)
                                Center(
                                  child: widget.imageMask,
                                ),
                            ],
                          );
                        }
                      }),
                ),
                if (widget.mode == CameraMode2.normal)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<Object>(
                          stream: bloc.imagePath.stream,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? SimpleCropRouteCounterfoil(
                                    imgfile: bloc.imagePath.value,
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: IconButton(
                                          icon: OrientationWidgetID(
                                            orientation: orientation,
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: LightColors.white,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  35,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        backgroundColor: LightColors.black,
                                        radius:
                                            MediaQuery.of(context).size.height /
                                                30,
                                      ),
                                      _getButtonPhoto(),
                                      (widget.enableCameraChange)
                                          ? CircleAvatar(
                                              child: RotateIconID(
                                                child: OrientationWidgetID(
                                                  orientation: orientation,
                                                  child: Icon(
                                                    Icons.cached,
                                                    color: LightColors.white,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        35,
                                                  ),
                                                ),
                                                onTap: () => _changeCamera(),
                                              ),
                                              backgroundColor:
                                                  LightColors.black,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                            )
                                          : CircleAvatar(
                                              child: Container(),
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                            ),
                                    ],
                                  );
                          }),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SimpleCropRouteCounterfoil extends StatefulWidget {
  final File imgfile;

  const SimpleCropRouteCounterfoil({Key key, this.imgfile}) : super(key: key);
  @override
  _SimpleCropRouteCounterfoilState createState() =>
      _SimpleCropRouteCounterfoilState();
}

class _SimpleCropRouteCounterfoilState
    extends State<SimpleCropRouteCounterfoil> {
  SharedPreferences prefs;
  File croppedFileCounterfoil;

  String base64counterfoil;
  String capturecandidate64 = '';
  String captureID64;

  String captureCounterfoil64;
  final cropKey2 = GlobalKey<ImgCropState>();
  BuildContext context;

  File fingerprint;
  bool biometricVerify;

  @override
  void initState() {}

  Future<Null> showImage(File file) async {
    new FileImage(file)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      print('-------------------------------------------$info');
    }));

    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    this.context = context;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            'Confirm',
            style: TextStyle(
                color: LightColors.grey,
                fontSize: MediaQuery.of(context).size.height / 45),
          ),
          backgroundColor: LightColors.kGrey,
          leading: new IconButton(
            icon: new Icon(Icons.navigate_before,
                color: LightColors.grey,
                size: MediaQuery.of(context).size.height / 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ImgCrop(
            key: cropKey2,
            chipRadius: 130,
            chipShape: 'rect',
            maximumScale: 3,
            image: FileImage(widget.imgfile),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: LightColors.kBlue,
          onPressed: () async {
            final crop = cropKey2.currentState;
            croppedFileCounterfoil =
                await crop.cropCompleted(widget.imgfile, pictureQuality: 600);
            imageCompressor(croppedFileCounterfoil, showImage,
                "CandidateCounterfoil_${DateTime.now().millisecondsSinceEpoch}");
           },
          tooltip: 'Done',
          child: Icon(
            Icons.check,
            size: MediaQuery.of(context).size.height / 35,
            color: LightColors.white,
          ),
        ));
  }
}
