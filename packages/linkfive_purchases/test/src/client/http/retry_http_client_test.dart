import 'dart:async';

import 'package:http/src/response.dart';
import 'package:linkfive_purchases/src/client/http/retry_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  final uri = Uri.parse("linkfive.io");

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  test('instant 200', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));

    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async => Response("", 200));

    final Response response = await retryClient.post(uri);

    expect(response.statusCode, 200);
  });

  test('always Exception', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));

    when(() => mockClient.post(any(), body: any(named: "body"))).thenThrow(Error());

    expect(retryClient.post(uri), throwsA(isA<Error>()));
  });

  test('retry after 1', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    int requestCounter = 0;
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      if (requestCounter++ < 1) {
        throw Exception("");
      }
      return Response("", 200);
    });

    final Response response = await retryClient.post(uri);

    expect(response.statusCode, 200);
  });

  test('retry max RetryTimes + 0', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    int requestCounter = 0;
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      if (requestCounter++ < retryClient.retryTimes - 1) {
        throw Error();
      }
      return Response("", 200);
    });

    final Response response = await retryClient.post(uri);

    expect(response.statusCode, 200);
  });

  test('retry max RetryTimes + 1 error', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    int requestCounter = 0;
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      if (requestCounter++ < retryClient.retryTimes) {
        throw Error();
      }
      return Response("", 200);
    });
    expect(retryClient.post(uri), throwsA(isA<Error>()));
  });

  test('test timeout', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 15));
      return Response("", 200);
    });
    expect(retryClient.post(uri), throwsA(isA<TimeoutException>()));
  });

  test('test error too many requests', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      return Response("", 429);
    });
    expect(retryClient.post(uri), throwsA(isA<Exception>()));
  });

  test('test success with -1 too many requests', () async {
    final mockClient = MockClient();
    final retryClient = RetryHttpClient.test(MockHttpClientFactory()..withMockClient(mockClient));
    int requestCounter = 0;
    when(() => mockClient.post(any(), body: any(named: "body"))).thenAnswer((_) async {
      if (requestCounter++ < retryClient.retryTimes - 1) {
        return Response("", 429);
      }
      return Response("", 200);
    });

    final response = await retryClient.post(uri);
    expect(response.statusCode, 200);
  });
}
