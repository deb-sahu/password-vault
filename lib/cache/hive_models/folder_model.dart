
import 'package:hive/hive.dart';
part 'folder_model.g.dart';

@HiveType(typeId: 4)
class FolderModel {
  @HiveField(0)
  String folderId;

  @HiveField(1)
  String folderName;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  List<String> passwordIds; // List of password IDs in the folder

  FolderModel({
    required this.folderId,
    required this.folderName,
    required this.createdAt,
    required this.passwordIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'folderName': folderName,
      'createdAt': createdAt.toIso8601String(),
      'passwordIds': passwordIds,
    };
  }
}
