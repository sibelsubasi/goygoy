import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile/widgets/dialogs.dart';

class RouteItem {
  final String route;
  final Map<String, dynamic> params;

  RouteItem(this.route, this.params);
}

class FCM {

  RouteItem getRouteWithParamsFromMessage(Map message) {
    String page = message['page'].toString();
    String id = message['id'].toString();

    switch (page) {
      case 'ONBOARD': //onboard page
        return RouteItem("/welcome/onboard", {'page': page, 'id': id});
      case 'PHOTO': //photo page
        return RouteItem("/login/photo", {'page': page, 'id': id});
      default:
        return RouteItem(null, null);
    }
  }

  void register(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.configure(

      //{
      //  notification: {
      //    body: Emre Uğraşkan 19.11.2018 08:00 - 20.11.2018 08:00 tarihleri arasında Babalık İzni kullanmak istiyor.,
      //    title: İzin Onay Talebi
      //  },
      //  data: {
      //    click_action: FLUTTER_NOTIFICATION_CLICK,
      //    p_type: 1585
      //  }
      //}

      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        RouteItem r = getRouteWithParamsFromMessage(message['data']);
        Dialogs.banner(context, message['notification']['title'], message['notification']['body'], r.route, r.params);
        //Dialogs.banner(context, message['notification']['title'], message['notification']['body'], null, null);
      },

      //{
      //    google.sent_time: 1542590229189,
      //    click_action: FLUTTER_NOTIFICATION_CLICK,
      //    google.original_priority: normal,
      //    collapse_key: tr.com.partnera.mobile,
      //    google.delivered_priority: normal,
      //    from: 581719827308,
      //    line_id: 1587,
      //    google.message_id: 0:1542590229193754%6c0b71ba6c0b71ba,
      //    google.ttl: 2419200
      // }
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        RouteItem r = getRouteWithParamsFromMessage(message['data']);
        if (r.route != null) {
          Navigator.of(context).pushNamed(r.route, arguments: r.params);
        }
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        RouteItem r = getRouteWithParamsFromMessage(message['data']);
        if (r.route != null) {
          Navigator.of(context).pushNamed(r.route, arguments: r.params);
        }
      },
    );
  }
}