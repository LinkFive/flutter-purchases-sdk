import 'package:http/http.dart';
import 'package:linkfive_purchases/src/client/http/http_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClientFactory extends Mock implements HttpClientFactory {
  void withMockClient(MockClient mockClient) {
    when(() => getClient()).thenReturn(mockClient);
  }
}

class MockClient extends Mock implements Client {}
