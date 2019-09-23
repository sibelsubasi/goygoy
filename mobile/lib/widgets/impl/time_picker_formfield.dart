import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mobile/commons/config.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class TimePickerFormField extends StatefulWidget {
  String labelText;
  String pickerText;
  final Widget icon;
  final Function onChanged;
  final Function validator;
  final Function onSaved;
  final TimeOfDay initialTime;
  final TimeOfDay firstTime;
  final TimeOfDay lastTime;
  final Color borderColor;


  // final Locale locale; /todo: for now timepickers does not support localization.

  TimePickerFormField({
    this.labelText,
    this.pickerText,
    this.icon,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.initialTime,
    this.firstTime,
    this.lastTime,
    //this.locale,
    this.borderColor = const Color(0xFFBCBBC1)});

  @override
  State<StatefulWidget> createState() {
    return _TimePickerFormFieldState();
  }
}

class _TimePickerFormFieldState extends State<TimePickerFormField> {
  TimeOfDay _currentTime;
  TimeOfDay _firstTime;
  TimeOfDay _lastTime;

  //Locale _locale;

  @override
  initState() {
    _currentTime = widget.initialTime;
    _firstTime = widget.firstTime;
    _lastTime = widget.lastTime;
    //_locale = widget.locale;

    if (_currentTime == null) {
      //_currentTime = TimeOfDay.now();
    }
    /*
    if (_firstTime == null) {
      _firstTime = TimeOfDay.now();
    }
    if (_lastTime == null) {
      _lastTime = TimeOfDay.now();
    }
    */
//    if (_locale == null) {
//      _locale = Locale("tr");
//    }
    super.initState();
  }

  TimeOfDay picked;
  Future<void> _selectTime(FormFieldState state) async {
    //TimeOfDay picked;
    if (Config.DEF_PREF_LOOK_AND_FEEL == "android") {
      _currentTime = TimeOfDay.now();
      picked = await showTimePicker(
        context: context,
        initialTime: _currentTime,
        //locale: _locale
      );

      setState(() {
        if (widget.labelText == widget.pickerText) {
          if (picked == null) {
            widget.labelText = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).toString();
            picked = TimeOfDay.now();
            widget.onChanged(picked);
          } else {
            widget.onChanged(picked);
          }
          state.didChange(picked);
        } else {
          _currentTime = picked;
          widget.onChanged(_currentTime);
        }
      });


    } else {
      final now = new DateTime.now();

      await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              //maximumDate: _lastDate,
              //minimumDate: _firstDate,
              initialDateTime: DateTime.now(),
              use24hFormat: true,
              minuteInterval: 1,
              onDateTimeChanged: (DateTime newDateTime) {
                //print("changed" + newDateTime.toIso8601String());
                setState(() {
                  picked = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                  state.didChange(picked);
                });
              },
            ),
          );
        },
      );
    }
    if (picked != null && picked != _currentTime) {
      _currentTime = picked;
      state.didChange(picked);
      if (widget.onChanged != null) {
        widget.onChanged(_currentTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      onSaved: (val) => widget.onSaved,
      validator: widget.validator,
      initialValue: _currentTime,
      builder: (FormFieldState state) {
        return InkWell(
          onTap: () => _selectTime(state),
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
                        Icons.access_time,
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
              if (widget.labelText == widget.pickerText) {
                if (picked == null) {
                  widget.labelText = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).toString();
                  picked = TimeOfDay.now();
                  widget.onChanged(picked);
                } else {
                  widget.onChanged(picked);
                }
              } else {
                _currentTime = picked;
                widget.onChanged(_currentTime);
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