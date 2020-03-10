// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tramiteapp/src/Login/LoginController.dart';


void main() {
    test('Exitoso', () {
      LoginController login = new LoginController();
       Future<String> sdf = login.enviarmensaje("kvega","123457");
       expect("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub21icmUiOiJrYXR0eSIsInBlcmZpbCI6InVzdWFyaW8gQkNQIiwic2VkZSI6eyJpZCI6IjIiLCJub21icmUiOiJTYW50YSBSYXF1ZWwifX0.iMgbN00PixD6wb_0t17wt5G2mIaP-dKpU3yXbCxXQPI",sdf);  
    });
}