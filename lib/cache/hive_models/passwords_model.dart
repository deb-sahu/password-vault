import 'package:hive/hive.dart';
part 'passwords_model.g.dart';

@HiveType(typeId: 0)
class PasswordModel {
  @HiveField(0)
  String passwordId;

  @HiveField(1)
  String passwordTitle;

  @HiveField(2)
  String? siteLink;

  @HiveField(3)
  String savedPassword;

  @HiveField(4)
  String? passwordDescription;

  @HiveField(5)
  DateTime? createdAt;

  @HiveField(6)
  DateTime? modifiedAt;

  // @HiveField(7)
  // Icon? passwordIcon;

  PasswordModel({
    required this.passwordId,
    required this.passwordTitle,
    required this.siteLink,
    required this.savedPassword,
    required this.passwordDescription,
    required this.createdAt,
    required this.modifiedAt,
    //required this.passwordIcon,
  });

  Map<String, dynamic> toJson() {
    return {
      'passwordId': passwordId,
      'passwordTitle': passwordTitle,
      'siteLink': siteLink,
      'savedPassword': savedPassword,
      'passwordDescription': passwordDescription,
      'createdAt': createdAt?.toIso8601String(), // Convert DateTime to string
      'modifiedAt': modifiedAt?.toIso8601String(), // Convert DateTime to string
    };
  }
}
