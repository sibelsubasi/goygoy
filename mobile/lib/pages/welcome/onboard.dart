// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/utils/fcm.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/clippers/absolute_shape.dart';
import 'package:mobile/commons/config.dart';

class OnBoardPage extends StatefulWidget {
  final String screenName = "/welcome/onboard";
  final int PAGE_LIMIT = 3;

  @override
  State<StatefulWidget> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);
    Analytics.logTutorialBegin();

    FCM().register(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                      colors: [
                        Config.COLOR_GRADIENT_BEGIN,
                        Config.COLOR_GRADIENT_END,
                        Config.COLOR_LIGHT_GREEN,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
                clipper: AbsoluteShapeClipper(),
              ),
            ),
            DefaultTabController(
              length: widget.PAGE_LIMIT,
              child: _OnBoardPageSelector(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnBoardPageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TabBarView(
              physics: PageScrollPhysics(),
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Çok Kolay!", style: AppTheme.textHeaderStyle(),overflow: TextOverflow.ellipsis ,maxLines: 1),
                                  SizedBox(height: 9),
                                  Text("Sen sus hiçbir şey söyleme, \nSen sus fotoğrafların konuşsun :)", style: AppTheme.textMuted(),overflow: TextOverflow.ellipsis ,maxLines: 2),
                                  SizedBox(height: 9),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Flexible(flex:20, child: Container()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 195,
                              child: Image(
                                image: AssetImage("assets/img/splash1.png"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            //SizedBox(height: 70),
                          ],
                        ),
                        Flexible(flex: 79, child: Container()),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Sürükle Bırak!", style: AppTheme.textHeaderStyle(),overflow: TextOverflow.ellipsis ,maxLines: 1),
                                  SizedBox(height: 9),
                                  Text("Konuşma balonlarını hazırla, \nİstediğin yere sürükleyerek konumlandır.", style: AppTheme.textMuted(),overflow: TextOverflow.ellipsis ,maxLines:2),
                                  SizedBox(height: 9),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Flexible(flex: 20, child: Container()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 195,
                              child: Image(
                                image: AssetImage("assets/img/splash2.png"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            // SizedBox(height: 70),
                          ],
                        ),
                        Flexible(flex: 79, child: Container()),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("..ve Paylaş!", style: AppTheme.textHeaderStyle(),overflow: TextOverflow.ellipsis ,maxLines: 1),
                                  SizedBox(height: 9),
                                  Text("Hazırladığın görüntüyü \nanında sosyal medyada paylaşabilirsin.", style: AppTheme.textMuted(),overflow: TextOverflow.ellipsis ,maxLines: 2),
                                  SizedBox(height: 9),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Flexible(flex: 20, child: Container()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 195,
                              child: Image(
                                image: AssetImage("assets/img/splash3.png"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            //SizedBox(height: 70),
                          ],
                        ),
                        Flexible(flex: 79, child: Container()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TabPageSelector(
                  color: Config.COLOR_WHITE_GRAY,
                  selectedColor: Config.COLOR_ORANGE,
                  controller: controller,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: PositiveActionButton(
                    onPressed: () {
                      Analytics.logTutorialComplete();
                      return Navigator.of(context).pushReplacementNamed("/login/photo");
                    },
                    child: Text("Hemen Başla!", style: AppTheme.textButtonPositive()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
