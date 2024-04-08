import 'package:camera/camera.dart';

class CameraDescriptionHelperService {
  List<CameraDescription>? _cameras;

  static final CameraDescriptionHelperService _singleton =
      CameraDescriptionHelperService._internal();

  factory CameraDescriptionHelperService() {
    return _singleton;
  }
  Future<void> setAvailableCameras(List<CameraDescription>? cameras) async {
    if (cameras!.isEmpty) {
      cameras.add(const CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ));
    }
    _cameras = cameras;
  }

  List<CameraDescription>? getAvailableCameras() {
    return _cameras;
  }

  CameraDescriptionHelperService._internal();
}
