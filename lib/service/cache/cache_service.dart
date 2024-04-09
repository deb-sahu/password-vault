import 'package:password_vault/cache/cache_manager.dart';
import 'package:password_vault/cache/hive_models/favourites_model.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';

class CacheService {

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

  Future<bool> addEditPassword(PasswordModel passwordsInfo) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      await passwordsInfoBox.put(passwordsInfo.passwordId, passwordsInfo);
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
      await CacheService().removePasswordFromFavouritesByPasswordId(passwordId);
      await passwordsInfoBox.delete(passwordId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future <bool> checkPasswordIdExists(String passwordId) async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      return passwordsInfoBox.containsKey(passwordId);
    } catch (e) {
      return false;
    }
  }
  
    Future <List<PasswordModel>> getFavouritesData() async {
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

  Future <bool> addPasswordsToFavourites(PasswordModel passwordModel) async {
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

Future <bool> removePasswordFromFavouritesByPasswordId(String passwordId) async {
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
 Future <bool> isPasswordInFavoritesByPasswordId(String passwordId) async {
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

Future <bool> clearAllData() async {
    try {
      var passwordsInfoBox =
          await CacheManager<PasswordModel>().getBoxAsync(CacheTypes.passwordsInfoBox.name);
      var favouritesInfoBox =
          await CacheManager<FavoritesModel>().getBoxAsync(CacheTypes.favouritesInfoBox.name);
      await CacheManager<PasswordModel>().deleteRecords(passwordsInfoBox);
      await CacheManager<FavoritesModel>().deleteRecords(favouritesInfoBox);
      return true;
    } catch (e) {
      return false;
    }
  }

}
