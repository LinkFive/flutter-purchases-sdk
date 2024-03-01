import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/src/client/http/http_client.dart';

/// HTTP Client with retry function
class RetryHttpClient extends LinkFiveHttpClient {
  final http.Client httpClient;
  final int requestTimeoutSeconds;
  final int retryTimeoutMillis;
  final int retryTimes = 3;

  RetryHttpClient(HttpClientFactory clientFactory)
      : httpClient = clientFactory.getClient(),
        requestTimeoutSeconds = 16,
        retryTimeoutMillis = 500;

  RetryHttpClient.test(HttpClientFactory clientFactory)
      : httpClient = clientFactory.getClient(),
        requestTimeoutSeconds = 1,
        retryTimeoutMillis = 0;

  @override
  Future<http.Response> post(Uri uri, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    for (int retryCount = 0; retryCount < retryTimes; retryCount++) {
      try {
        final response = await httpClient
            .post(uri, body: jsonEncode(body), headers: headers)
            .timeout(Duration(seconds: requestTimeoutSeconds));
        if(response.statusCode == 429){
          throw Exception("Too many requests");
        }
        return response;
      } catch (e) {
        if (retryCount >= retryTimes - 1) {
          LinkFiveLogger.e("Retried $retryCount but still Request Error: ${e.toString()}");
          rethrow;
        }
        LinkFiveLogger.e("Purchase Request Error: ${e.toString()}");
        LinkFiveLogger.e("Try Again with same request");
        await Future.delayed(Duration(milliseconds: retryTimeoutMillis));
      }
    }
    throw Exception("Could not do any request");
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return httpClient.get(url, headers: headers);
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return httpClient.put(url, headers: headers, body: body, encoding: encoding);
  }
}
