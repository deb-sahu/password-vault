import 'package:hive/hive.dart';

class CacheManager<T> {
  Future<Box<T>> getBoxAsync(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  Box<T> getOpenedBox(String boxName) {
    return Hive.box<T>(boxName);
  }

  Future<int> deleteRecords(Box<T> box) async {
    return await box.clear();
  }
}

enum CacheTypes {
  passwordsInfoBox,
  favouritesInfoBox,
  systemInfoBox,
  historyInfoBox,
}
