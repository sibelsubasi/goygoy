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

      height = MediaQuery.of(context).size.height - 170; //110 is total padding height
      width = MediaQuery.of(context).size.width - 48; //48 is total padding width

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
          top: position[i].dy,
          left: position[i].dx,
          child: Draggable(
            ignoringFeedbackSemantics: false,
            feedback: BubbleAccent(
              message: _wgPreparedBubble[i]['message'],
              time: '21:00',
              delivered: true,
              position: _wgPreparedBubble[i]['isWhiteBox'],
            ),
            child: Bubble(
              message: _wgPreparedBubble[i]['message'],
              time: '21:00',
              delivered: true,
              position: _wgPreparedBubble[i]['isWhiteBox'],
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
              padding: const EdgeInsets.all(8.0),
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
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 30),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[

                  Container(
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(17),
                      //border: Border.all(color: Config.COLOR_ORANGE),
                      image: _loadedImage != null
                          ? DecorationImage(
                        fit: BoxFit.fitWidth,
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

