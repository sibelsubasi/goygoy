
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:bubble/bubble.dart';
import 'package:path_provider/path_provider.dart';


class PositionTab extends StatefulWidget {
  final String screenName = "/home/tabs/position";

  final File loadedImageFile;
  final List<Map> preparedBubble;
  const PositionTab({Key key, this.loadedImageFile, this.preparedBubble,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PositionTabState();
}

class PositionTabState extends State<PositionTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey previewContainer = new GlobalKey(); //for screenshot

  bool _isLoading = false;
  File _loadedImage;
  List<Map> _wgPreparedBubble = [];
  List<Widget> _widgetReadyForCapture = [];
  double width;
  double height;
  double _imageWidth;
  double _imageHeight;
  List<Offset> position = [];

  File _capturedImage;

  //*** BUBBLE STYLES ***/
  BubbleStyle bubbleWhite = BubbleStyle(
    radius: Radius.circular(10.0),
    nipRadius: 0.5,
    nip: BubbleNip.leftBottom,
    color: Colors.white,
    elevation: 0.8,
    margin: BubbleEdges.only(top: 0.0, right: 0.0),
    alignment: Alignment.bottomLeft,
  );

  BubbleStyle bubbleBlue = BubbleStyle(
    radius: Radius.circular(10.0),
    nipRadius: 0.5,
    nip: BubbleNip.rightBottom,
    color: Colors.blue,
    elevation: 0.8,
    margin: BubbleEdges.only(top: 0.0, left: 0.0),
    alignment: Alignment.bottomRight,
  );

  BubbleStyle bubbleWhiteAccent = BubbleStyle(
    radius: Radius.circular(10.0),
    nipRadius: 0.5,
    nip: BubbleNip.leftBottom,
    color: Colors.white.withOpacity(0.6),
    elevation: 0.8,
    margin: BubbleEdges.only(top: 0.0, right: 0.0),
    alignment: Alignment.bottomLeft,
  );

  BubbleStyle bubbleBlueAccent = BubbleStyle(
    radius: Radius.circular(10.0),
    nipRadius: 0.5,
    nip: BubbleNip.rightBottom,
    color: Colors.blue.withOpacity(0.6),
    elevation: 0.8,
    margin: BubbleEdges.only(top: 0.0, left: 0.0),
    alignment: Alignment.bottomRight,
  );


  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    print("====== Welcome to Position Page =======");
    _loadedImage = widget.loadedImageFile;
    _wgPreparedBubble = widget.preparedBubble;

    print("_wgPreparedBubble List: $_wgPreparedBubble");
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() async {

    try {

      setState(() => _isLoading = true);

      var _imageDimension = await decodeImageFromList(_loadedImage.readAsBytesSync());
      _imageWidth = _imageDimension.width.toDouble();
      _imageHeight = _imageDimension.height.toDouble();

      height = MediaQuery.of(context).size.height - 170; //170 is total padding height
      width = MediaQuery.of(context).size.width - 10; //48 is total padding width

      setState(() => _isLoading = false);

    } catch (e) {
      showErrorSheet(context: context, error: e);
      setState(() => _isLoading = false);

    }

  }

  Future<File> takeScreenShot() async {

    setState(() => _isLoading = true);
    try {
      print('inside takeScreenShot takeScreenShot');

      RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print(pngBytes);

      var _rnd = new Random.secure();
      File imgFile =new File('$directory/${_rnd.nextInt(99999)}_screenshot.png');
      imgFile.writeAsBytes(pngBytes);

      print(imgFile);
      print("BEFORE RETURN!");
      setState(() => _isLoading = false);
      return imgFile;

    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }

  }

  _captureAndPushToSharePage() async{

    print("_CaptureAndPushToSharePage");

    //_capturedImage = await takeScreenShot();

    Navigator.of(context).canPop()
        ? Navigator.of(context).pushNamed("/home/share", arguments: await takeScreenShot())
        : Navigator.of(context).pushReplacementNamed("/home/share", arguments: await takeScreenShot());

  }


  List<Widget> _buildBubbles(){
    
    List<Widget> _lst = [];

    for(int i = 0; i < _wgPreparedBubble.length; i++){

      position.add(_wgPreparedBubble[i]['position']);

      _lst.add(
        Positioned(
          top: position[i].dy-28, //Sürükle bırak sorunu 28px ile çözüldü.
          left: position[i].dx,
          child: Draggable(
            ignoringFeedbackSemantics: false,
            feedback: Bubble(
              style: _wgPreparedBubble[i]['isRightBubble'] ? bubbleBlueAccent : bubbleWhiteAccent,
              child: Text(_wgPreparedBubble[i]['message'], style: TextStyle(
                  color: _wgPreparedBubble[i]['isRightBubble'] ? Colors.white : Colors.black,
                  fontSize: 13.0, fontFamily: 'Arial', fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),),
            ),
            child: Bubble(
              style: _wgPreparedBubble[i]['isRightBubble'] ? bubbleBlue : bubbleWhite,
              child: Text(_wgPreparedBubble[i]['message'], style: TextStyle(
                  color: _wgPreparedBubble[i]['isRightBubble'] ? Colors.white : Colors.black,
                  fontSize: 13.0, fontFamily: 'Arial')),
            ),
            childWhenDragging: Container(),
            onDraggableCanceled: (velocity, offset){
                setState(() {
                  position[i] = offset;
                });
            },
          ),
        ),
      );
    }

    _widgetReadyForCapture = _lst;
    print("_widgetReadyForCapture");
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
            Padding(
              padding: EdgeInsets.all(2.0), //EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 4),
                  Expanded(
                    flex: 1,
                    child: Navigator.of(context).canPop()
                        ? PlatformIconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      androidIcon: Icon(Icons.arrow_back, color: Config.COLOR_MID_GRAY),
                      iosIcon: Icon(CupertinoIcons.back, color: Config.COLOR_MID_GRAY),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: 6,
                    child: SizedBox(width: 0),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => print("SHARE!"),
                      child:ActionButtonWithLightBorder(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Paylaş", style: AppTheme.textTabPassive()),
                              Icon(Icons.share, color: Config.COLOR_LIGHT_GRAY, size: 16),
                            ]
                        ),
                        onPressed: () => _captureAndPushToSharePage(),
                      ),),
                  ),
                  SizedBox(width: 8),

                ],
              ),
            ),

            !_isLoading ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 4.0),//const EdgeInsets.fromLTRB(24, 56, 24, 30),
              child:

              RepaintBoundary(
                key: previewContainer,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    Container(
                      width: _imageWidth,
                      height: _imageHeight - (height - _imageHeight)- 28,
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

                  ],
                ),
              ),
            ):Container(),


            _isLoading ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}

