// import 'dart:io';
// import '../../app_export.dart';

// class AppShare {
//   AppShare._();

//   final instance = AppShare._();

//   static final _share = SharePlus.instance;

//   static Future<ShareResult?> shareUrl(String? url) async {
//     if (url.notEmptyNotNull) {
//       final uri = Uri.parse(url!.trim());
//       try {
//         return await _share.share(ShareParams(uri: uri));
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Error : $e");
//         return null;
//       }
//     } else {
//       Fluttertoast.showToast(msg: "url not found");
//       return null;
//     }
//   }

//   static Future<ShareResult?> shareText(String? text) async {
//     if (text.notEmptyNotNull) {
//       try {
//         return await _share.share(ShareParams(text: text));
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Error : $e");
//         return null;
//       }
//     } else {
//       Fluttertoast.showToast(msg: "text not found");
//       return null;
//     }
//   }

//   static Future<ShareResult?> shareFile({required List<File?> files, String? text, String? url}) async {
//     if (files.isNotEmpty) {
//       try {
//         final file = <XFile>[];
//         for (var e in files) {
//           if (e != null) {
//             file.add(XFile(e.path));
//           }
//         }
//         late Uri uri;
//         if (url.notEmptyNotNull) {
//           uri = Uri.parse(url!);
//         }
//         return await _share.share(ShareParams(files: file.isNotEmpty ? file : null, text: text, uri: url.notEmptyNotNull ? uri : null));
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Error : $e");
//         return null;
//       }
//     } else {
//       Fluttertoast.showToast(msg: "File not found");
//       return null;
//     }
//   }
// }
