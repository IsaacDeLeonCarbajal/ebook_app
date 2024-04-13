import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

abstract class HttpClient {
  static const apiUrl = '192.168.1.69:80';
  static const headers = {
    'Accept': 'application/json',
  };

  static Future<Map> getApiCall(String endpoint) {
    return HttpClient.makeApiCall(
      makeRequest: () => http.get(
        Uri.http(HttpClient.apiUrl, endpoint),
        headers: HttpClient.headers,
      ),
    );
  }

  static Future<Map> postApiCall(String endpoint, Object? body) {
    return HttpClient.makeApiCall(
      makeRequest: () => http.post(
        Uri.http(HttpClient.apiUrl, endpoint),
        headers: HttpClient.headers,
        body: prepareBody(body),
      ),
    );
  }

  static Future<Map> putApiCall(String endpoint, Object? body) {
    return HttpClient.makeApiCall(
      makeRequest: () => http.put(
        Uri.http(HttpClient.apiUrl, endpoint),
        headers: HttpClient.headers,
        body: prepareBody(body),
      ),
    );
  }

  static Future<Map> deleteApiCall(String endpoint) {
    return HttpClient.makeApiCall(
      makeRequest: () => http.delete(
        Uri.http(HttpClient.apiUrl, endpoint),
        headers: HttpClient.headers,
      ),
    );
  }

  static Future<Map> makeApiCall({required Future<http.Response> Function() makeRequest}) async {
    try {
      http.Response response = await makeRequest().timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('{"message": "Request Timeout"}', 408),
      );

      return HttpClient._processResponse(response);
    } on FormatException catch (e) {
      developer.log(e.toString());
      return _processError('Unexpected response from server, please try again later');
    } on Exception catch (e) {
      return _processError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Handle an error with the error message
  static Map _processError(String errorMessage) {
    Fluttertoast.showToast(msg: errorMessage, backgroundColor: Colors.red);

    return {};
  }

  /// Try to get the body of a response
  static Map _processResponse(http.Response response) {
    Map<String, dynamic> body = convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode.toString().startsWith('2')) {
      // Successful response
      return body;
    } else {
      throw Exception(body['message']);
    }
  }

  /// Prepare a body to be sent in a request
  /// Convert all of its values to string type if necessary
  /// Remove null values
  static dynamic prepareBody(Object? body) {
    developer.log(body.toString());

    if (body == null || body is String) {
      return body;
    } else if (body is Map) {
      return {
        for (var key in body.keys)
          if (body[key] != null && body[key].toString().isNotEmpty) key.toString(): body[key].toString()
      };
    } else if (body is List) {
      return body.where((val) => val != null && val.toString().isNotEmpty).map((value) => value.toString()).toList();
    } else {
      throw Exception('The body must be one of Map, List or String');
    }
  }
}
