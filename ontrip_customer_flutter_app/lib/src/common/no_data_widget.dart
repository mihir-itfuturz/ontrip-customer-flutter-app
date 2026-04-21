import '../../app_export.dart';

class NoDataComponent extends StatelessWidget {
  final String? text;
  const NoDataComponent({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text ?? "No Data Available",
        style: AppTextStyle.semiBold.copyWith(
          fontSize: 13,
          color: Constant.instance.black,
        ),
      ),
    );
  }
}
