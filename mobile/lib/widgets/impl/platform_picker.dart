// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_platform_widgets/src/widget_base.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DropdownButton;
import 'package:flutter/widgets.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class CupertinoPickerData {
  final Key key;
  final double diameterRatio; // = _kDefaultDiameterRatio;
  final Color backgroundColor; // = _kDefaultBackground;
  final double offAxisFraction; // = 0.0;
  final bool useMagnifier; // = false;
  final double magnification; // = 1.0;
  final FixedExtentScrollController scrollController;
  final double itemExtent;
  final ValueChanged<int> onSelectedItemChanged;
  final List<Widget> children;
  final bool looping; //false

  CupertinoPickerData(this.key, this.diameterRatio, this.backgroundColor, this.offAxisFraction, this.useMagnifier, this.magnification,
      this.scrollController, this.itemExtent, this.onSelectedItemChanged, this.children, this.looping);
}

class DropdownButtonData {
  final Key key;

  final List<DropdownMenuItem> items;
  final value;
  final Widget hint;
  final Widget disabledHint;
  final ValueChanged onChanged;
  final int elevation; // = 8,
  final TextStyle style;
  final double iconSize; // = 24.0,
  final bool isDense; // = false,
  final bool isExpanded; //false

  DropdownButtonData(this.key, this.items, this.value, this.hint, this.disabledHint, this.onChanged, this.elevation, this.style,
      this.iconSize, this.isDense, this.isExpanded);
}

class PlatformPicker extends PlatformWidgetBase<Widget, Widget> {
  Key widgetKey;
  final List<DropdownMenuItem> items;
  final String label;
  int selectedItem;
  final Function onChanged;
  final Function validator;
  final Function onSaved;
  final Color borderColor;

  PlatformPicker(
      {Key key,
      this.onChanged,
      this.validator,
      this.borderColor = const Color(0xFFBCBBC1),
      this.onSaved,
      this.widgetKey,
      this.label,
      this.items,
      this.selectedItem})
      : super(key: key);

  @override
  Widget createAndroidWidget(BuildContext context) {
    //   var textStyleHint = Theme.of(context).textTheme.caption.copyWith(color: Colors.black12, fontSize: 12.0);
    return FormField(
      initialValue: selectedItem,
      onSaved: (val) => onSaved,
      validator: validator,
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          //isEmpty: widget.value == '' || widget.value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: items,
              hint: Text(this.label),
              value: state.value,
              isDense: true,
              isExpanded: true,
              onChanged: (dynamic newValue) {
                print("newValue: ${newValue}");
                state.didChange(newValue);
                // widget.onChanged != null ? widget.onChanged(newValue) : null;
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget createIosWidget(BuildContext context) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: selectedItem ?? 0);

    return FormField(
      initialValue: selectedItem,
      onSaved: (val) => onSaved,
      validator: validator,
      builder: (FormFieldState state) {
        return GestureDetector(
          onTap: () async {
            await showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
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
                      onTap: () {},
                      child: SafeArea(
                        top: false,
                        child: CupertinoPicker(
                          scrollController: scrollController,
                          itemExtent: _kPickerItemHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            state.setState(() => selectedItem = index);
                            //selectedItem = index;
                          },
                          children: List<Widget>.generate(items.length, (int index) {
                            return Center(
                              child: items[index].child,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: borderColor,
              ),
            ),
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedItem != null ? items[selectedItem].child : Text(this.label),
                    Icon(
                      Icons.arrow_drop_down,
                      color: CupertinoColors.inactiveGray,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
