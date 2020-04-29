import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class ReusableWidgets {

  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());


  static getAppBar(String title) {
    return AppBar(
          backgroundColor: primaryColor,
          title: Text('$title',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
    );
  }





}