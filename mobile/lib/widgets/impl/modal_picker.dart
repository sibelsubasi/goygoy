// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/impl/positive_action_button.dart';

class ModalPicker extends StatelessWidget {
  final Color borderColor;
  final String label;
  final ValueChanged<dynamic> valueChanged;
  final List<DropdownMenuItem> items;
  final Function validator;
  final Widget childWidget;
  final initialValue;
  final Function onSaved;

  const ModalPicker(
      {Key key, this.borderColor = const Color(0xFFBCBBC1), this.label, this.valueChanged, this.items, this.validator, this.childWidget, this.initialValue, this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget labelToPrint = Text(this.label);

    return FormField(
        validator: this.validator,
        initialValue: this.initialValue,
        onSaved: (val) {
            if (this.onSaved != null) {
              this.onSaved(val);
            }
        },
        builder: (FormFieldState state) {
          if (state.value != null && this.items != null) {
            var res = this.items.where((it) => it.value == state.value).toList();
            if (res.length > 0) {
              labelToPrint = res[0].child;
            }
          }
          if (childWidget != null) {
            return GestureDetector(
              onTap: () async => await _showModalDialog(context, state),
              child: childWidget,
            );
          }
          return GestureDetector(
            onTap: () async => await _showModalDialog(context, state),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      //color: borderColor,
                      color: state.hasError ? Config.COLOR_VALIDATION_ERROR : borderColor,
                    ),
                  ),
                  height: 64.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text((labelToPrint as Text).data, overflow: TextOverflow.ellipsis),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: CupertinoColors.inactiveGray,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                state.hasError
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
                        child: Text(
                          state.hasError ? state.errorText : "",
                          style: TextStyle(color: Config.COLOR_VALIDATION_ERROR, fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }

  Future<dynamic> _showModalDialog(BuildContext context, FormFieldState state) async {
    double scrProp = MediaQuery.of(context).size.height * 0.6;
    double itmProp = items.length * 140.0;
    double popupHeight = min(scrProp, itmProp);

    await showCupertinoModalPopup<dynamic>(
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
                        title:
                            Text(label, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Divider(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        child: ListView(
                          children: _buildItems(context, state),
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

  List<Widget> _buildItems(BuildContext context, FormFieldState state) {
    List<Widget> wg = List();
    items.forEach((e) {
      wg.addAll([
        ListTile(
          onTap: () {
            print("clickked ${e.value}");
            state.didChange(e.value);
            if (valueChanged != null) {
              valueChanged(e.value);
            }
            Navigator.pop(context);
          },
          title: Align(alignment: Alignment.center, child: e.child),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Divider(),
        ),
      ]);
    });
    return wg;
  }
}
