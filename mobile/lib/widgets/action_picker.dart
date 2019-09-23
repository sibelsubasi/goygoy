import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/data.dart';

Future<dynamic> showActionPicker({BuildContext context, List<String> preSelectedItems}) async {
  double screenHeight = MediaQuery.of(context).size.height;

  List<Map> items = DATA_ALL_ACTIONS;
  double scrProp = screenHeight * 0.6;
  double itmProp = items.length * 70.0;
  double popupHeight = min(scrProp, itmProp);

  return await showCupertinoModalPopup<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: popupHeight,
        padding: const EdgeInsets.only(top: 6.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(25, 25),
            topRight: Radius.elliptical(25, 25),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 22.0,
          ),
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
              top: false,
              child: Card(
                child: Stack(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "İşlem Seçin",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Divider(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.3),
                        itemCount: items.length + 2,
                        itemBuilder: (BuildContext context, int index) {
                          if (index > items.length -1) {
                            return SizedBox(height: 10);
                          }
                          bool c = preSelectedItems.contains(items[index]['key']);
                          Widget iconWidget;
                          if (items[index]['asset'].runtimeType.toString() == "Icon") {
                            if (c) {
                              iconWidget = Icon(items[index]['asset'].icon, color:Config.COLOR_DEACTIVE_GRAY);
                            } else {
                              iconWidget = items[index]['asset'];
                            }
                          } else {
                            iconWidget = Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(items[index]['asset']),
                                  colorFilter: c ? ColorFilter.mode(Colors.white, BlendMode.color) : null,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () => c ? null : Navigator.of(context).pop(items[index]['key']),
                            child: GridTile(
                              child: iconWidget,
                              footer: Text(
                                items[index]['label'],
                                style: c ? AppTheme.textTabPassive() : AppTheme.textTabActive(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
