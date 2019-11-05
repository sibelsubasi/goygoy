// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:mobile/pages/home/share.dart';
import 'redirect.dart';
import 'package:mobile/pages/welcome/onboard.dart';
import 'package:mobile/pages/login/photo.dart';
import 'package:mobile/pages/home/edit.dart';




final ROUTES = {
  //TODO: "/" route will check first-open, return necessary page as a widget -> Its all widget :)
  //TODO: if you change initial routing for development ease, please do not commit it, thank you
  '/': (RouteSettings s) => RedirectPage(),
  '/welcome/onboard': (RouteSettings s) => OnBoardPage(),
  '/login/photo': (RouteSettings s) => PhotoUploadPage(),
  '/home/edit': (RouteSettings s) => EditPage(loadedImageFile: s.arguments),
  '/home/share': (RouteSettings s) => SharePage(capturedImageFile: s.arguments),
};

