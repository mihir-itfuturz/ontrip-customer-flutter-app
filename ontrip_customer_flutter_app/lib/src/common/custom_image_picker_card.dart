import 'dart:io';
import '../../app_export.dart';

class CustomImagePickerCard extends StatelessWidget {
  const CustomImagePickerCard({
    super.key,
    this.onTap,
    this.imageFile,
    this.imageUrl,
  });

  final File? imageFile;
  final String? imageUrl;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Constant.instance.grey200, width: 0.7),
          borderRadius: BorderRadius.circular(6),
          color: Constant.instance.black.withValues(alpha: 0.07),
        ),
        child: imageFile != null
            ? Image.file(imageFile!, fit: BoxFit.cover)
            : imageUrl.notEmptyNotNull
                ? CustomNetworkImage(width: 70, height: 70, imageUrl: imageUrl)
                : Icon(Icons.add, color: Constant.instance.grey400),
      ),
    );
  }
}
