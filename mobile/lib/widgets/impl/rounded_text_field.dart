// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile/commons/config.dart';

class RoundedTextField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool autovalidate;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder buildCounter;
  final Widget prefix;
  final Widget suffix;
  final String suffixText;
  final bool filled;
  final Color fillColor;


  const RoundedTextField({
    Key key,
    this.labelText,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.autovalidate = false,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.buildCounter,
    this.prefix,
    this.suffix,
    this.suffixText,
    this.filled = false,
    this.fillColor = Config.COLOR_WHITE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
        labelText: this.labelText,
        labelStyle: TextStyle(color: Config.COLOR_LIGHT_GRAY),
        filled: filled,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Config.COLOR_LIGHT_GRAY),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Config.COLOR_PALE_LILAC),
          borderRadius: BorderRadius.circular(30),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Config.COLOR_PALE_LILAC),
        ),
        prefixIcon: this.prefix,
        suffix: this.suffix,
        suffixText: this.suffixText,
    );

    return TextFormField(
      initialValue: this.initialValue,
      focusNode: this.focusNode,
      decoration: decoration,
      keyboardType: this.keyboardType,
      textCapitalization: this.textCapitalization,
      textInputAction: this.textInputAction,
      style: this.style,
      textDirection: this.textDirection,
      textAlign: this.textAlign,
      autofocus: this.autofocus,
      obscureText: this.obscureText,
      autocorrect: this.autocorrect,
      autovalidate: this.autovalidate,
      maxLengthEnforced: this.maxLengthEnforced,
      maxLines: this.maxLines,
      maxLength: this.maxLength,
      onEditingComplete: this.onEditingComplete,
      onFieldSubmitted: this.onFieldSubmitted,
      onSaved: this.onSaved,
      validator: this.validator,
      inputFormatters: this.inputFormatters,
      enabled: this.enabled,
      cursorWidth: this.cursorWidth,
      cursorRadius: this.cursorRadius,
      cursorColor: this.cursorColor,
      keyboardAppearance: this.keyboardAppearance,
      scrollPadding: this.scrollPadding,
      enableInteractiveSelection: this.enableInteractiveSelection,
      buildCounter: this.buildCounter,
    );
  }
}
