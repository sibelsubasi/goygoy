
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';


class SharePage extends StatefulWidget {
  final String screenName = "/home/share";

  final File capturedImageFile;
  const SharePage({Key key, this.capturedImageFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = false;
  File _capturedImageFile;
  double _imageWidth = 144;
  double _imageHeight = 144;
  double width;
  double height;

  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    _capturedImageFile = widget.capturedImageFile;
    print(" ////// WELCOME TO SHARE PAGE ///////");
    print("widget.capturedImageFile: ${widget.capturedImageFile}");

    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() async {

    try {
      setState(() => _isLoading = true);

      if(_capturedImageFile != null){
        var _imageDimension = await decodeImageFromList(_capturedImageFile.readAsBytesSync());
          _imageWidth = _imageDimension.width.toDouble();
          _imageHeight = _imageDimension.height.toDouble();

          height = MediaQuery.of(context).size.height - 170; //170 is total padding height
          width = MediaQuery.of(context).size.width - 10; //48 is total padding width
      }
      setState(() => _isLoading = false);

    } catch (e) {
      //showErrorSheet(context: context, error: e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
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
              Container(
                margin: EdgeInsets.only(top: 40.0),
                child: ListView(
                    physics: ScrollPhysics(),
                      children: <Widget>[
                        _capturedImageFile == null ? Center(child: Text("Paylaşılacak görüntü oluşturulamadı..")):Container(),
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Config.COLOR_ORANGE),
                            image: _capturedImageFile != null
                                ? DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(_capturedImageFile),
                            )
                                : null,
                          ),
                          child: SizedBox(height: _imageHeight, width: _imageWidth),
                        ),
                      ]//..addAll(_historyList()),
                  ),
              ),
              _isLoading ? Dialogs.aotIndicator(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}