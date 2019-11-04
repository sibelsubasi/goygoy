// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/pages/home/tabs/bubble.dart';
import 'package:mobile/pages/home/tabs/position.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';


class EditPage extends StatefulWidget {
  final String screenName = "/home/edit";

  final File loadedImageFile;
  final List<Map> preparedBubble;
  const EditPage({Key key, this.loadedImageFile, this.preparedBubble,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File _loadedImage;
  List<Map> _preparedBubble;
  bool _isLoading = false;

  double width;
  double height;

  int _currentTabIndex = 0;



  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    _loadedImage = widget.loadedImageFile;
    _preparedBubble = widget.preparedBubble;

    print(" ////// WELCOME TO EDIT PAGE ///////");
    print("widget.loadedImageFile: ${widget.loadedImageFile}");
    print("widget.preparedBubble List: ${widget.preparedBubble}");
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() async {

  }


  _uploadAndPushToEditPage() async {
    try {


    } catch (e) {
      showErrorSheet(context: context, error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: PlatformNavBar(
        android: (_) => MaterialNavBarData(type: BottomNavigationBarType.fixed),
        itemChanged: (index) => setState(() =>
        _currentTabIndex = index),
        //onTap: (index) => setState(() => _currentTabIndex = index),
        currentIndex: _currentTabIndex,
        items: [
          BottomNavigationBarItem(
            title: Text("Yerleştir", style: _currentTabIndex == 0 ? AppTheme.textTabActive() : AppTheme.textTabPassive()),
            activeIcon: Image.asset("assets/img/activeEdit.png"),
            icon: Image.asset("assets/img/passiveEdit.png"),
          ),
          BottomNavigationBarItem(
            title: Text("Baloncuk Ekle", style: _currentTabIndex == 1 ? AppTheme.textTabActive() : AppTheme.textTabPassive()),
            activeIcon: Image.asset("assets/img/activeBubble.png"),
            icon: Image.asset("assets/img/passiveBubble.png"),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentTabIndex != 0,
            child: new TickerMode(
              enabled: _currentTabIndex == 0,
              //child: HomeTab(key: PageStorageKey("_home")),
              child: PositionTab(loadedImageFile: _loadedImage, preparedBubble: _preparedBubble,),
            ),
          ),
          Offstage(
            offstage: _currentTabIndex != 1,
            child: new TickerMode(
              enabled: _currentTabIndex == 1,
              child: BubbleTab(loadedImageFile: _loadedImage, preparedBubble: _preparedBubble,),
            ),
          ),
        ],
      ),
    );
  }
}