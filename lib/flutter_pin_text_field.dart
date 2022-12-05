library flutter_pin_text_field;

import 'package:flutter/material.dart';

enum PinTextFieldBorderType { Underline, Outline }

class PinTextFieldItem extends StatefulWidget {
  double height;
  double width;
  Color cursorColor;
  Color fontColor;
  double fontSize;
  Color borderColor;
  Color focusBorderColor;
  double borderWidth;
  double focusBorderWidth;
  PinTextFieldBorderType borderType;
  void Function(String, FocusNode)? onChanged;
  int index;
  PinTextFieldItem(
      {Key? key,
      required this.index,
      required this.cursorColor,
      required this.height,
      required this.width,
      required this.fontColor,
      required this.fontSize,
      required this.borderColor,
      required this.focusBorderColor,
      required this.borderWidth,
      required this.focusBorderWidth,
      required this.borderType,
      this.onChanged})
      : super(key: key);
  @override
  State<PinTextFieldItem> createState() => _PinTextFieldItemState();
}

class _PinTextFieldItemState extends State<PinTextFieldItem> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: TextField(
        focusNode: focusNode,
        onChanged: ((value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value, focusNode);
          }
        }),
        maxLength: 1,
        keyboardType: TextInputType.number,
        cursorColor: widget.cursorColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          counterText: "",
          enabledBorder: widget.borderType == PinTextFieldBorderType.Underline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.borderColor, width: widget.borderWidth),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.borderColor, width: widget.borderWidth)),
          focusedBorder: widget.borderType == PinTextFieldBorderType.Underline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.focusBorderColor,
                      width: widget.focusBorderWidth),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.focusBorderColor,
                      width: widget.focusBorderWidth)),
        ),
        textAlign: TextAlign.center,
        controller: controller,
        style: TextStyle(color: widget.fontColor, fontSize: widget.fontSize),
      ),
    );
  }
}

class PinTextField extends StatefulWidget {
  int count;
  double height;
  double width;
  Color cursorColor;
  Color fontColor;
  double fontSize;
  double borderWidth;
  Color borderColor;
  double focusBorderWidth;
  Color focusBorderColor;
  PinTextFieldBorderType borderType;
  String finishedStringSeparator;
  void Function(String)? onFinished;
  PinTextField(
      {Key? key,
      this.count = 6,
      this.height = 42.0,
      this.width = 42.0,
      this.cursorColor = const Color.fromRGBO(255, 96, 10, 1),
      this.fontColor = const Color.fromRGBO(0, 0, 0, 1),
      this.fontSize = 16,
      this.borderWidth = 1.0,
      this.borderColor = const Color.fromRGBO(204, 204, 204, 1),
      this.focusBorderWidth = 1.0,
      this.focusBorderColor = const Color.fromRGBO(100, 105, 110, 1),
      this.borderType = PinTextFieldBorderType.Underline,
      this.finishedStringSeparator = "",
      this.onFinished})
      : super(key: key);
  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  List<int?> intList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intList = List.generate(widget.count, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              widget.count,
              (index) => PinTextFieldItem(
                    index: index,
                    borderWidth: widget.borderWidth,
                    focusBorderWidth: widget.focusBorderWidth,
                    cursorColor: widget.cursorColor,
                    height: widget.height,
                    width: widget.width,
                    focusBorderColor: widget.focusBorderColor,
                    borderColor: widget.borderColor,
                    fontColor: widget.fontColor,
                    borderType: widget.borderType,
                    fontSize: widget.fontSize,
                    onChanged: (value, focusNode) {
                      if (value != "") {
                        intList[index] = int.parse(value);
                        if (index < widget.count - 1) {
                          focusNode.nextFocus();
                        }
                      } else {
                        intList[index] = null;
                        if (index > 0) {
                          focusNode.previousFocus();
                        }
                      }
                      var array =
                          intList.where((element) => element != null).toList();
                      if (array.length == widget.count) {
                        if (widget.onFinished != null) {
                          var numberList = array.map((e) => e ?? 0).toList();
                          var string =
                              numberList.join(widget.finishedStringSeparator);
                          widget.onFinished!(string);
                          focusNode.unfocus();
                        }
                      }
                    },
                  ))),
    );
  }
}
