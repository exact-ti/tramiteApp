import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/widgets/testFormUppCase.dart';

class InputForm extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController controller;
  final FocusNode fx;
  final String hinttext;
  final TextAlign align;
  final VoidCallback onChanged;

  const InputForm({
    Key key,
    this.onPressed,
    @required this.controller,
    @required this.fx,
    @required this.hinttext,
    this.onChanged,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controller,
      textInputAction: TextInputAction.done,
      textAlign: align==null?TextAlign.start:TextAlign.center,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      focusNode: fx,
      onFieldSubmitted: onPressed==null ? null :(value) {
        onPressed();
      },
      onChanged: onChanged==null ? null :(value) {
        onChanged();
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
        hintText: hinttext,
      ),
    );
  }
}
