// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:mobile/commons/config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_performance/firebase_performance.dart';
import 'package:mobile/entities/attachment.dart';
import 'package:mobile/services/token.dart';
import 'package:mobile/exceptions/exceptions.dart';

class _Metric {
  HttpMetric _metric;
  http.Response _response;
  String _url;
  String _method;
  String _body;

  static HttpMethod _toHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case "GET":
        return HttpMethod.Get;
      case "POST":
        return HttpMethod.Post;
      case "CONNECT":
        return HttpMethod.Connect;
      case "DELETE":
        return HttpMethod.Delete;
      case "HEAD":
        return HttpMethod.Head;
      case "OPTIONS":
        return HttpMethod.Options;
      case "PATCH":
        return HttpMethod.Patch;
      case "PUT":
        return HttpMethod.Put;
      case "TRACE":
        return HttpMethod.Trace;
      default:
        return HttpMethod.Get;
    }
  }

  void start(String method, String url, {String body}) async {
    _method = method;
    _url = url;
    _body = body;
    _metric = FirebasePerformance.instance.newHttpMetric(_url, _toHttpMethod(_method.toUpperCase()));
    await _metric.start();
  }

  void stop(http.Response response) async {
    _response = response;
    try {
      _metric
        ..responsePayloadSize = _response.contentLength
        ..responseContentType = _response.headers['Content-Type']
        ..requestPayloadSize = _body != null ? _body.length : 0
        ..httpResponseCode = _response.statusCode;

      if (Config.DEBUG_OUTPUT_REQ_RES) {
        print("METRIC: [${_response.statusCode}] PayloadSize: ${_body?.length}, ResponseSize: ${_response.contentLength}]");
      }
    } finally {
      await _metric.stop();
    }
  }
}

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  static TokenService _tokenService;

  static void registerTokenService(TokenService ts) {
    _tokenService = ts;
  }

  static bool hasRegisteredTokenService() {
    return _tokenService != null;
  }


  Future<dynamic> get(String url, {Map headers, isRetry = false}) {
    _Metric metric = _Metric();

    if (Config.DEBUG) {
      print("Getting to: " + url);
    }

    Map<String, String> postHeaders;
    if (headers != null) {
      postHeaders = Map<String, String>.from(headers);
    } else {
      postHeaders = new Map<String, String>();
    }

    if (Config.WS_WORK_WITH_MOCK) {
      if (Config.DEBUG) {
        print("Working with MOCK!");
      }
      postHeaders['mock'] = 'true';
    }
    postHeaders['api-version'] = Config.API_VERSION.toString();

    if (Config.DEBUG_OUTPUT_REQ_RES) {
     print("with headers " + postHeaders.toString());
    }

    metric.start("GET", url);
    return http.get(url, headers: postHeaders)
        .timeout(const Duration(seconds: Config.WS_HTTP_TIME_OUT))
        .then((http.Response response) async {

      metric.stop(response);
      if (Config.DEBUG) {
        print("response.stausCode: " + response.statusCode.toString());
      }
      if (Config.DEBUG_OUTPUT_REQ_RES) {
        print("response.body: " + response.body);
      }

      if (response.statusCode < 200 || response.statusCode >= 300 || json == null) {
        if (headers != null  && headers['Authorization'] != null && response.statusCode == 401 && !isRetry && hasRegisteredTokenService()) {
                //"authentication token expired"; is the token service message.
                // I wont check with free text. Just look for statusCode,
                // if it is 401, if you have a registeredTokenService,
                // and if you did not tried it before, reRun service;
                //TODO: isRetry go to login page;
                print("Authorization seems expired. ReQuery it before throwing exception");
                headers['Authorization']=  "Bearer " + await _tokenService.doRefreshToken();
                return this.post(url,headers: headers,isRetry: true);
        }
        String msg;
        if (json != null) {
          try {
              dynamic dyn = _decoder.convert(response.body);
              msg = dyn['errorMessage'] != null ? dyn['errorMessage'].toString() : null;
            } catch(e) {

            }
        }
       (msg == null) ? throw new Exception("Servis hata bildirdi") : throw new ServiceException(msg);
      }

      if (headers != null && headers["bytes"] != null && headers['bytes'] == 'true') {
        return response.bodyBytes;
      }

      if (headers != null && headers["raw"] != null && headers['raw'] == 'true') {
        return response.body;
      }

      return _decoder.convert(response.body);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, isRetry = false}) async {
    _Metric metric = _Metric();

    if (Config.DEBUG) {
      print("Posting to: " + url + " with body.length: ${body.toString().length} bytes");
    }

    dynamic postBody;
    Map<String, String> postHeaders;

    if (headers != null) {
      postHeaders = Map<String, String>.from(headers);
    } else {
      postHeaders = new Map<String, String>();
    }
    if (body != null) {
      if (body.runtimeType.toString().contains("Map<")) {
        postBody = Map<String, String>.from(body);
        //postHeaders['Content-Type'] = "application/json";
      } else {
        postHeaders['Content-Type'] = "application/json";
        postBody = body;
      }
    } else {
      postBody = null;//new Map<String, String>();
    }


    if (postHeaders['Content-Type'] == null) {
      postHeaders['Content-Type'] = "application/json";
     // print("Flutter will force content-type: application/x-www-form-urlencoded");
    } else {
      print("content-type:${postHeaders['Content-Type']}");
    }

    if (Config.WS_WORK_WITH_MOCK) {
      if (Config.DEBUG) {
        print("Working with MOCK!");
      }
      postHeaders['mock'] = 'true';
    }

    postHeaders['api-version'] = Config.API_VERSION.toString();

    if (Config.DEBUG_OUTPUT_REQ_RES) {
      print("with headers " + postHeaders.toString());
      print("with body " + postBody.toString());
    }


    metric.start("POST", url, body: postBody.toString());
    return http
        .post(url, body: postBody, headers: postHeaders)
        .timeout(const Duration(seconds: Config.WS_HTTP_TIME_OUT))
        .then((http.Response response) async {
      metric.stop(response);

      if (Config.DEBUG) {
        print("response.stausCode: " + response.statusCode.toString());
      }

      if (Config.DEBUG_OUTPUT_REQ_RES) {
        _debugPrint("response.body: " + response.body);
      }

      if (response.statusCode < 200 || response.statusCode >= 300 || json == null) {
        /*print("reTry: headers: $headers");
        print("reTry: headers.Auth: ${headers['Authorization']}");
        print("reTry:  response.statusCode: ${response.statusCode }");
        print("reTry: isRetry: $isRetry");
        print("reTry: regServ: ${hasRegisteredTokenService()}");*/
        if (headers != null && headers['Authorization'] != null && response.statusCode == 401 && !isRetry && hasRegisteredTokenService()) {
          //"authentication token expired"; is the token service message.
          // I wont check with free text. Just look for statusCode,
          // if it is 401, if you have a registeredTokenService,
          // and if you did not tried it before, reRun service;
          //TODO: isRetry go to login page;
          print("Authorization seems expired. ReQuery it before throwing exception");
          headers['Authorization']=  "Bearer " + await _tokenService.doRefreshToken();
          print("after refresh trying to go with params:");
          print("url $url, retTry: ${true} headers: $headers,  body: $body");
          return this.post(url,body: body,headers: headers,isRetry: true);
        }

        String msg;
        if (json != null) {
          try {
            dynamic dyn = _decoder.convert(response.body);
            msg = dyn['errorMessage'] != null ? dyn['errorMessage'].toString() : null;
          } catch(e) {
          }
        }
        (msg == null) ? throw new Exception("Servis hata bildirdi") : throw new ServiceException(msg);
      }
      if (headers != null && headers["raw"] != null && headers['raw'] == 'true') {
          return response.body;
      }
      if (headers != null && headers["bytes"] != null && headers['bytes'] == 'true') {
          return response.bodyBytes;
      }
      return _decoder.convert(response.body);
    });
  }


  Future<dynamic> multipart(String url, {Map headers, Attachment body, isRetry = false}) async {
    if (Config.DEBUG) {
      print("Multipart Post to: " + url + " with fieldName ${body.fieldName} and body.length: ${body.file.lengthSync()} bytes");
    }

    Map<String, String> postHeaders;

    if (headers != null) {
      postHeaders = Map<String, String>.from(headers);
    } else {
      postHeaders = new Map<String, String>();
    }

    if (Config.WS_WORK_WITH_MOCK) {
      if (Config.DEBUG) {
        print("Working with MOCK!");
      }
      postHeaders['mock'] = 'true';
    }
    postHeaders['api-version'] = Config.API_VERSION.toString();

    if (Config.DEBUG_OUTPUT_REQ_RES) {
      print("with headers " + postHeaders.toString());
      print("with file " + body.file.path);
    }

    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath(body.fieldName,body.file.path,contentType: body.mediaType));
    request.headers.addAll(postHeaders);

    return request.send().then((response) async {
      if (Config.DEBUG) {
        print("response.stausCode: " + response.statusCode.toString());
      }

      if (Config.DEBUG_OUTPUT_REQ_RES) {
         print("response.uploaded?: ${response.statusCode == 200}");
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {

        if (headers['Authorization'] != null && response.statusCode == 401 && !isRetry && hasRegisteredTokenService()) {
          //"authentication token expired"; is the token service message.
          // I wont check with free text. Just look for statusCode,
          // if it is 401, if you have a registeredTokenService,
          // and if you did not tried it before, reRun service;
          //TODO: isRetry go to login page;
          print("Authorization seems expired. ReQuery it before throwing exception");
          headers['Authorization']=  "Bearer " + await _tokenService.doRefreshToken();
          print("after refresh trying to go with params:");
          print("url $url, retTry: ${true} headers: $headers,  body: $body");
          return this.multipart(url, body: body, headers: headers, isRetry: true);
        }

        String msg;
        try {
            dynamic dyn = _decoder.convert(utf8.decode(await response.stream.toBytes()));
            msg = dyn['errorMessage'] != null ? dyn['errorMessage'].toString() : null;
        } catch (e) {
          if (Config.DEBUG) {
            print("response.error: " + e.toString());
          }
        }
        (msg == null) ? throw new Exception("Servis hata bildirdi") : throw new ServiceException(msg);
      }
      if (headers != null && headers["raw"] != null && headers['raw'] == 'true') {
        return response;
      }
      if (headers != null && headers["bytes"] != null && headers['bytes'] == 'true') {
        return await response.stream.toBytes();
      }
      return _decoder.convert(utf8.decode(await response.stream.toBytes()));
    });
  }

  _debugPrint(String s) {
    int si = 0;
    //print("s.length: ${s.length}");
    while (si  < s.length) {
      int cp = min(155, s.length - si);
      //print("cp: $cp, si: $si");
      print(s.substring(si,si+cp));
      si += cp;
    }


  }

}