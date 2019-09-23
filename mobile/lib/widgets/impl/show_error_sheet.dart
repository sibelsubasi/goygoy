import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/exceptions/exceptions.dart';
import 'package:mobile/widgets/impl/message_with_image.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

Future<void> showErrorSheet({BuildContext context, dynamic error}) async {
  double popupHeight = 160;

  print('============================================================================================>Error');
  print(error is ControlledException ? "is a Controlled Exception" : "Uncontrolled Exception");
  print(error.toString());

  var stackTrace;
  try {
    if (error.stackTrace != null) {
      stackTrace = error.stackTrace;
      print("Stack Trace: \n");
      print(error.stackTrace.toString());
    }
  }
  on NoSuchMethodError {
    //skip, just does not has stack trace
  }


  if (!(error is ControlledException)) {
    FlutterCrashlytics().logException(error, stackTrace);
    if (!Config.DEBUG) {
      error = "Bir hata oluştu.";
    }
  }
  print('Error<============================================================================================');


  return await showCupertinoModalPopup<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: popupHeight,
        padding: const EdgeInsets.only(top: 7.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.elliptical(25, 25),
            topLeft: Radius.elliptical(25, 25),
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
                elevation: 0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: MessageWithImage(
                        width: 90,
                        height: 90,
                        path: 'assets/img/errorIcon.png',
                        title: error.toString(),
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
