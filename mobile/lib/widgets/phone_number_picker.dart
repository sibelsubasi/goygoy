import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/data.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> showActionPicker(
    {BuildContext context, List<Map> phoneNumberItems}) async {
  double screenHeight = MediaQuery.of(context).size.height;
  print(phoneNumberItems);

  List<Map> items = phoneNumberItems;
  double scrProp = screenHeight * 0.6;
  double itmProp = items.length * 90.0;
  if(items.length==1){
    itmProp=180.0;
  }
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
                        "Telefon Numaraları",
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2.3),
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: GridTile(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: GestureDetector(
                                      child: Icon(
                                      Icons.phone,
                                      color: items[index]['callableFlag'] == "N" ? Config.COLOR_BLACK : Config.COLOR_MEDIUM_GREEN,
                                      size: 24,
                                      ),
                                  onTap: () {
                                    items[index]['callableFlag'] == "Y" ? launch("tel:${items[index]['phoneNumber']}"): print("No calling");
                                  }
                                ),
                              ),
                              footer: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text(
                                        items[index]['type'],style:  AppTheme.textPhonePickerPassive(),textAlign: TextAlign.center,
                                      ),
                                      onTap: () => items[index]['callableFlag'] =="Y" ? launch("tel:${items[index]['phoneNumber']}"): print("No calling"),
                                    ),
                                    GestureDetector(
                                      child: Text(items[index]['phoneNumber'],style: AppTheme.textPhonePickerPassive(),textAlign: TextAlign.center,
                                      ),
                                      onTap: () => items[index]['callableFlag'] == "Y" ? launch("tel:${items[index]['phoneNumber']}"): print("No calling"),
                                    ),
                                  ],
                                ),
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
