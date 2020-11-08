import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/widgets/testFormUppCase.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class InputWidget extends StatelessWidget {
  final ValueChanged<dynamic> methodOnPressed;
  final ValueChanged<dynamic> methodOnChange;
  final TextEditingController controller;
  final FocusNode focusInput;
  final IconData iconSufix;
  final IconData iconPrefix;
  final String hinttext;
  final TextAlign align;
  final String title;
  final VoidCallback methodOnPressedSufix;

  const InputWidget(
      {Key key,
      this.methodOnPressed,
      @required this.controller,
      @required this.focusInput,
      @required this.hinttext,
      this.methodOnChange,
      this.align,
      this.iconSufix,
      this.iconPrefix,
      this.title,
      this.methodOnPressedSufix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        title != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 5, top: 10),
                child: Text(title, style: TextStyle(fontSize: 15)),
              )
            : Container(),
        Container(
            margin: title == null ? const EdgeInsets.only(top: 10) : null,
            child: TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: controller,
              textInputAction: TextInputAction.done,
              textAlign: align == null ? TextAlign.start : TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              focusNode: focusInput,
              onFieldSubmitted: methodOnPressed == null
                  ? null
                  : (value) {
                      methodOnPressed(value);
                    },
              onChanged: methodOnChange == null
                  ? null
                  : (value) {
                      methodOnChange(value);
                    },
              decoration: InputDecoration(
                  prefixIcon: iconPrefix == null
                      ? null
                      : Icon(
                          iconPrefix,
                          color: StylesThemeData.INPUT_PREFIX_COLOR,
                        ),
                  suffixIcon: iconSufix == null
                      ? null
                      : GestureDetector(
                          onTap: () {
                            if (methodOnPressedSufix != null)
                              methodOnPressedSufix();
                          },
                          child: Icon(iconSufix,
                            size: 20,
                            color: StylesThemeData.PRIMARY_COLOR,
                          ),
                        ),
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  filled: true,
                  fillColor: StylesThemeData.INPUT_COLOR,
                  errorStyle: TextStyle(
                      color: StylesThemeData.INPUT_ERROR_COLOR, fontSize: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: StylesThemeData.INPUT_ENFOQUE_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: StylesThemeData.INPUT_BORDER_COLOR,
                      width: 0.0,
                    ),
                  ),
                  hintText: hinttext,
                  hintStyle:
                      TextStyle(color: StylesThemeData.INPUT_HINT_COLOR)),
            ))
      ],
    ));
  }
}
