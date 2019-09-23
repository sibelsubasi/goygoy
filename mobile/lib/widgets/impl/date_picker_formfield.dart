// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';

//import 'package:mobile/dynamic_theme.dart';
//import 'package:mobile/turkish_cupertino_localizations.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class DatePickerFromField extends StatefulWidget {
  String labelText;
  String initialLabelText;
  final Widget icon;
  final Function onChanged;
  final Function validator;
  final Function onSaved;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Locale locale;
  final Color borderColor;

  DatePickerFromField(
      {this.labelText,
      this.initialLabelText,
      this.icon,
      this.onChanged,
      this.validator,
      this.onSaved,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      this.locale,
      this.borderColor = const Color(0xFFBCBBC1)});

  @override
  State<StatefulWidget> createState() {
    return _DatePickerFormFieldState();
  }
}

class _DatePickerFormFieldState extends State<DatePickerFromField> {
  DateTime _currentDate;
  DateTime _firstDate;
  DateTime _lastDate;
  Locale _locale;

  GlobalKey<FormFieldState> _fieldKey = new GlobalKey<FormFieldState>();

  @override
  initState() {
    _currentDate = widget.initialDate;
    _firstDate = widget.firstDate;
    _lastDate = widget.lastDate;
    _locale = widget.locale;

    if (_currentDate == null) {
      //_currentDate = DateTime.now();
    }
    if (_firstDate == null) {
      _firstDate = DateTime.now().subtract(Duration(days: 365));
    }
    if (_lastDate == null) {
      _lastDate = DateTime.now().add(Duration(days: 365));
    }
    if (_locale == null) {
      _locale = Locale("tr");
    }
    super.initState();
  }

  DateTime picked;
  Future<void> _selectDate(FormFieldState state) async {
    //DateTime picked;
    //TODO:Plafform testing
    if (Config.DEF_PREF_LOOK_AND_FEEL == "android") {
      _currentDate = DateTime.now();
      picked = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: _firstDate,
        lastDate: _lastDate,
        locale: _locale,
      );

      setState(() {
        if (widget.labelText == widget.initialLabelText) {
          if (picked == null) {
            widget.labelText = DateFormat.yMMMMd("tr_TR").format(DateTime.now());
            picked = DateTime.now();
            widget.onChanged(picked);
          } else {
            widget.onChanged(picked);
          }
          state.didChange(picked);
        } else {
          _currentDate = picked;
          widget.onChanged(_currentDate);
        }
      });

    } else {
//      print('ios');
//      print("_lastDate:" + _lastDate.toIso8601String());
//      print("_firstDate:" + _firstDate.toIso8601String());
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              maximumDate: _lastDate,
              minimumDate: _firstDate,
              maximumYear: _lastDate.year,
              minimumYear: _firstDate.year,
              initialDateTime: _currentDate,
              onDateTimeChanged: (DateTime newDateTime) {
                //print("changed" + newDateTime.toIso8601String());
                setState(() {
                  picked = newDateTime;
                });
              },
            ),
          );
        },
      );
    }
    if (picked != null && picked != _currentDate) {
      _currentDate = picked;
      state.didChange(picked);
      if (widget.onChanged != null) {
        widget.onChanged(_currentDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _fieldKey,
      onSaved: (val) {
        _fieldKey.currentState.didChange(val);
        setState(() {
          _currentDate = val;
        });
        print('fieldSaved: ${val}');
        if (widget.onSaved != null) {
          widget.onSaved(_currentDate);
        }
      },
      validator: widget.validator,
      initialValue: _currentDate,
      builder: (FormFieldState state) {
        return InkWell(
          onTap: () => _selectDate(state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: state.hasError
                        ? Config.COLOR_VALIDATION_ERROR
                        : widget.borderColor,
                  ),
                ),
                height: 64.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Text(DateFormat.yMMMd("tr_TR").format(state.value)),
                      Text(widget.labelText),
                      //, style: valueStyle
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade700
                            : Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
              state.hasError
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
                      child: Text(
                        state.hasError ? state.errorText : "",
                        style: TextStyle(
                            color: Config.COLOR_VALIDATION_ERROR, fontSize: 12),
                      ),
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {
            setState(() {
              if (widget.labelText == widget.initialLabelText) {
                if (picked == null) {
                  widget.labelText = DateFormat.yMMMMd("tr_TR").format(DateTime.now());
                  picked = DateTime.now();
                  widget.onChanged(picked);
                } else {
                  widget.onChanged(picked);
                }
              } else {
                _currentDate = picked;
                widget.onChanged(_currentDate);
              }
            });
          },
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
