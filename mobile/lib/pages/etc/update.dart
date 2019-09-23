// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';
import 'package:mobile/entities/update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  final String screenName = "/etc/update";
  final UpdateEntity updateEntity;

  const UpdatePage({Key key, this.updateEntity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Config.KEY_LAST_UPDATE_SHOWN_ON, DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Güncelleme", style: AppTheme.textPageTitleDarkStyle(), textAlign: TextAlign.center),
                    Icon(
                      Icons.extension,
                      color: Config.COLOR_GRADIENT_BEGIN,
                      size: 120,
                    ),
                    Text("${widget.updateEntity.version} sürümü", textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    Text(
                      "Size daha iyi bir deneyim sunmak için uygulamamızı belirli aralıklarla güncelleyioruz.",
                      textAlign: TextAlign.center,
                      style: AppTheme.textHint(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Uygulamanızı Şimdi Güncelleyin",
                      textAlign: TextAlign.center,
                      style: AppTheme.textBodyDarkGrayBold(),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "(Bu işlem genellikle bir dakikadan az sürer).",
                      textAlign: TextAlign.center,
                      style: AppTheme.textHint(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => Dialogs.alert(
                                context,
                                "Sürüm Notları",
                                widget.updateEntity.createdDate + "\n\n" + widget.updateEntity.changeLog,
                              ),
                          child: Row(
                            children: <Widget>[Icon(Icons.history), Text("Değişim Notlarını Gör")],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          widget.updateEntity.forceUpdate != 'Y'
                              ? Expanded(
                                  child: NegativeActionButton(
                                    onPressed: () => Navigator.of(context).pushReplacementNamed("/"),
                                    child: Text("Şimdi Değil", style: AppTheme.textButtonNegative()),
                                  ),
                                )
                              : Container(),
                          widget.updateEntity.forceUpdate != 'Y' ? SizedBox(width: 20) : Container(),
                          Expanded(
                            child: PositiveActionButton(
                              onPressed: () => launch(("${Config.STORE_FRONT_URL}${widget.updateEntity.storeLink}")),
                              child: Text("Güncelle", style: AppTheme.textButtonPositive()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _isLoading ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}
