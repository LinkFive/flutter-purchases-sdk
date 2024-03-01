import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

abstract class LinkFiveHttpClient {
  Future<Response> post(Uri uri, {Map<String, String>? headers, Map<String, dynamic>? body});

  Future<Response> get(Uri url, {Map<String, String>? headers});

  Future<Response> put(Uri url, {Map<String, String>? headers, Map<String, dynamic>? body, Encoding? encoding});
}

class HttpClientFactory {
  final Client _client;

  HttpClientFactory.basic() : _client = IOClient();

  Client getClient() => _client;
}
