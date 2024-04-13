import 'package:pluralize/pluralize.dart';
import 'package:ebook_app/app/services/http_client.dart';
import 'dart:convert';

import 'package:ebook_app/app/support/helper.dart';

abstract class Model {
  static Future<Map<String, T>> allRecords<T extends Model>(String modelName, T Function(Map) fromEntries) async {
    Map modelsData = await HttpClient.getApiCall('api/$modelName');

    if (modelsData.isEmpty) {
      return {};
    }

    return {
      for (var model in modelsData[modelName])
        model['id'].toString(): fromEntries(
          model,
        ),
    };
  }

  static Future<T> findRecord<T extends Model>(String? id, String modelName, T Function(Map) fromEntries) async {
    Map? modelData = (await HttpClient.getApiCall('api/$modelName/$id'))[Pluralize().singular(modelName)];

    return fromEntries(modelData ??= {});
  }

  static Future<Map?> storeRecord({
    required String name,
    required Map<String, dynamic> attributes,
    List<String> requiredAttrs = const [],
  }) async {
    if (!Helper.validateRequired(
      attributes: attributes,
      requiredAttrs: requiredAttrs,
    )) {
      // Validation failed
      return null; // Do nothing else
    }

    return await HttpClient.postApiCall('api/$name', attributes);
  }

  static Future<Map?> updateRecord({
    required String id,
    required String name,
    required Map<String, dynamic> attributes,
    List<String> requiredAttrs = const [],
  }) async {
    if (!Helper.validateRequired(
      attributes: attributes,
      requiredAttrs: requiredAttrs,
    )) {
      // Validation failed
      return null; // Do nothing else
    }

    return await HttpClient.putApiCall('api/$name/$id', attributes);
  }

  static Future<bool> destroyRecord({
    required String id,
    required String name,
  }) async {
    return (await HttpClient.deleteApiCall('api/$name/$id')).isNotEmpty;
  }

  String? _id;
  final String table;
  final Map<String, dynamic> attributes = {};
  final List<String> requiredAttrs = [];

  Model(this.table, {String? id}) : _id = id;

  Future<bool> save() async {
    Map? response;

    if (!exists) {
      response = await Model.storeRecord(
        name: table,
        attributes: attributes,
        requiredAttrs: requiredAttrs,
      );
    } else {
      response = await Model.updateRecord(
        id: _id ?? '',
        name: table,
        attributes: attributes,
        requiredAttrs: requiredAttrs,
      );
    }

    if (response == null || response.isEmpty) {
      return false;
    }

    afterSave(response[Pluralize().singular(table)]);

    return exists;
  }

  Future<bool> delete() async {
    if (!exists) {
      // If this instance hasn't been stored
      return false; // Can not destroy it
    }

    return Model.destroyRecord(
      id: _id ?? '',
      name: table,
    );
  }

  Future<bool> update(Map entries) {
    updateData(entries);

    return save();
  }

  /// Update the data contained in this model
  /// If any of the values are not present, should keep the old value
  void updateData(Map entries);

  /// Perform operations after save
  /// Receive the remote response as parameter
  void afterSave(Map response) {
    _id = response['id'].toString();
  }

  T getValue<T>(String name, {T? defaultValue}) {
    return Helper.getMapValue<T>(attributes, name, defaultValue: defaultValue);
  }

  @override
  String toString() {
    return 'id: $id, ${attributes.toString()}';
  }

  String toJson() {
    Map<String, String> attrs = {
      'id': id.toString(),
      ...attributes.map((key, value) => MapEntry(key, value.toString())),
    };

    return json.encode(attrs);
  }

  String? get id => _id;
  bool get exists => ![null, 'null', ''].contains(_id);
}
