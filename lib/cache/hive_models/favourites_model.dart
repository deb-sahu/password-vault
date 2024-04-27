import 'package:hive/hive.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';
part 'favourites_model.g.dart';

@HiveType(typeId: 1)
class FavoritesModel {
  @HiveField(0)
  int favId;

  @HiveField(1)
  List<PasswordModel> passwordList;

  FavoritesModel({
    required this.favId,
    required this.passwordList,
  });

  Map<String, dynamic> toJson() {
    return {
      'favId': favId,
      'passwordList': passwordList,
    };
  }
}
