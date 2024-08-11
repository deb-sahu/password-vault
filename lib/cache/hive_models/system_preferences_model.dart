import 'package:hive/hive.dart';
part 'system_preferences_model.g.dart';

@HiveType(typeId: 2)
class SystemPreferencesModel{

@HiveField(0)
int id;

@HiveField(1)
bool isDarkMode;

@HiveField(2)
bool? isFirstLogin;

SystemPreferencesModel({required this.id, required this.isDarkMode, this.isFirstLogin});
}