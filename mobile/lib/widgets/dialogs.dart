// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/custom_routes/modal_from_top_route.dart';

const kTaskBarHeightMaterial = 50.0;
const kTaskBarHeightCupertino = 42.0;

class FloatingActionButtonItem {
  Color foreGroundColor;
  Color backGroundColor;
  final IconData icon;
  final Function func;
  final Function then;

  FloatingActionButtonItem({@required this.icon, @required this.func, this.then, this.foreGroundColor, this.backGroundColor});
}

abstract class Dialogs {
  static Future<void> banner(BuildContext context, String title, String message, String successRoute, dynamic successRouteArgs) async {
    double popupHeight = 200;

    return await showModalTopRoute<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: popupHeight,
          //padding: const EdgeInsets.only(bottom: 7.0),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 9, spreadRadius: 4)],
            color: Config.COLOR_WHITE_GRAY,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(25, 25),
              bottomLeft: Radius.elliptical(25, 25),
            ),
          ),
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
                top: true,
                child: Center(
                  child: Card(
                    elevation: 0,
                    color: Config.COLOR_WHITE_GRAY,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.notification_important, color: Config.COLOR_ORANGE),
                          title: Text(title),
                          subtitle: Text(message, maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                        ButtonTheme.bar(
                          // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('SONRA', style: TextStyle(color: Colors.black45)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: const Text('GÖZAT'),
                                onPressed: () {
                                  if (successRoute == null) {
                                    Navigator.of(context).pop();
                                  } else {
                                    Navigator.of(context).popAndPushNamed(successRoute, arguments: successRouteArgs);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }

  static Future<void> alert(BuildContext context, String title, String message) async {
    title = null;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 18),
            child: Text(message, style: AppTheme.textAlertBodyGray()),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PositiveActionButton(
                    child: Text("Tamam", style: AppTheme.textButtonPositive()),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }



  static Future<void> confirm(BuildContext context, String title, String message, Function _then) async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            PlatformDialogAction(
              child: Text("Vazgeç"),
              onPressed: () {
                Navigator.of(context).pop("CANCEL");
              },
            ),
            PlatformDialogAction(
              child: Text("Tamam"),
              onPressed: () {
                print("ALALALALALALA");
                Navigator.of(context).pop("ACCEPT");
                _then();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget indicator(BuildContext context) {
    return new Stack(
      children: [
        Opacity(
          opacity: 0.6,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: PlatformCircularProgressIndicator(),
        ),
      ],
    );
  }

  static Widget aotIndicator(BuildContext context) {
    return new Stack(
      children: [
        Opacity(
          opacity: 0.6,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Image(
              width: 52.0,
              height: 52.0,
              image: AssetImage("assets/img/loader.gif"),
            ),
          ),
        ),
      ],
    );
  }

  static Widget lock() {
    return Stack(
      children: [
        new Opacity(
          opacity: 0.4,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
      ],
    );
  }

  /// Use instance  with SingleTickerProviderStateMixin
  static Widget floatingActionButtons(
      BuildContext context, AnimationController _animationController, List<FloatingActionButtonItem> items) {
    List<Widget> children = new List();

    if (items.length < 2) {
      FloatingActionButtonItem fab = items[0];
      return FloatingActionButton(
        heroTag: null,
        backgroundColor: fab.foreGroundColor ?? Theme.of(context).primaryColor,
        child: new Icon(fab.icon, color: fab.backGroundColor ?? Theme.of(context).buttonColor),
        onPressed: () {
          _animationController.reverse();
          //Navigator.pop(context);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => fab.func())).then((v) {
            if (fab.then != null) {
              fab.then(v);
            }
          });
        },
      );
    }
    //when you need a menu for items :)

    for (int index = 0; index < items.length; index++) {
      FloatingActionButtonItem fab = items[index];
      Widget child = new Container(
        height: 70.0,
        width: 56.0,
        alignment: FractionalOffset.topCenter,
        child: new ScaleTransition(
          scale: new CurvedAnimation(
            parent: _animationController,
            curve: new Interval(
              0.0,
              1.0 - index / items.length / 2.0,
              curve: Curves.linear,
            ),
          ),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: fab.foreGroundColor,
            child: new Icon(fab.icon, color: fab.backGroundColor),
            onPressed: () {
              _animationController.reverse();
              //Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => fab.func())).then((v) {
                if (fab.then != null) {
                  fab.then(v);
                }
              });
            },
          ),
        ),
      );
      children.add(child);
    }

    children.add(FloatingActionButton(
      heroTag: null,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform: new Matrix4.rotationZ(_animationController.value * 0.5 * math.pi),
            alignment: FractionalOffset.center,
            child: new Icon(_animationController.isDismissed ? Icons.menu : Icons.close),
          );
        },
      ),
      onPressed: () {
        if (_animationController.isDismissed) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
    ));

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
