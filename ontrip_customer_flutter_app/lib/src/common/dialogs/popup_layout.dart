import '../../../app_export.dart';

class PopupContent extends StatelessWidget {
  const PopupContent({super.key, this.height, this.width, this.child, this.maxWidth});

  final double? height, maxWidth;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 0, maxHeight: height ?? 280, maxWidth: maxWidth ?? double.maxFinite),
      child: SizedBox(child: child),
    );
  }
}

class PopupHeader extends StatelessWidget {
  final GestureTapCallback? onSearch;
  final bool isSearch;
  final String headerTitle;
  final TextStyle? headerStyle;

  final Widget? end, start;
  final double startDistance;

  const PopupHeader({
    super.key,
    required this.headerTitle,
    this.headerStyle,
    this.onSearch,
    this.isSearch = false,
    this.end,
    this.start,
    this.startDistance = 0,
  }) : assert((isSearch == true && onSearch != null) || (isSearch == false && onSearch == null), "if isSearch = true then must applied onSearch : ErrorMsg");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (start != null) start ?? SizedBox.shrink(),
                  Constant.instance.square.copyWith(height: 0, width: startDistance),
                  Text(headerTitle, style: headerStyle ?? AppTextStyle.medium.copyWith(fontSize: 15.5)),
                ],
              ),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSearch)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onSearch,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              "assets/icons/Search.svg",
                              height: 14,
                              width: 14,
                              colorFilter: ColorFilter.mode(Constant.instance.grey600, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Utils.horizontalDivider(height: 0, padding: const EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}

class PopupFooter extends StatelessWidget {
  final double radius;
  final GestureTapCallback onSave;
  final GestureTapCallback? onCancel;
  final bool isLoading, isLoadingOnCancel;
  final String saveText, cancelText;
  final TextStyle? saveStyle, cancelStyle;

  const PopupFooter({
    super.key,
    required this.onSave,
    this.onCancel,
    this.radius = 8,
    this.isLoading = false,
    this.isLoadingOnCancel = false,
    this.saveText = "Save",
    this.cancelText = "Cancel",
    this.saveStyle,
    this.cancelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Constant.instance.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Utils.horizontalDivider(height: 0, thickness: 1.5),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radius))),
                    ),
                    onPressed: isLoadingOnCancel ? null : (onCancel ?? () => backScreen()),
                    child: !isLoadingOnCancel
                        ? Text(cancelText, style: cancelStyle ?? AppTextStyle.semiBold.copyWith(color: Constant.instance.grey600, fontSize: 14))
                        : CustomLoadingIndicator(),
                  ),
                ),
              ),
              Container(width: 1.2, height: 40, color: Constant.instance.grey100),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(radius))),
                    ),
                    onPressed: !isLoading ? onSave : null,
                    child: !isLoading
                        ? Text(saveText, style: saveStyle ?? AppTextStyle.semiBold.copyWith(color: Constant.instance.black, fontSize: 14))
                        : const CustomLoadingIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
