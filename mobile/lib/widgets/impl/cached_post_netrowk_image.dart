// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.
/***
 * 2019.04.02 fbulut,
 * @deprecated
 */
/*
import 'dart:convert' show JsonEncoder;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/authentication.dart';
import 'package:path/path.dart' as path;

class CachedPostNetworkImageProvider extends CachedNetworkImageProvider {
  final url;

  CachedPostNetworkImageProvider({this.url})
      : super(
          url,
          cacheManager: CustomCacheManager(),
        );
}

class CachedPostNetworkImage extends StatelessWidget {
  final String url;
  final Map<String, String> body;
  final Widget placeholder;
  final Widget error;
  final double width;
  final double height;

  const CachedPostNetworkImage({
    Key key,
    @required this.url,
    @required this.body,
    this.placeholder = const CupertinoActivityIndicator(),
    this.error = const Icon(Icons.error),
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: this.height,
      width: this.width,
      httpHeaders: this.body,
      cacheManager: CustomCacheManager(),
      imageUrl: this.url,
      placeholder: (context, url) => this.placeholder,
      errorWidget: (context, url, error) {
        //print("error? ${error}");
        return this.error;
      },
    );
  }
}

class CustomCacheManager extends BaseCacheManager {
  static const key = Config.KEY_FILE_CACHE;

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(
          key,
          maxAgeCacheObject: Config.CACHE_MAX_TIME,
          maxNrOfCacheObjects: Config.CACHE_MAX_ITEM,
          fileFetcher: _customHttpGetter,
        );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url, {Map<String, String> headers}) async {
    var h = {'Authorization': AuthenticationService().authHeader(), "Content-Type": "application/json"};
    return HttpFileFetcherResponse(await http.get(url, headers: h));
  }
}
*/