import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/Classes/testFormUppCase.dart';
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
  final int linesInput;
  final VoidCallback methodOnPressedSufix;
  final bool visibilityTextForm;
  final String Function(dynamic) validadorInput;
  final bool modoLabel;

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
      this.methodOnPressedSufix,
      this.visibilityTextForm,
      this.validadorInput,
      this.linesInput, this.modoLabel})
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
              keyboardType: linesInput == null
                  ? TextInputType.text
                  : TextInputType.multiline,
              autofocus: false,
              maxLines: linesInput == null ? 1 : linesInput,
              validator: validadorInput,
              controller: controller,
              obscureText:
                  visibilityTextForm == null ? false : visibilityTextForm,
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
                          child: Icon(
                            iconSufix,
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
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: StylesThemeData.INPUT_ERROR_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: StylesThemeData.INPUT_BORDER_COLOR,
                      width: 0.0,
                    ),
                  ),
                  labelText: this.modoLabel==null || this.modoLabel==false? null:hinttext,
                  hintText:this.modoLabel==null || this.modoLabel==false? hinttext:null,
                  hintStyle:
                      TextStyle(color: StylesThemeData.INPUT_HINT_COLOR)),
            ))
      ],
    ));
  }
}
