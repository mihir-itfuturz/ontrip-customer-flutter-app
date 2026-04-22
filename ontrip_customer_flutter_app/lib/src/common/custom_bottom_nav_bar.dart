import '../../app_export.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTabChange});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;

  final List<NavItem> _navItems = [
    NavItem(
      iconAsset: Graphics.instance.iconHome,
      activeIconAsset: Graphics.instance.iconHomeFill,
      label: 'Trip',
      activeColor: Constant.instance.primary,
      iconType: NavIconType.icon,
    ),
    NavItem(
      iconAsset: Graphics.instance.iconHistory,
      activeIconAsset: Graphics.instance.iconHistory,
      label: 'History',
      activeColor: Constant.instance.primary,
      iconType: NavIconType.icon,
    ),
    NavItem(
      iconAsset: Graphics.instance.iconCommunity,
      activeIconAsset: Graphics.instance.iconCommunity,
      label: 'Community',
      activeColor: Constant.instance.primary,
      iconType: NavIconType.icon,
    ),
    NavItem(
      iconAsset: Graphics.instance.iconProfile,
      activeIconAsset: Graphics.instance.iconProfile,
      label: 'Profile',
      activeColor: Constant.instance.primary,
      iconType: NavIconType.icon,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationControllers = List.generate(_navItems.length, (index) => AnimationController(duration: const Duration(milliseconds: 300), vsync: this));
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationControllers[oldWidget.currentIndex].reverse();
      if (widget.currentIndex < _animationControllers.length) {
        _animationControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
  //       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5), spreadRadius: 0)],
  //     ),
  //     child: SafeArea(
  //       child: ClipRRect(
  //         borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: List.generate(_navItems.length, (index) {
  //               return _buildNavItem(index);
  //             }),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Constant.instance.grey200,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              return _buildMinimalNavItem(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalNavItem(int index) {
    final isActive = widget.currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => widget.onTabChange(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: isActive ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              isActive ? item.activeIconAsset! : item.iconAsset!,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(isActive ? Constant.instance.primary : Colors.grey, BlendMode.srcIn),
            ),
          ),

          const SizedBox(height: 6),

          /// Label (like image – subtle)
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? Constant.instance.primary : Colors.grey),
            child: Text(item.label),
          ),
          const SizedBox(height: 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: isActive ? 10 : 0,
                decoration: BoxDecoration(
                  color: Constant.instance.primary,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                width: isActive ? 30 : 0,
                decoration: BoxDecoration(color: Constant.instance.primary, borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildNavItem(int index) {
  //   final isActive = widget.currentIndex == index;
  //   final item = _navItems[index];
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () => widget.onTabChange(index),
  //       behavior: HitTestBehavior.opaque,
  //       child: AnimatedBuilder(
  //         animation: _animationControllers[index],
  //         builder: (context, child) {
  //           return Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //             decoration: BoxDecoration(
  //               color: isActive ? item.activeColor.withValues(alpha: 0.1) : Colors.transparent,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 AnimatedContainer(
  //                   duration: const Duration(milliseconds: 250),
  //                   curve: Curves.easeOutCubic,
  //                   width: 35,
  //                   height: 35,
  //                   decoration: BoxDecoration(shape: BoxShape.rectangle),
  //                   child: _buildIcon(item, isActive),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 AnimatedDefaultTextStyle(
  //                   duration: const Duration(milliseconds: 200),
  //                   style: TextStyle(
  //                     fontSize: isActive ? 11 : 10,
  //                     fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
  //                     color: isActive ? item.activeColor : Colors.grey.shade600,
  //                   ),
  //                   child: AnimatedOpacity(
  //                     opacity: isActive ? 1.0 : 0.7,
  //                     duration: const Duration(milliseconds: 200),
  //                     child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildIcon(NavItem item, bool isActive) {
  //   final iconSize = isActive ? 25.0 : 20.0;
  //   return AnimatedScale(
  //     scale: isActive ? 1.1 : 1.0,
  //     duration: const Duration(milliseconds: 200),
  //     child: SvgPicture.asset(
  //       isActive ? item.activeIconAsset! : item.iconAsset!,
  //       width: iconSize,
  //       height: iconSize,
  //       colorFilter: ColorFilter.mode(isActive ? item.activeColor : Colors.grey.shade400, BlendMode.srcIn),
  //     ),
  //   );
  // }
}

enum NavIconType { icon, scanButton }

class NavItem {
  final String? iconAsset;
  final String? activeIconAsset;
  final String label;
  final Color activeColor;
  final NavIconType iconType;

  NavItem({this.iconAsset, this.activeIconAsset, required this.label, required this.activeColor, required this.iconType});
}
