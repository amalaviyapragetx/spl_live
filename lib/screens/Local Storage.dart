import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final box = GetStorage();

  static write(String key, dynamic value) {
    box.write(key, value);
  }

  static read(String key) async {
    var val = await box.read(key);
    return val;
  }

  static remove(String key) {
    box.remove(key);
  }

  static eraseBox() {
    box.erase();
  }
}
