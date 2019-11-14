
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
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';


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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  void _refresh() async {

    try {
      setState(() => _isLoading = true);

      await decodeImageFromList(_loadedImage.readAsBytesSync()).then((_imageDimension){
        _imageWidth = _imageDimension.width.toDouble();
        _imageHeight = _imageDimension.height.toDouble();

        setState(() => _isLoading = false);
      });

      height = MediaQuery.of(context).size.height - 170; //170 is total padding height
      width = MediaQuery.of(context).size.width - 10; //48 is total padding width

    } catch (e) {
      showErrorSheet(context: context, error: e);
      setState(() => _isLoading = false);

    }

  }

  Future<String> takeScreenShot() async {

    try {
      print('inside takeScreenShot takeScreenShot');

      RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
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

    setState(() => _isLoading = true);

      try {
        String _filePath;

        Future.delayed(const Duration(seconds: 2), () async{
          await takeScreenShot().then((result) {
            setState(() {
              _isLoading = false;
              _filePath = result;
              ShareExtend.share(_filePath, "image");
            });
          });
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
          title: Text('Uyarı'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bunu silmek istediğinize '),
                Text('emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Vazgeç'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Evet'),
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
                      reverseDuration: Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child:
                        _isDeleteBtnEnabled[i]?
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
                      onPressed: () => Navigator.of(context).pop(),
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
                      onTap: () => print("SHARE!"),
                      child:ActionButtonSmall(
                        buttonColor: Config.COLOR_ORANGE_DARK,
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Paylaş ", style: AppTheme.textButtonPositive()),
                              Icon(FontAwesomeIcons.instagram, color: Config.COLOR_WHITE, size: 16),
                            ]
                        ),
                        onPressed: () => _captureAndPushToSharePage(),
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

                    Container(
                      width: width,
                      height: height, //- (height - _imageHeight) - 28,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(17),
                        //border: Border.all(color: Config.COLOR_ORANGE),
                        image: _loadedImage != null
                            ? DecorationImage(
                          fit: BoxFit.contain,
                          image: FileImage(_loadedImage),
                        )
                            : null,
                      ),
                      child: SizedBox(height: _imageHeight, width: _imageWidth),
                    ),

                    _wgPreparedBubble!=null ?
                    Stack(
                      children: <Widget>[

                      ]..addAll(_buildBubbles()),
                    ) : Container(),

                    !_isLoading?
                    WaterMark(
                      rotate: 3,
                      height: _imageHeight >= height ?
                           _imageHeight == height ? height - ((height/_imageHeight)*100) +68 : height - ((height/_imageHeight)*100) -48
                          :_imageHeight - ((_imageHeight/height)*100) -48,
                      width: _imageWidth, alignment: Alignment.bottomRight,)
                        :SizedBox(),
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

