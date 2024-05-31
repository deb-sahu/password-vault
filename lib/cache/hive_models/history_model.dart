import 'package:hive/hive.dart';
part 'history_model.g.dart';

@HiveType(typeId: 3)
class HistoryModel {
  @HiveField(0)
  String historyId;

  @HiveField(1)
  String passwordId;

  @HiveField(2)
  String action; // 'added', 'updated', 'deleted'

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String passwordTitle;

  @HiveField(5)
  String siteLink;

  @HiveField(6)
  String savedPassword;

  @HiveField(7)
  String passwordDescription;

  HistoryModel({
    required this.historyId,
    required this.passwordId,
    required this.action,
    required this.timestamp,
    required this.passwordTitle,
    required this.siteLink,
    required this.savedPassword,
    required this.passwordDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'historyId': historyId,
      'passwordId': passwordId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'passwordTitle': passwordTitle,
      'siteLink': siteLink,
      'savedPassword': savedPassword,
      'passwordDescription': passwordDescription,
    };
  }
}
