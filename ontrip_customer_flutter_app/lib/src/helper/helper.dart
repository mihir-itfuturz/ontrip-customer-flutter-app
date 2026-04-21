// import 'dart:async';
// import 'dart:io';

// class Helper {
//   final ImagePicker _picker = ImagePicker();

//   Future<int> getFileSize(String filePath) async {
//     try {
//       File file = File(filePath);
//       if (await file.exists()) {
//         int fileSize = await file.length();
//         return fileSize;
//       } else {
//         Fluttertoast.showToast(msg: 'File not found');
//         return 0;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//       return 0;
//     }
//   }

//   Future<File?> pickImage({ImageSource? source}) async {
//     try {
//       final XFile? file = await _picker.pickImage(source: source ?? ImageSource.camera);
//       if (file != null) {
//         return File(file.path);
//       }
//       return null;
//     } catch (err) {
//       Fluttertoast.showToast(msg: "Error while clicking image!");
//       return null;
//     }
//   }

//   Future<File?> cropImageByPath(String imagePath, BuildContext context) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: imagePath,
//       compressFormat: ImageCompressFormat.jpg,
//       compressQuality: 100,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Cropper',
//           toolbarColor: Theme.of(context).primaryColor,
//           toolbarWidgetColor: Colors.white,
//           statusBarColor: Theme.of(context).primaryColor,
//           backgroundColor: Colors.black,
//           hideBottomControls: false,
//           lockAspectRatio: false,
//           initAspectRatio: CropAspectRatioPreset.original,
//           aspectRatioPresets: [CropAspectRatioPreset.original, CropAspectRatioPreset.square],
//           cropFrameStrokeWidth: 2,
//           showCropGrid: true,
//           cropStyle: CropStyle.rectangle,
//         ),
//         IOSUiSettings(title: 'Cropper'),
//       ],
//     );
//     return croppedFile != null ? File(croppedFile.path) : null;
//   }

//   Future<ShareResult?> shareFile({required List<File?> files}) async {
//     if (files.isNotEmpty) {
//       try {
//         final file = <XFile>[];
//         for (var e in files) {
//           if (e != null) {
//             file.add(XFile(e.path));
//           }
//         }
//         return await Share.shareXFiles(file);
//       } catch (e) {
//         warningToast("Error : $e");
//         return null;
//       }
//     } else {
//       warningToast("File not found");
//       return null;
//     }
//   }

//   String formatCurrency(dynamic amount) {
//     if (amount == null) return '0';
//     final value = double.tryParse(amount.toString()) ?? 0.0;
//     if (value >= 10000000) {
//       return '${(value / 10000000).toStringAsFixed(1)}Cr';
//     } else if (value >= 100000) {
//       return '${(value / 100000).toStringAsFixed(1)}L';
//     } else if (value >= 1000) {
//       return '${(value / 1000).toStringAsFixed(1)}K';
//     }
//     return value.toStringAsFixed(0);
//   }

//   String formatTimestamp(String timestamp) {
//     final dateTime = DateTime.parse(timestamp);
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else {
//       return '${difference.inDays}d ago';
//     }
//   }
// }

// Helper helper = Helper();
