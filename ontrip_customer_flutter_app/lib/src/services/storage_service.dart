import 'dart:convert';
import '../../app_export.dart';

final _storage = GetStorage();

dynamic getStorage(String name) {
  dynamic info = _storage.read(name);
  return info != null ? json.decode(info) : info;
}

Future<dynamic> writeStorage(String key, dynamic value) async {
  dynamic object = value != null ? json.encode(value) : value;
  return await _storage.write(key, object);
}

Future<void> removeSpecificKeyStorage(String key) => _storage.remove(key);

Future<void> clearStorage() async => await _storage.erase();
