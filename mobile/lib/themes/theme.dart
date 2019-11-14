// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';

abstract class AppTheme {
  static TextStyle textHeaderStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_WHITE,
      fontSize: 25,
    );
  }

  static TextStyle textPageTitleStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w400,
      color: Config.COLOR_LIGHT_GRAY,
      fontSize: 21,
    );
  }

  static TextStyle textPageTitleWhiteStyle() {
    return TextStyle(
      color: Color(0XFFFFFFFF),
      fontSize: 17,
    );
  }

  static TextStyle textPageTitleDarkStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_DARK_GRAY,
      fontSize: 30,
    );
  }

  static TextStyle textBlueGrayStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY,
      fontSize: 12,
    );
  } //

  static TextStyle textCaptionWhite() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.normal,
      color: Config.COLOR_WHITE,
      fontSize: 20,
      letterSpacing: 0.5,
    );
  }

  static TextStyle textBodyWhite() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.normal,
      color: Config.COLOR_WHITE,
      fontSize: 14,
      letterSpacing: 0.5,
    );
  }

  static TextStyle textBodyLight() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.normal,
      color: Config.COLOR_LIGHT_GRAY,
      fontSize: 14,
      letterSpacing: 0.4,
    );
  }

  static TextStyle textBodyLightBlue() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.normal,
      color: Config.COLOR_LIGHT_GREEN,
      fontSize: 14,
      letterSpacing: 0.4,
    );
  }

  static TextStyle textBodyGreenBold() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_MEDIUM_GREEN,
      fontSize: 14,
      letterSpacing: 0.4,
    );
  }

  static TextStyle textBodyGreenBold16() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_MEDIUM_GREEN,
      fontSize: 16,
    );
  }

  static TextStyle textBodyLightBold() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_LIGHT_GRAY,
      fontSize: 14,
      letterSpacing: 0.4,
    );
  }

  static TextStyle textBodyDarkGray() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_DARK_GRAY,
      fontSize: 14,
    );
  }

  static TextStyle textBodyDarkGrayBold() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_DARK_GRAY,
      fontSize: 14,
    );
  }

  static TextStyle textBodyDarkGrayMiddle() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_DARK_GRAY,
      fontSize: 16,
    );
  }

  static TextStyle textBodyBiggerGray() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY_VAR_2,
      fontSize: 16,
    );
  }

  static TextStyle textAlertBodyGray() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY_VAR_2,
      fontSize: 14,
    );
  }

  static TextStyle textBodyMid() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.normal,
      color: Config.COLOR_MID_GRAY,
      fontSize: 14,
      letterSpacing: 0.5,
    );
  }

  static TextStyle textMuted() {
    return TextStyle(
      color: Config.COLOR_WHITE,
      fontFamily: "Rubik-Light",
      fontSize: 16,
    );
  }

  static TextStyle textMutedGray() {
    return TextStyle(
      color: Config.COLOR_MID_GRAY,
      fontFamily: "Rubik-Light",
      fontSize: 16,
    );
  }

  static TextStyle textButtonPositive() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_WHITE,
      fontSize: 14,
    );
  }

  static TextStyle textButtonNegative() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY,
      fontSize: 15,
    );
  }

  static TextStyle textTabActive() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_ORANGE_DARK,
      fontSize: 12,
    );
  }

  static TextStyle textTabPassive() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY,
      fontSize: 12,
    );
  }

  static TextStyle textHint() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_LIGHT_GRAY,
      fontSize: 14,
    );
  }

  static TextStyle textHintWhite() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_WHITE,
      fontSize: 12,
    );
  }

  static TextStyle textListDefaultBody() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_TEXT_DEFAULT_DARK,
      fontSize: 15,
    );
  }

  static TextStyle textListSummary() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w600,
      color: Config.COLOR_GRADIENT_END,
      fontSize: 12,
    );
  }

  static TextStyle textListDefaultBody12() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_TEXT_DEFAULT_DARK,
      fontSize: 12,
    );
  }

  static TextStyle textListDefaultSubBody() {
    return TextStyle(
      fontFamily: "Rubik-Light",
      color: Config.COLOR_BLUE_GRAY,
      fontSize: 15,
    );
  }

  static TextStyle textModalItem() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_ORANGE_DARK,
      fontSize: 14,
    );
  }

  static TextStyle textValidationError() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Colors.red[700],
      fontSize: 12,
    );
  }

  static TextStyle textPhonePickerPassive() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_BLUE_GRAY_VAR_2,
      fontSize: 13,
    );
  }

  static TextStyle textListDescription() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w600,
      color: Config.COLOR_GRADIENT_END,
      fontSize: 14,
    );
  }

  static TextStyle textBodyLightBold16() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_LIGHT_GRAY,
      fontSize: 16,
      letterSpacing: 0.4,
    );
  }

  static TextStyle textHintGreen() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_MEDIUM_GREEN,
      fontSize: 12,
    );
  }

  static TextStyle textListDefaultBody2() {
    return TextStyle(
      fontFamily: "Rubik",
      fontWeight: FontWeight.w500,
      color: Config.COLOR_TEXT_DEFAULT_DARK,
      fontSize: 16,
    );
  }

  static TextStyle textSurveyTitleDarkStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_DARK_GRAY,
      fontSize: 22,
    );
  }

  static TextStyle textSurveyCardDarkStyle() {
    return TextStyle(
      fontFamily: "Rubik",
      color: Config.COLOR_DARK_GRAY,
      fontSize: 18,
    );
  }
}
