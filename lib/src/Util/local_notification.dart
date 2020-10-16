

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void showNotification( v, flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max, ticker: 'ticker');
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);
  await flp.show(0, 'EXACT', '$v', platform,
      payload: '$v');
}