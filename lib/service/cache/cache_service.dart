import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:password_vault/cache/cache_manager.dart';
import 'package:password_vault/cache/hive_models/favourites_model.dart';
import 'package:password_vault/cache/hive_models/folder_model.dart';
import 'package:password_vault/cache/hive_models/history_model.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/cache/hive_models/system_preferences_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class CacheService {
  String getFormattedTimeStampForFileName() {
    DateTime dateTime = DateTime.now();
    return DateFormat('yyyy-MM-dd_hh-mm-ss').format(dateTime);
  }

  Future<List<PasswordModel>> getPasswordsData() async {
    List<PasswordModel> passwords = [];
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      passwords = passwordsInfoBox.values.toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error in fetching passwords data: $e');
    }
    return passwords;
  }

  Future<PasswordModel?> getPasswordByPasswordId(String passwordId) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      return passwordsInfoBox.get(passwordId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addEditPassword(PasswordModel passwordsInfo) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      await passwordsInfoBox.put(passwordsInfo.passwordId, passwordsInfo);

      // Add or update password in favourites
      var isPasswordInFavourites = await isPasswordInFavoritesByPasswordId(passwordsInfo.passwordId);
      if (isPasswordInFavourites) {
        await removePasswordFromFavouritesByPasswordId(passwordsInfo.passwordId);
        await addPasswordsToFavourites(passwordsInfo);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePasswordRecord(String passwordId) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      if (passwordsInfoBox.containsKey(passwordId) == false) {
        return false;
      }
      // Log password history before deleting
      var password = passwordsInfoBox.get(passwordId);
      if (password != null) {
      await logPasswordHistory(password, 'deleted');
      }

      await CacheService().removePasswordFromFavouritesByPasswordId(passwordId);
      await passwordsInfoBox.delete(passwordId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkPasswordIdExists(String passwordId) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      return passwordsInfoBox.containsKey(passwordId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePasswordRecord (PasswordModel passwordModel) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      if (passwordsInfoBox.containsKey(passwordModel.passwordId) == false) {
        return false;
      }
      await passwordsInfoBox.put(passwordModel.passwordId, passwordModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<PasswordModel>> getFavouritesData() async {
    List<PasswordModel> favourites = [];
    try {
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      var favouritesModel = favouritesInfoBox.get(0);
      favourites = favouritesModel?.passwordList ?? [];
    } catch (e) {
      // ignore: avoid_print
      print('Error in fetching favourites data: $e');
    }
    return favourites;
  }

  Future<bool> addPasswordsToFavourites(PasswordModel passwordModel) async {
    try {
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      var favouritesModel = favouritesInfoBox.get(0);
      favouritesModel ??= FavoritesModel(favId: 0, passwordList: []);
      favouritesModel.passwordList.add(passwordModel);
      await favouritesInfoBox.put(0, favouritesModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePasswordFromFavouritesByPasswordId(String passwordId) async {
    try {
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      var favouritesModel = favouritesInfoBox.get(0);
      if (favouritesModel == null) {
        return false;
      }
      favouritesModel.passwordList.removeWhere((element) => element.passwordId == passwordId);
      await favouritesInfoBox.put(0, favouritesModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isPasswordInFavoritesByPasswordId(String passwordId) async {
    try {
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      var favouritesModel = favouritesInfoBox.get(0);
      if (favouritesModel == null) {
        return false;
      }
      return favouritesModel.passwordList.any((element) => element.passwordId == passwordId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllData() async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      var foldersInfoBox =
          await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      await CacheManager<PasswordModel>().deleteRecords(passwordsInfoBox);
      await CacheManager<FavoritesModel>().deleteRecords(favouritesInfoBox);
      await CacheManager<FolderModel>().deleteRecords(foldersInfoBox);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateThemeMode(bool val) async {
    try {
      var themeModeBox =
          await CacheManager<SystemPreferencesModel>().getBoxAsync(CacheTypes.systemInfoBox.name);
      var systemPreferencesModel = themeModeBox.get(0);
      systemPreferencesModel ??= SystemPreferencesModel(id: 0, isDarkMode: false);
      systemPreferencesModel.isDarkMode = val;
      await themeModeBox.put(0, systemPreferencesModel);
    } catch (e) {
      // ignore: avoid_print
      print('Error in updating theme mode: $e');
    }
  }

  Future<bool> getThemeMode() async {
    try {
      var themeModeBox =
          await CacheManager<SystemPreferencesModel>().getBoxAsync(CacheTypes.systemInfoBox.name);
      var systemPreferencesModel = themeModeBox.get(0);
      return systemPreferencesModel?.isDarkMode ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIsFirstLogin() async {
    try {
      var themeModeBox =
          await CacheManager<SystemPreferencesModel>().getBoxAsync(CacheTypes.systemInfoBox.name);
      var systemPreferencesModel = themeModeBox.get(0);
      return systemPreferencesModel?.isFirstLogin ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<void> updateFirstLogin(bool val) async {
    try {
      var themeModeBox =
          await CacheManager<SystemPreferencesModel>().getBoxAsync(CacheTypes.systemInfoBox.name);
      var systemPreferencesModel = themeModeBox.get(0);
      systemPreferencesModel ??= SystemPreferencesModel(id: 0, isDarkMode: false);
      systemPreferencesModel.isFirstLogin = val;
      await themeModeBox.put(0, systemPreferencesModel);
    } catch (e) {
      if (kDebugMode) {
        print('Error in updating first login: $e');
      }
    }
  }

  Future<bool> exportAllData() async {
    try {
      final passwordsInfo = await getPasswordsData();
      final favouritesInfo = await getFavouritesData();
      final foldersInfo = await getFoldersData();

      // Convert data to JSON format
      final passwordsJson = passwordsInfo.map((password) => password.toJson()).toList();
      final favouritesJson = favouritesInfo.map((favorite) => favorite.toJson()).toList();
      final foldersJson = foldersInfo.map((folder) => folder.toJson()).toList();

      final fileContent = {
        'passwordsInfo': passwordsJson,
        'favouritesInfo': favouritesJson,
        'foldersInfo': foldersJson,
      };
      final formattedDateTime = getFormattedTimeStampForFileName();
      final fileName = 'ExportData_$formattedDateTime';

      // Get the directory for saving images based on the platform
      Directory dir;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = Directory('/storage/emulated/0/Download');
      }
      final file = File('${dir.path}/$fileName');
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      await file.writeAsString(jsonEncode(fileContent)); // Write JSON content to file
      return true;
    } catch (e) {
      return false;
    }
  }

Future<bool> importDataFromFile(String filePath) async {
  try {
    // Read file content
    final file = File(filePath);
    final fileContent = await file.readAsString();
    
    // Parse JSON data
    final jsonData = jsonDecode(fileContent);
    final List<dynamic> passwordsJson = jsonData['passwordsInfo'];
    final List<dynamic> favouritesJson = jsonData['favouritesInfo'];
    final List<dynamic> foldersJson = jsonData['foldersInfo'];

    // Add passwords to cache
    for (var passwordJson in passwordsJson) {
      final passwordModel = PasswordModel(
        passwordId: passwordJson['passwordId'],
        passwordTitle: passwordJson['passwordTitle'],
        siteLink: passwordJson['siteLink'],
        savedPassword: passwordJson['savedPassword'],
        passwordDescription: passwordJson['passwordDescription'],
        createdAt: DateTime.parse(passwordJson['createdAt']), // Parse string to DateTime
        modifiedAt: DateTime.parse(passwordJson['modifiedAt']), // Parse string to DateTime
        folderId: passwordJson['folderId'],
      );
      await addEditPassword(passwordModel);
    }

    // Add folders to cache
    for (var folderJson in foldersJson) {
      final folderModel = FolderModel(
        folderId: folderJson['folderId'],
        folderName: folderJson['folderName'],
        createdAt: DateTime.parse(folderJson['createdAt']), // Parse string to DateTime
        passwordIds: List<String>.from(folderJson['passwordIds']),
      );
      await addEditFolder(folderModel);
    }

    // Add favorites to cache
    for (var favoriteJson in favouritesJson) {
      final passwordModel = PasswordModel(
        passwordId: favoriteJson['passwordId'],
        passwordTitle: favoriteJson['passwordTitle'],
        siteLink: favoriteJson['siteLink'],
        savedPassword: favoriteJson['savedPassword'],
        passwordDescription: favoriteJson['passwordDescription'],
        createdAt: DateTime.parse(favoriteJson['createdAt']), // Parse string to DateTime
        modifiedAt: DateTime.parse(favoriteJson['modifiedAt']), // Parse string to DateTime
      );
      await addPasswordsToFavourites(passwordModel);
    }
    return true;
  } catch (e) {
    return false;
  }
}

 Future<void> logPasswordHistory(PasswordModel password, String action) async {
    try {
      var historyBox = await CacheManager<HistoryModel>().getBoxAsync(CacheTypes.historyInfoBox.name);
      var historyEntry = HistoryModel(
        historyId: const Uuid().v4(),
        passwordId: password.passwordId,
        action: action,
        timestamp: DateTime.now(),
        passwordTitle: password.passwordTitle,
        siteLink: password.siteLink ?? '',
        savedPassword: password.savedPassword,
        passwordDescription: password.passwordDescription ?? '',
      );
      await historyBox.put(historyEntry.historyId, historyEntry);
    } catch (e) {
      if (kDebugMode) {
        print('Error logging password history: $e');
      }
    }
  }

  Future<List<HistoryModel>> getPasswordHistory() async {
    try {
      var historyBox = await CacheManager<HistoryModel>().getBoxAsync(CacheTypes.historyInfoBox.name);
      return historyBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching password history: $e');
      }
      return [];
    }
  }

  Future<void> deleteOldPasswordHistory(DateTime cutoffDate) async {
    var historyBox = await CacheManager<HistoryModel>().getBoxAsync(CacheTypes.historyInfoBox.name);
    var historyEntries = historyBox.values.toList();
    for (var historyEntry in historyEntries) {
      if (historyEntry.timestamp.isBefore(cutoffDate)) {
        await historyBox.delete(historyEntry.historyId);
      }
    }
  }

  // Folder-related functions
  Future<List<FolderModel>> getFoldersData() async {
    List<FolderModel> folders = [];
    try {
      var folderBox = await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      folders = folderBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching folder data: $e');
      }
    }
    return folders;
  }

  Future<bool> addEditFolder(FolderModel folder) async {
    try {
      var folderBox = await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      await folderBox.put(folder.folderId, folder);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding/editing folder: $e');
      }
      return false;
    }
  }

  Future<bool> deleteFolder(String folderId) async {
    try {
      var folderBox = await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      if (folderBox.containsKey(folderId)) {
        await folderBox.delete(folderId);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting folder: $e');
      }
      return false;
    }
  }

  // Get passwords by folderId
  Future<List<PasswordModel>> getPasswordsByFolder(String folderId) async {
    List<PasswordModel> passwords = [];
    try {
      var passwordBox = await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      passwords = passwordBox.values.where((password) => password.folderId == folderId).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching passwords by folder: $e');
      }
    }
    return passwords;
  }

  // Update Folder Record with new passwordId
  Future<bool> updateFolderRecord(FolderModel folderModel) async {
    try {
      var folderBox = await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      if (folderBox.containsKey(folderModel.folderId) == false) {
        return false;
      }
      await folderBox.put(folderModel.folderId, folderModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if folderId exists
  Future<bool> checkFolderIdExists(String folderId) async {
    try {
      var folderBox = await CacheManager<FolderModel>().getBoxAsync(CacheTypes.folderInfoBox.name);
      return folderBox.containsKey(folderId);
    } catch (e) {
      return false;
    }
  }
}
