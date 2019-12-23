// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/addCommons.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/utils/fcm.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission/permission.dart';
import 'package:mobile/utils/permission_operations.dart';



class PhotoUploadPage extends StatefulWidget {
  final String screenName = "/login/photo";

  @override
  State<StatefulWidget> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File _loadedImage;
  bool _isLoading = false;
  bool _imageChanged = false;
  double _imageWidth = 144;
  double _imageHeight = 144;

  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    FCM().register(context);

    _refresh();
  }

  @override
  void dispose() {

    //!AddCommon.calledDisposed ? AdmobAd().disposeBannerAd() : print("");
    //AdmobAd().disposeInterstitialAd();
    super.dispose();
  }

  void _refresh() async {

    try {
      setState(() => _isLoading = true);

      //AdmobAd().showBannerAd().catchError(() => print('Error loading banner add'));
      AdmobAd().showBannerAd().whenComplete(() => setState(() => _isLoading = false));
      AddCommon.isAdShown = true;
      AddCommon.calledDisposed = true;
      /*
      if (AddCommon.isAdShown) {
        AdmobAd().disposeBannerAd();
        AddCommon.isAdShown = false;
        AddCommon.calledDisposed = true;
      }
      */

        //imageCache.clear();

      setState(() => _isLoading = false);

    } catch (e) {
      //showErrorSheet(context: context, error: e);
      setState(() => _isLoading = false);
    }
  }


  Future<File> _cropImage(File image) async {
    File croppedFile;
    if (image.path != null) {
      croppedFile = await ImageCropper.cropImage(
        toolbarTitle: "Düzenleyin",
        toolbarColor: Config.COLOR_GRADIENT_BEGIN,
        toolbarWidgetColor: Colors.white,
        maxWidth: 680,
        maxHeight: 680,
        //aspectRatio: CropAspectRatio(ratioX: 3.0, ratioY: 3.0),
        sourcePath: image.path,

        /**cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        androidUiSettings: AndroidUiSettings(toolbarTitle: "Düzenleyin", toolbarColor: Config.COLOR_GRADIENT_BEGIN, toolbarWidgetColor: Colors.white),
        iosUiSettings: IOSUiSettings(doneButtonTitle: "Tamam", cancelButtonTitle: "Vazgeç"),**/
      );
    } else {
      croppedFile = image;
    }
    return croppedFile;
  }

  Future<File> _openCamera() async {
    //setState(() =>_isLoading = true );
    bool granted = await PermissionOperations.checkAndRequest(PermissionName.Camera);
    //print("granted:${granted}");
    if (!granted) {
      if (await PermissionOperations.isBlocked(PermissionName.Camera)) {
        //print('isBlocked true');
        await Dialogs.alert(context, "İzin", "Lütfen ayarlardan kamera erişimine izin verin");
        if (await PermissionOperations.checkAndOpenSettings(PermissionName.Camera)) {
          //print('checkAndOpenSettingas');
        }
      } else {
        //print('isBlocked false');
      }
    }

    if (!granted) {
      return null;
    }
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _imageChanged = true;
    }
    return _cropImage(image);
  }

  Future<File> _openGallery() async {
    //setState(() =>_isLoading = true );
    bool granted = false;
    if (Platform.isAndroid) {
      granted = await PermissionOperations.checkAndRequest(PermissionName.Storage);
    } else {
      granted = true; //ios defaults
    }
    print("granted:${granted}");
    if (!granted) {
      if (await PermissionOperations.isBlocked(PermissionName.Storage)) {
        print('isBlocked true');
        await Dialogs.alert(context, "İzin", "Lütfen ayarlardan depolama erişimine izin verin");
        if (await PermissionOperations.checkAndOpenSettings(PermissionName.Storage)) {
          //print('checkAndOpenSettingas');
        }
      } else {
        print('isBlocked false');
      }
    }

    if (!granted) {
      return null;
    }
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 95);
    if (image != null) {
      _imageChanged = true;

    }
    return _cropImage(image);
  }

  Future<void> _vision(String type) async {
    print("Opening image");

    //setState(() =>_isLoading = true );

    File f;
    if (type == 'g') {
      print("from gallery");
      f = await _openGallery();
    } else if (type == 'c') {
      print("from camera");
      f = await _openCamera();
    } else {
      f = _loadedImage;
    }

    if(f != null){
      var _imageDimension = await decodeImageFromList(f.readAsBytesSync());
      setState(() {
        _loadedImage = f;
        _imageWidth = _imageDimension.width.toDouble() / 3.2;
        _imageHeight = _imageDimension.height.toDouble() / 3.2;
      });
    }
    setState(() =>_isLoading = false );



    try {


    } catch (e) {
      print(e);
      throw e;

    } finally {

    }
  }

  _uploadAndPushToEditPage() async {
    setState(() => _isLoading = true);

    try {

      print(">>>>> GO TO EDIT PAGE WITH");
      print(">>>>> LOADED IMAGE:   $_loadedImage");

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(Config.KEY_APPROVED_IMAGE_PATH, _loadedImage.toString());
      String _pfApprovedImagePath = preferences.getString(Config.KEY_APPROVED_IMAGE_PATH);

      print(">>>>> GET PREFERENCE: $_pfApprovedImagePath");

      //Navigator.of(context).pushReplacementNamed("/home/edit", arguments: _loadedImage);
      Future.delayed(const Duration(seconds: 2), () async {
        Navigator.of(context).canPop()
            ? Navigator.of(context).pushNamed("/home/edit", arguments: _loadedImage)
            : Navigator.of(context).pushNamed("/home/edit", arguments: _loadedImage);
          //: Navigator.of(context).pushReplacementNamed("/home/edit", arguments: _loadedImage);
        setState(() => _isLoading = false);
      });

    } catch (e) {
      showErrorSheet(context: context, error: e);
    }
  }


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: Text("Uyarı"),
          content: Text("Uygulamadan ayrılmak istediğinize emin misiniz?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            PlatformDialogAction(
              child: Text("Vazgeç"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            PlatformDialogAction(
              child: Text("Evet"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: PlatformScaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Navigator.of(context).canPop()
                      ? PlatformIconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          androidIcon: Icon(Icons.arrow_back, color: Config.COLOR_MID_GRAY),
                          iosIcon: Icon(CupertinoIcons.back, color: Config.COLOR_MID_GRAY),
                        )
                      : Container(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 75, 24, 50),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Fotoğraf Yükle", style: AppTheme.textPageTitleDarkStyle()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _loadedImage != null
                                      //? _vision('g')
                                      ? showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext context) => CupertinoActionSheet(
                                                title: Text('Seçiniz', style: AppTheme.textModalItem()),
                                                //message: const Text('Your options are'),
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    child: Text('Galeriden', style: AppTheme.textBodyDarkGrayBold()),
                                                    onPressed: () {
                                                      _vision('g');
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text('Kameradan', style: AppTheme.textBodyDarkGrayBold()),
                                                    onPressed: () {
                                                      _vision('c');
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                                cancelButton: CupertinoActionSheetAction(
                                                  child: Text('İptal', style: AppTheme.textBodyLight()),
                                                  isDefaultAction: true,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                        )
                                      : print('icon button will handle it'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Config.COLOR_ORANGE_DARK, style: BorderStyle.none),
                                      image: _loadedImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(_loadedImage),
                                            )
                                          : null,
                                    ),
                                    child: _loadedImage == null
                                        ? IconButton(
                                            iconSize: 144,
                                            icon: Image.asset("assets/img/addSquare.png"),
                                            //onPressed: () => _vision("g"),
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder: (BuildContext context) => CupertinoActionSheet(
                                                      title: Text('Seçiniz', style: AppTheme.textModalItem()),
                                                      //message: const Text('Your options are'),
                                                      actions: <Widget>[
                                                        CupertinoActionSheetAction(
                                                          child: Text('Galeriden', style: AppTheme.textBodyDarkGrayBold(),),
                                                          onPressed: () {
                                                            _vision('g');
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          child: Text('Kameradan', style: AppTheme.textBodyDarkGrayBold()),
                                                          onPressed: () {
                                                            _vision('c');
                                                            Navigator.of(context).pop();
                                                          },
                                                        )
                                                      ],
                                                      cancelButton: CupertinoActionSheetAction(
                                                        child: Text('İptal', style: AppTheme.textBodyLight()),
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ),
                                              );
                                            },
                                          )
                                        : _loadedImage == null ? SizedBox(height: 144, width: 144):SizedBox(height: _imageHeight, width: _imageWidth),
                                  ),
                                ),
                                SizedBox(height: 20),
                                _loadedImage == null
                                    ? Text("Fotoğraf yüklemek için artıya basın", style: AppTheme.textHint())
                                    : Text("Değiştirmek için fotoğrafın üstüne basın.", style: AppTheme.textHint()),
                                SizedBox(height: 10),
                              ],
                            )
                          ],
                        ),
                      ),
                      _loadedImage != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: PositiveActionButton(
                                    child: Text("Devam Et", style: AppTheme.textButtonPositive()),
                                    onPressed: () {
                                      AdmobAd().showInterstitialAd();
                                      Future.delayed(Duration(milliseconds: 500,)).then((_) {
                                        AdmobAd().isAdLoaded ? _uploadAndPushToEditPage() : _uploadAndPushToEditPage();
                                      });

                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                _isLoading ? Dialogs.aotIndicator(context) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}