import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/infra/remote/client_exception.dart';

abstract class WebClient {
  final BaseClient _client;
  final Connectivity _connectivity;

  const WebClient(this._client, this._connectivity);

  Stream<Result<T>> get<T>(String url, T Function(String body) transform) {
    return _wrapRequest(
      url,
      (fullUrl, headers) => _client.get(fullUrl, headers: headers),
      transform,
    );
  }

  Stream<Result<T>> delete<T>(String url, T Function(String body) transform) {
    return _wrapRequest(
      url,
      (fullUrl, headers) => _client.delete(fullUrl, headers: headers),
      transform,
    );
  }

  Stream<Result<T>> post<T>(
    String url,
    String body,
    T Function(String body) transform,
  ) {
    return _wrapRequest(
      url,
      (fullUrl, headers) => _client.post(fullUrl, headers: headers, body: body),
      transform,
    );
  }

  Stream<Result<T>> put<T>(
    String url,
    String? body,
    T Function(String body) transform,
  ) {
    return _wrapRequest(
      url,
      (fullUrl, headers) => _client.put(fullUrl, headers: headers, body: body),
      transform,
    );
  }

  Stream<Result<T>> _wrapRequest<T>(
    String url,
    Future<Response> Function(Uri uri, Map<String, String> headers) request,
    T Function(String body) transform,
  ) async* {
    yield ResultLoading();
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NoConnectionException('');
    }
    final response = await request(
      Uri.parse(getFullUrl(url)),
      await getHeaders(),
    );
    yield _resultByResponse(response, transform);
  }

  Result<T> _resultByResponse<T>(
    Response response,
    T Function(String body) transform,
  ) {
    if (response.isSuccess) {
      return ResultSuccess(transform(response.body));
    } else {
      return ResultError(response.statusCode.toStatusException(
        'Error status: ${response.statusCode}',
      ));
    }
  }

  FutureOr<Map<String, String>> getHeaders();

  String getFullUrl(String relativeUrl);
}

extension ResponseExtensions on Response {
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
