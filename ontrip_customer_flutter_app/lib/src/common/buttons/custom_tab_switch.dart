import '../../../app_export.dart';

class CustomTabSwitch extends StatelessWidget {
  const CustomTabSwitch({
    super.key,
    required this.onLeft,
    required this.onRight,
    this.activeIndex = 0,
    this.btnHeight = 35,
    this.leftPrefix,
    this.leftSuffix,
    this.rightPrefix,
    this.rightSuffix,
    this.leftText,
    this.rightText,
  });
  final ValueChanged<int> onLeft;
  final ValueChanged<int> onRight;
  final int activeIndex;
  final double btnHeight;
  final Widget? leftPrefix, leftSuffix, rightPrefix, rightSuffix;
  final String? leftText, rightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant.instance.primary15,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBtn(
            height: btnHeight,
            onTap: () => onLeft(0),
            text: leftText ?? "Left",
            prefix: leftPrefix,
            suffix: leftSuffix,
            bgColor: activeIndex == 0 ? null : Constant.instance.primary15,
            borderColor: activeIndex == 0 ? null : Constant.instance.transparent,
            style: AppTextStyle.semiBold.copyWith(
              fontSize: activeIndex == 0 ? 13 : 12,
              fontWeight: activeIndex == 0 ? FontWeight.w700 : FontWeight.w400,
              color: activeIndex == 0 ? Constant.instance.white : Constant.instance.black,
            ),
          ),
          const SizedBox(width: 5),
          CustomBtn(
            height: btnHeight,
            onTap: () => onRight(1),
            text: rightText ?? "Right",
            prefix: rightPrefix,
            suffix: rightSuffix,
            bgColor: activeIndex == 1 ? null : Constant.instance.primary15,
            borderColor: activeIndex == 1 ? null : Constant.instance.transparent,
            style: AppTextStyle.semiBold.copyWith(
              fontSize: 13,
              fontWeight: activeIndex == 1 ? FontWeight.w700 : FontWeight.w400,
              color: activeIndex == 1 ? Constant.instance.white : Constant.instance.black,
            ),
          )
        ],
      ),
    );
  }
}
