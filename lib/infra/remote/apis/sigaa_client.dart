import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/infra/remote/web_client.dart';
import 'package:ufcat_ru_check/utils/app_constants.dart';

part 'sigaa_client.g.dart';

abstract class SigaaClient extends WebClient {
  final FlutterSecureStorage _secureStorage;
  final AppConstants _constants;
  final String endpoint;

  const SigaaClient(
    super.client,
    super.connectivity,
    this._secureStorage,
    this._constants, {
    required this.endpoint,
  });

  @override
  Future<Map<String, String>> getHeaders() async {
    final token = await _secureStorage.sigaaToken;
    var headers = {'Accept': '*/*', 'Content-Type': 'application/vnd.api+json'};
    if (token != null) headers['Authorization'] = 'Token token=$token';
    return headers;
  }

  @override
  String getFullUrl(String relativeUrl) {
    return _constants.sigaaBaseUrl + endpoint + relativeUrl;
  }
}

@JsonSerializable(genericArgumentFactories: true)
class SigaaResource<T> {
  final T data;

  SigaaResource(this.data);

  factory SigaaResource.fromBody(String body, T Function(dynamic) toJson) =>
      _$SigaaResourceFromJson<T>(json.decode(body), toJson);
}

extension on FlutterSecureStorage {
  Future<String?> get sigaaToken => read(key: 'SIGAA_TOKEN');
}
