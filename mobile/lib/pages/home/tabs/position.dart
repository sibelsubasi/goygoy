
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/commons/adsCommons.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PositionTab extends StatefulWidget {
  final String screenName = "/home/tabs/position";

  final File loadedImageFile;
  final List<Map> preparedBubble;
  const PositionTab({Key key, this.loadedImageFile, this.preparedBubble,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PositionTabState();
}

class PositionTabState extends State<PositionTab> with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey previewContainer = new GlobalKey(); //for screenshot
  final GlobalKey imageContainer = new GlobalKey(); //for image container
  AnimationController _controller;


  bool _isLoading = false;
  File _loadedImage;
  List<Map> _wgPreparedBubble = [];
  List<Widget> _widgetReadyForCapture = [];
  double width;
  double height;
  double _imageWidth = 32;
  double _imageHeight = 32;
  List<Offset> position = [];
  List<bool> _isDeleteBtnEnabled = [];
  bool _isShareBtnPressed = false;
  Size _sizeOfContainer;

  File _capturedImage;

  //*** BUBBLE STYLES ***/
  BubbleStyle bubbleWhite;
  BubbleStyle bubbleBlue;
  BubbleStyle bubbleWhiteAccent;
  BubbleStyle bubbleBlueAccent;


  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    print("====== Welcome to Position Page =======");
    _loadedImage = widget.loadedImageFile;
    _wgPreparedBubble = widget.preparedBubble;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _controller.forward();

    //*** BUBBLE STYLES ***/
    bubbleWhite = BubbleStyle(
      radius: Radius.circular(10.0),
      nipRadius: 0.5,
      nip: BubbleNip.leftBottom,
      color: Colors.white,
      elevation: 0.8,
      margin: BubbleEdges.only(top: 0.0, right: 0.0),
      alignment: Alignment.bottomLeft,
    );

    bubbleBlue = BubbleStyle(
      radius: Radius.circular(10.0),
      nipRadius: 0.5,
      nip: BubbleNip.rightBottom,
      color: Colors.blue,
      elevation: 0.8,
      margin: BubbleEdges.only(top: 0.0, left: 0.0),
      alignment: Alignment.bottomRight,
    );

    bubbleWhiteAccent = BubbleStyle(
      radius: Radius.circular(10.0),
      nipRadius: 0.5,
      nip: BubbleNip.leftBottom,
      color: Colors.white.withOpacity(0.6),
      elevation: 0.8,
      margin: BubbleEdges.only(top: 0.0, right: 0.0),
      alignment: Alignment.bottomLeft,
    );

    bubbleBlueAccent = BubbleStyle(
      radius: Radius.circular(10.0),
      nipRadius: 0.5,
      nip: BubbleNip.rightBottom,
      color: Colors.blue.withOpacity(0.6),
      elevation: 0.8,
      margin: BubbleEdges.only(top: 0.0, left: 0.0),
      alignment: Alignment.bottomRight,
    );

    _refresh();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    _controller.dispose();

    //AdmobAd().disposeInterstitialAd();
    super.dispose();
  }

  _afterLayout(_) {
    getSizes();
  }

  void _refresh() async {

    try {
      setState(() => _isLoading = true);

      await decodeImageFromList(_loadedImage.readAsBytesSync()).then((_imageDimension){
        _imageWidth = _imageDimension.width.toDouble();
        _imageHeight = _imageDimension.height.toDouble();

        print("HEIGHT HEIGHT HEIGHT $_imageHeight");

        setState(() => _isLoading = false);
      });

      height = MediaQuery.of(context).size.height - 170; //170 is total padding height
      width = MediaQuery.of(context).size.width - 10; //48 is total padding width


      /**
      SharedPreferences sf = await SharedPreferences.getInstance();
      if( sf.getBool(Config.KEY_SHOW_INFO_FIRST) == null && _wgPreparedBubble != null)
        if(_wgPreparedBubble.length == 1)
          sf.setBool(Config.KEY_SHOW_INFO_FIRST, true);
      Future.delayed(Duration(seconds: 1)).then((_) {
        Dialogs.alert(context, "Hey!", "Baloncuk silmek istersen baloncuğun üstüne dokun ve çarpıya bas!");
      });
          **/


    } catch (e) {
      showErrorSheet(context: context, error: e);
      setState(() => _isLoading = false);

    }
  }

  void _reloadImageAfterShare() async{
    try {
      await decodeImageFromList(_loadedImage.readAsBytesSync()).then((_imageDimension){
        _imageWidth = _imageDimension.width.toDouble();
        _imageHeight = _imageDimension.height.toDouble();

        setState(() => _isLoading = false);
      });

      height = MediaQuery.of(context).size.height - 170; //170 is total padding height
      width = MediaQuery.of(context).size.width - 10; //48 is total padding width

    } catch (e) {
      showErrorSheet(context: context, error: e);
    }
  }

  void getSizes() {
    final RenderBox renderBoxContainer = previewContainer.currentContext.findRenderObject();
    final sizeOfContainer = renderBoxContainer.size;
    _sizeOfContainer = sizeOfContainer;
    print("SIZE of ScreenShot Container: $sizeOfContainer");
  }

  Future<String> takeScreenShot() async {

    try {
      print('inside takeScreenShot takeScreenShot');

      RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print(pngBytes);

      var _rnd = new Random.secure();
      String imgFilePath = '$directory/${_rnd.nextInt(99999)}_screenshot.png';
      File imgFile =new File(imgFilePath);
      imgFile.writeAsBytes(pngBytes);

      print(imgFile);
      print(imgFilePath);
      print("BEFORE RETURN!");

      //return imgFile;
      return imgFilePath;

    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }

  }

  _captureAndPushToSharePage() async{

    print("_CaptureAndPushToSharePage");
    print("!!!!!loadedImage: $_loadedImage");

    //_reloadImageAfterShare();

    setState(() => _isLoading = true);

      try {
        String _filePath;

        Future.delayed(const Duration(seconds: 1), () async{
          await takeScreenShot().then((result) {
            setState(() {
              _isLoading = false;
              _filePath = result;
              ShareExtend.share(_filePath, "image");
            });
          });
        });

        Future.delayed(const Duration(seconds: 3), () async{
          _refresh();
        });

      } catch (e) {
        print(e);
        setState(() => _isLoading = false);
      }



    /****
    Navigator.of(context).canPop()
        ? Navigator.of(context).pushNamed("/home/share", arguments: await takeScreenShot())
        : Navigator.of(context).pushReplacementNamed("/home/share", arguments: await takeScreenShot());
    */

  }

  deleteSelectedBubble(index){
    print("inside");
    setState(() {
      _wgPreparedBubble.removeAt(index);
    });
  }

  Future<void> showConfirm(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure '),
                Text('you want to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes!'),
              onPressed: () {
                deleteSelectedBubble(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  List<Widget> _buildBubbles(){

    List<Widget> _lst = [];

    for(int i = 0; i < _wgPreparedBubble.length; i++){

      _isDeleteBtnEnabled.add(false);
      position.add(_wgPreparedBubble[i]['position']);

      _lst.add(
        Positioned(
          top: position[i].dy-10, //Sürükle bırak sorunu 10px ile çözüldü.
          left: position[i].dx,
          child: GestureDetector(
            /*onDoubleTap: (){
              setState(() {
                _wgPreparedBubble[i]['isRightBubble'] = !_wgPreparedBubble[i]['isRightBubble'];
              });
            },*/
            onTap: () =>
                setState(()
                {
                  _isShareBtnPressed = false;
                  _isDeleteBtnEnabled[i] = !_isDeleteBtnEnabled[i];
                  print(_isDeleteBtnEnabled[i]);
                }),
            child:Draggable(
              ignoringFeedbackSemantics: false,
              feedback: Bubble(
                style: _wgPreparedBubble[i]['isRightBubble'] ? bubbleBlueAccent : bubbleWhiteAccent,
                child: Text(_wgPreparedBubble[i]['message'], style: TextStyle(
                    color: _wgPreparedBubble[i]['isRightBubble'] ? Colors.white : Colors.black,
                    fontSize: 13.5, fontFamily: 'Arial', fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),),
              ),
              child:  Column(
                  crossAxisAlignment: _wgPreparedBubble[i]['isRightBubble'] ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: <Widget>[
                    Bubble(
                      style: _wgPreparedBubble[i]['isRightBubble'] ? bubbleBlue : bubbleWhite,
                      child: Text(_wgPreparedBubble[i]['message'], style: TextStyle(
                          color: _wgPreparedBubble[i]['isRightBubble'] ? Colors.white : Colors.black,
                          fontSize: 13.5, fontFamily: 'Arial')),
                    ),

                    AnimatedSwitcher(
                      switchInCurve: FlippedCurve(Curves.elasticIn), //ElasticInOutCurve(),
                      switchOutCurve: FlippedCurve(Curves.elasticInOut),
                      //reverseDuration: Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child:
                        _isDeleteBtnEnabled[i] && !_isShareBtnPressed?
                        GestureDetector(
                            onTap: () {
                              showConfirm(i);
                            },
                            child: LimitedBox(
                                maxWidth: 32,
                                maxHeight: 32,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                      color: Colors.red,
                                  ),
                                  child: Icon(Icons.clear, color: Colors.white, size: 21,),
                                )
                            )):SizedBox(),
                          ),

                  ],
                ),

              childWhenDragging: SizedBox(),
              onDraggableCanceled: (velocity, offset){
                  setState(() {
                    position[i] = offset;
                  });
              },
            ),
          ),

        ),
      );
    }

    _widgetReadyForCapture = _lst;
    print(_widgetReadyForCapture);

    return _lst;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(4.0, 12.0, 8.0, 0.0), //EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Navigator.of(context).canPop()
                        ? PlatformIconButton(
                      onPressed: () {
                        AdsCommon.isAdShown = true;
                        AdsCommon.calledDisposed = false;
                        AdmobAd().showBannerAd();

                        Navigator.of(context).pop(true);
                      },
                      androidIcon: Icon(Icons.arrow_back, color: Config.COLOR_MID_GRAY, size: 28,),
                      iosIcon: Icon(CupertinoIcons.back, color: Config.COLOR_MID_GRAY),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(width: 0),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => print("Share onTap!"),
                      child:ActionButtonSmall(
                        buttonColor: Config.COLOR_ORANGE_DARK,
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Share ", style: AppTheme.textButtonPositive()),
                              Icon(FontAwesomeIcons.instagram, color: Config.COLOR_WHITE, size: 16),
                            ]
                        ),
                        onPressed: () {
                          AdmobAd().showInterstitialAd();
                          //AdmobAd().isAdLoaded ? _captureAndPushToSharePage() : _captureAndPushToSharePage(); //print("waiting...");

                          setState(() {
                            _isShareBtnPressed = true;
                            _captureAndPushToSharePage();
                          });

                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),//const EdgeInsets.fromLTRB(24, 56, 24, 30),
              child:

              RepaintBoundary(
                key: previewContainer,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[


                  SizedBox(
                    height: _imageWidth >= _imageHeight ? _imageHeight / 1.82 : _imageHeight / 1.46,
                    width: _imageWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        image: _loadedImage != null ?
                        DecorationImage(
                          fit: BoxFit.contain,
                          image: FileImage(_loadedImage),
                        ):DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('img/errorIcon.png'),
                        ),
                      ),
                    ),
                  ),


                    _wgPreparedBubble!=null ?
                    Stack(
                      children: <Widget>[

                      ]..addAll(_buildBubbles()),
                    ) : Container(),


                        WaterMark(
                          rotate: 3,
                          height: _imageWidth >= _imageHeight ? _imageHeight / 1.82 : _imageHeight / 1.46,
                          width: _imageWidth,
                          alignment: Alignment.bottomRight,
                        ),


                    /*
                    RaisedButton(
                      child: Text("Click on Interstitial Ad"),
                      onPressed: (){
                        createInterstitialAd()..load()..show();
                      },
                    ),
                    */

                  ],
                ),
              ),
            ),

            _isLoading || _loadedImage == null ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}

