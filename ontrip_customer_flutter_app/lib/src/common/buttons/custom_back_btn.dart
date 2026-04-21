import '../../../app_export.dart';

class CustomBackBtn<T> extends StatelessWidget {
  const CustomBackBtn({super.key, this.onTap, this.result, this.iconColor});
  final GestureTapCallback? onTap;
  final T? result;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap ?? () => backScreen(result: result),
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constant.instance.white,
          ),
          child: Center(
            child: SvgPicture.asset(
              width: 25,
              height: 25,
              Graphics.instance.iconBack,
            ),
          ),
        ),
      ),
    );
  }
}
