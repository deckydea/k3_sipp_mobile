import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:math";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:k3_sipp_mobile/net/master_message.dart";
import "package:k3_sipp_mobile/net/response/response_type.dart";
import "package:k3_sipp_mobile/repository/app_repository.dart";
import "package:k3_sipp_mobile/util/text_utils.dart";
import "package:uuid/uuid.dart";
import 'dart:developer' as dev;

class ConnectionUtils {
  static const int timeout = 8; // seconds
  static const int longTimeout = 30; // seconds
  static const int maxAttempts = 3;

//   static final Uri milleUri = Uri.https("lakes.co.id", "/mille/rest");
//   static final Uri hakuUri = Uri.https("lakes.co.id", "/haku/rest");
//   static final Uri imageUri = Uri.https("lakes.co.id", "/mille/image");
//   static final Uri altMilleUri = Uri.https("backend.millehub.com", "/mille/rest");
//   static final Uri altHakuUri = Uri.https("backend.hakureward", "/haku/rest");
//   static final Uri altMilleImageUri = Uri.https("backend.millehub.com", "/mille/image");

  static final Uri k3sippUri = Uri.http("192.168.1.7:8080", "/");
  static final Uri altK3sippUri = Uri.http("192.168.1.7:8080", "/");

  static final Map<String, String> httpHeader = {"Accept": "application/json", "content-type": "application/json"};
  static const String noConnectionResponse = "Unable to connect to server.";

  static final Random random = Random();

  static const int windowSize = 15; // in minutes
  static Uri? selectedUri;
  static DateTime? upperBound;
  static bool link1Timeout = false;
  static bool link2Timeout = false;

  static http.Response get timeoutResponse => http.Response("Request Timeout", 408);

  static Uri getUri() {
    DateTime now = DateTime.now();
    if (upperBound == null || now.isAfter(upperBound!) || (link1Timeout && link2Timeout)) {
      if (upperBound != null && now.isAfter(upperBound!)) {
        upperBound = now.add(const Duration(minutes: windowSize));
      }
      link1Timeout = false;
      link2Timeout = false;
    }

    if (selectedUri == null || (!link1Timeout && !link2Timeout)) {
      int uriIndex = random.nextInt(2);
      selectedUri = uriIndex == 0 ? k3sippUri : altK3sippUri;
    } else if (link1Timeout) {
      selectedUri = altK3sippUri;
    } else {
      selectedUri = k3sippUri;
    }

    return selectedUri ?? k3sippUri;
  }

  static Future<MasterMessage> sendRequest(MasterMessage content, {int timeout = timeout}) async {
    Uuid uuid = const Uuid();
    content.id = uuid.v1();
    content.version = AppRepository().versionNumber;

    Uri uri = getUri();
    MasterMessage response = await _request(uri, content, timeout);

    if (response.response == MasterResponseType.noConnection) {
      // Failed to send to the selected URI. Send to the alternate one.
      if (uri == k3sippUri) {
        link1Timeout = true;
        upperBound = DateTime.now().add(const Duration(minutes: windowSize));
      } else if (uri == altK3sippUri) {
        link2Timeout = true;
        upperBound = DateTime.now().add(const Duration(minutes: windowSize));
      }

      uri = getUri();
      response = await _request(uri, content, timeout);
      if (response.response == MasterResponseType.noConnection) {
        if (uri == k3sippUri) {
          link1Timeout = true;
          upperBound = DateTime.now().add(const Duration(minutes: windowSize));
        } else if (uri == altK3sippUri) {
          link2Timeout = true;
          upperBound = DateTime.now().add(const Duration(minutes: windowSize));
        }
      }
    }

    if(!TextUtils.isEmpty(response.token)) await AppRepository().setToken(response.token!);

    return response;
  }

  static Future<MasterMessage> _request(Uri uri, MasterMessage message, int timeout) async {
    int attempt = 1;
    MasterMessage? responseMessage;

    while (attempt <= maxAttempts) {
      responseMessage = await _sendRequest(uri, message, timeout);
      // Only timeout will retry.
      if (!TextUtils.equals(responseMessage.response, MasterResponseType.timeout)) break;
      sleep(Duration(milliseconds: Random().nextInt(attempt * 1000)));
      attempt++;
    }

    if (responseMessage == null) {
      return MasterMessage(request: message.request, response: MasterResponseType.exception, token: message.token);
    } else if (TextUtils.equals(responseMessage.response, MasterResponseType.timeout)) {
      return MasterMessage(request: message.request, response: MasterResponseType.noConnection, token: message.token);
    }

    return responseMessage;
  }

  static Future<MasterMessage> _sendRequest(Uri uri, MasterMessage message, int timeout) async {
    try {
      Uri uriRequest = uri.replace(path: message.path);
      if(kDebugMode){
        print("_sendRequest...");
        print("uriRequest: $uriRequest");
        dev.log("REQUEST: ${jsonEncode(message)}");
      }
      httpHeader['Authorization'] = 'Bearer ${message.token}';
      http.Response? response = await http
          .post(
            uriRequest,
            headers: httpHeader,
            body: jsonEncode(message),
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if(kDebugMode){
        dev.log("RESPONSE: ${response.statusCode} ${response.body}");
      }

      return response.statusCode == 200
          ? MasterMessage.fromJson(json.decode(response.body))
          : MasterMessage(request: message.request, response: MasterResponseType.exception, token: message.token);
    } on TimeoutException {
      return MasterMessage(request: message.request, response: MasterResponseType.timeout, token: message.token);
    } on SocketException catch (_) {
      return MasterMessage(request: message.request, response: MasterResponseType.noConnection, token: message.token);
    } catch (e) {
      return MasterMessage(request: message.request, response: MasterResponseType.exception, token: message.token);
    }
  }
}
