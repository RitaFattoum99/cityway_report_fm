import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future<void> save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  Future<void> saveInt(String key, int value) async {
    await storage.write(key: key, value: value.toString());
  }

  Future<int?> readInt(String key) async {
    String? valueString = await storage.read(key: key);
    return valueString != null ? int.parse(valueString) : null;
  }
}
