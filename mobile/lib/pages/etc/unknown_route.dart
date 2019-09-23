import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/commons/data.dart';

class UnknownPage extends StatelessWidget {
  final routePath;

  const UnknownPage({Key key, this.routePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> DATA_ROUTE_ACTIONS = [];

    DATA_ROUTE_ACTIONS = DATA_ALL_ACTIONS +
        DATA_ABSENCE_PLANNING_ACTIONS +
        DATA_ABSENCE_ACTIONS +
        DATA_EXPENSE_ACTIONS +
        DATA_OUTSIDE_TIMING_ACTIONS +
        DATA_ACTIONS_ABOUT;

    String label =DATA_ROUTE_ACTIONS.where((m) => m['route'] == routePath).first['label'];

    return PlatformScaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    androidIcon:
                        Icon(Icons.arrow_back, color: Config.COLOR_MID_GRAY),
                    iosIcon: Icon(CupertinoIcons.back,
                        color: Config.COLOR_MID_GRAY)),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 10, top: 56, bottom: 17),
                    child:
                    Container(
                      child: Text(label, style: AppTheme.textPageTitleDarkStyle(),
                          overflow: TextOverflow.ellipsis, maxLines: 1
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
              MessageWithImage(
                width: 282,
                height: 210,
                title: "Bu sayfa yapım aşamasındadır",
                path: 'assets/img/bg_construction.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
