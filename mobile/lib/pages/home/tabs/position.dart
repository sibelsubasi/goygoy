// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:bubble/bubble.dart';


class PositionTab extends StatefulWidget {
  final String screenName = "/home/tabs/position";

  final File loadedImageFile;
  final List<Map> preparedBubble;
  const PositionTab({Key key, this.loadedImageFile, this.preparedBubble}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PositionTabState();
}

class PositionTabState extends State<PositionTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  File _loadedImage;
  List<Map> _wgPreparedBubble = [];
  double width;
  double height;
  List<Offset> position = [];

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
      double _imageWidth = _imageDimension.width.toDouble();
      double _imageHeight = _imageDimension.height.toDouble();

      height = MediaQuery.of(context).size.height - 170; //170 is total padding height
      width = MediaQuery.of(context).size.width - 10; //48 is total padding width

      setState(() => _isLoading = false);

    } catch (e) {
      showErrorSheet(context: context, error: e);
      setState(() => _isLoading = false);

    }

  }


  List<Widget> _buildBubbles(){
    
    List<Widget> _lst = [];

    for(int i = 0; i < _wgPreparedBubble.length; i++){

      position.add(_wgPreparedBubble[i]['position']);

      _lst.add(
        Positioned(
          top: position[i].dy-24, //Sürükle bırak sorunu 24px ile çözüldü.
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
              padding: EdgeInsets.all(8.0), //EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Navigator.of(context).canPop()
                      ? PlatformIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    androidIcon: Icon(Icons.arrow_back, color: Config.COLOR_MID_GRAY),
                    iosIcon: Icon(CupertinoIcons.back, color: Config.COLOR_MID_GRAY),
                  )
                      : Container(),
                  Text("", style: AppTheme.textBodyBiggerGray()),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(0.0),//const EdgeInsets.fromLTRB(24, 56, 24, 30),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[

                  Container(
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
                    child: SizedBox(height: height, width: width),
                  ),

                  _wgPreparedBubble!=null ?
                  Stack(
                    children: <Widget>[

                    ]..addAll(_buildBubbles()),
                  ) : Container(),

                ],
              ),

            ),
            _isLoading ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}

