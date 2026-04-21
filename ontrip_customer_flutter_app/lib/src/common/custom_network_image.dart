import 'dart:io';
import '../../app_export.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? width, height, errorWidth, errorHeight;
  final double radius;
  final String? imageUrl, errorImage, otherImage;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Decoration? decoration;
  final BorderRadiusGeometry? borderRadius;
  final File? imageFile;

  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.radius = 0,
    this.fit,
    this.errorWidth,
    this.errorHeight,
    this.errorWidget,
    this.errorImage,
    this.otherImage,
    this.decoration,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageFile != null
            ? Image.file(imageFile!, width: width, height: height, fit: fit ?? BoxFit.fill)
            : imageUrl.notEmptyNotNull
            ? CachedNetworkImage(
                width: width,
                height: height,
                imageUrl: imageUrl!,
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator(value: downloadProgress.progress, strokeWidth: 2)),
                ),
                fit: fit ?? BoxFit.fill,
                errorWidget: (context, url, error) => SizedBox(width: errorWidth ?? width, height: errorHeight ?? height, child: errorWidget ?? Image.asset(errorImage ?? Graphics.instance.logo)),
                filterQuality: FilterQuality.high,
              )
            : SizedBox(
                width: width,
                height: height,
                child: Image.asset(otherImage ?? Graphics.instance.profileBackground, fit: BoxFit.fill, height: height, width: width),
              ),
      ),
    );
  }
}
