import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera/shared/widgets/orientation_icon.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera/shared/widgets/rotate_icon.dart';
import 'package:fabric_mobile/client/mobile/src/features/compressor/ImageCompressor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

import '../selfie_upload.dart';
import 'bloc/bloc_camera.dart';

enum CameraSelfieOrientation { landscape, portrait, all }
enum CameraSelfieMode { fullscreen, normal }
enum CameraSelfieSide { front, back }

class CameraSelfie extends StatefulWidget {
  final Widget imageMask;
  final CameraSelfieMode mode;
  final Widget warning;
  final CameraSelfieOrientation orientationEnablePhoto;
  //final Function(File image) onFile;
  final bool enableCameraChange;
  final CameraSelfieSide initialCamera;
  final Function(CameraLensDirection direction, List<CameraDescription> cameras)
      onChangeCamera;

  const CameraSelfie({
    Key key,
    this.imageMask,
    this.mode = CameraSelfieMode.normal,
    this.orientationEnablePhoto = CameraSelfieOrientation.all,
    //this.onFile,
    this.warning,
    this.onChangeCamera,
    this.initialCamera = CameraSelfieSide.front,
    this.enableCameraChange = true,
  }) : super(key: key);
  @override
  _CameraSelfieState createState() => _CameraSelfieState();
}

class _CameraSelfieState extends State<CameraSelfie> {
  var bloc = BlocCamera();
  var previewH;
  var previewW;
  var screenRatio;
  var previewRatio;
  Size tmp;
  Size sizeImage;
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;
  QRViewController controller;

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
        if (widget.initialCamera == CameraSelfieSide.front) bloc.changeCamera();
      });
    });
    //SystemChrome.restoreSystemUIOverlays();
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);*/
    //initPlatformState();
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
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
                icon: OrientationWidget(
                  orientation: orientation,
                  child: Icon(
                    Icons.camera_alt,
                    color: LightColors.white,
                  ),
                ),
                onPressed: () {
                  sizeImage = MediaQuery.of(context).size;
                  bloc.onTakePictureButtonPressed();
                },
              ),
              backgroundColor: LightColors.black,
              radius: 25.0,
            );

        Widget _getButtonPhoto() {
          if (widget.orientationEnablePhoto == CameraSelfieOrientation.all) {
            return _buttonPhoto();
          } else if (widget.orientationEnablePhoto ==
              CameraSelfieOrientation.landscape) {
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
                          return OrientationWidget(
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
                                                  CameraSelfieMode.normal
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
                if (widget.mode == CameraSelfieMode.normal)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<Object>(
                          stream: bloc.imagePath.stream,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? SimpleCropRoute(
                                    imgfile: bloc.imagePath.value,
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: IconButton(
                                          icon: OrientationWidget(
                                            orientation: orientation,
                                            child: Icon(Icons.arrow_back_ios,
                                                color: LightColors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        backgroundColor: LightColors.black,
                                        radius: 25.0,
                                      ),
                                      _getButtonPhoto(),
                                      (widget.enableCameraChange)
                                          ? CircleAvatar(
                                              child: RotateIcon(
                                                child: OrientationWidget(
                                                  orientation: orientation,
                                                  child: Icon(
                                                    Icons.cached,
                                                    color: LightColors.white,
                                                  ),
                                                ),
                                                onTap: () => _changeCamera(),
                                              ),
                                              backgroundColor:
                                                  LightColors.black,
                                              radius: 25.0,
                                            )
                                          : CircleAvatar(
                                              child: Container(),
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 25.0,
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

class SimpleCropRoute extends StatefulWidget {
  final File imgfile;

  const SimpleCropRoute({
    Key key,
    this.imgfile,
  }) : super(key: key);
  @override
  _SimpleCropRouteState createState() => _SimpleCropRouteState();
}

class _SimpleCropRouteState extends State<SimpleCropRoute> {
  SharedPreferences prefs;
  File croppedFile;
  String candidateImage1;
  static String bass64;
  String base64Image;
  final cropKey = GlobalKey<ImgCropState>();
  BuildContext buildContext;

  Future<Null> showImage(File file) async {
    new FileImage(file)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      print('-------------------------------------------$info');
    }));
    print(file.path);
    Navigator.pop(buildContext, file);
  }

  @override
  Widget build(BuildContext context) {
    this.buildContext = context;
    final Map args = ModalRoute.of(context).settings.arguments;
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
            key: cropKey,
            // chipRadius: 100,
            // chipShape: 'rect',
            maximumScale: 3,
            image: FileImage(widget.imgfile),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: LightColors.kBlue,
          onPressed: () async {
            final crop = cropKey.currentState;
            croppedFile =
                await crop.cropCompleted(widget.imgfile, pictureQuality: 600);

            imageCompressor(croppedFile, showImage,
                "CandidateSelfie_${DateTime.now().millisecondsSinceEpoch}");
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
