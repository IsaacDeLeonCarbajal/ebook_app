import 'dart:convert';
import 'dart:collection';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ebook_app/app/models/model.dart';
import 'package:ebook_app/app/services/sqlite_service.dart';

abstract class ModelService<T extends Model> extends ChangeNotifier {
  static const statusLocal = 1;
  static const statusSynced = 2;
  static const statusProcessing = 3;
  static const statusError = 4;

  late final SqliteService sqliteService;
  final Map<String, T> _elements = {};
  int _status = ModelService.statusProcessing;
  late final String identifier;
  final T Function(dynamic) fromEntries;
  final Future<Map<String, T>> Function() selectRecords;

  ModelService({
    required this.identifier,
    required this.fromEntries,
    required this.selectRecords,
  }) {
    _init();
  }

  void _init() {
    sqliteService = SqliteService();

    Connectivity().checkConnectivity().then((value) {
      if (value != ConnectivityResult.none) {
        // If there is connectivity, sync remote data
        syncRemote();
      } else {
        // If there is no connectivity, sync local data
        syncLocal();
      }
    });
  }

  void syncRemote() async {
    status = ModelService.statusProcessing;

    try {
      Map<String, T> newRecords = await selectRecords(); // Get the data from the cloud

      if (newRecords.isEmpty) {
        throw Exception('Could not sync data from cloud');
      }

      _elements.clear();

      addAll(newRecords.values.toList());

      status = ModelService.statusSynced;
    } on Exception {
      status = ModelService.statusError;
    }
  }

  void syncLocal() async {
    List<T> elems = await sqliteService.getAllItems(
      identifier,
      fromEntries: (e) => fromEntries(json.decode(e['content_data'].toString())),
    );

    addAll(elems);

    status = ModelService.statusLocal;
  }

  void addAll(List<T> elements) {
    for (T elem in elements) {
      if (elem.exists) {
        _elements.addAll({elem.id ?? '': elem});
      }
    }

    saveToLocal();

    notifyListeners();
  }

  void add(T e) {
    addAll([e]);
  }

  T? remove(String id) {
    T? val = _elements.remove(id);

    saveToLocal();

    notifyListeners();

    return val;
  }

  T? find(String? id) {
    return _elements[id];
  }

  Iterable<T> select(String field, String value) {
    return _elements.values.where((e) => e.attributes[field] == value);
  }

  void saveToLocal() async {
    await sqliteService.deleteItem(identifier); // Delete all records

    elements.where((elem) => elem.exists).take(50).forEach(
      (elem) {
        sqliteService.saveItem(identifier, {
          'related_id': elem.id ?? '',
          'content_data': elem.toJson(),
        });
      },
    );
  }

  bool get isEmpty => _elements.isEmpty;
  int get status => _status;
  bool get isReady => !isEmpty && [ModelService.statusLocal, ModelService.statusSynced].contains(_status);
  List<T> get elements => UnmodifiableListView(_elements.values);

  set status(int status) {
    _status = status;

    notifyListeners();
  }
}
