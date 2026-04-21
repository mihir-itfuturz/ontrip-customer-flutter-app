import 'dart:io';
import '../../app_export.dart';

class AppPermission {
  static Future<bool> storagePermission() async {
    bool havePermission = false;

    if (Platform.isAndroid) {
      final DeviceInfoPlugin info = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await info.androidInfo;
      final int androidVersion = androidInfo.version.sdkInt;
      if (androidVersion >= 33) {
        final request = await [Permission.videos, Permission.photos].request();
        havePermission = request.values.every((status) => status == PermissionStatus.granted);
      } else {
        final status = await Permission.storage.request();
        havePermission = status.isGranted;
      }
      if (!havePermission) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      final request = await [Permission.storage, Permission.mediaLibrary].request();
      havePermission = request.values.every((status) => status == PermissionStatus.granted);
      if (!havePermission) {
        await openAppSettings();
      }
    }
    return havePermission;
  }

  static Future<bool> contactPermission() async {
    final status = await Permission.contacts.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
      await openAppSettings();
      final status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> cameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
      final status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> microPhonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
      await openAppSettings();
      final status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
