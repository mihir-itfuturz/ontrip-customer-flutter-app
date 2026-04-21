import '../../../app_export.dart';

class DeletionConfirmationDialog extends StatefulWidget {
  const DeletionConfirmationDialog({
    super.key,
    this.titleStyle,
    this.subtitleStyle,
    required this.title,
    required this.subtitle,
    this.isDeleteLoading = false,
    this.onDelete,
  });

  final TextStyle? titleStyle, subtitleStyle;
  final GestureTapCallback? onDelete;
  final String title, subtitle;
  final bool isDeleteLoading;

  @override
  State<DeletionConfirmationDialog> createState() => _DeletionConfirmationDialogState();
}

class _DeletionConfirmationDialogState extends State<DeletionConfirmationDialog> with TickerProviderStateMixin {
  late AnimationController _animationController, _iconController;
  late Animation<double> _scaleAnimation, _fadeAnimation, _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _iconController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _iconController, curve: Curves.bounceOut));
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _iconController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 25, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),
                      AnimatedBuilder(
                        animation: _iconController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _iconAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0xFFFF6B6B).withValues(alpha: 0.1), const Color(0xFFFF5252).withValues(alpha: 0.15)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFFF5252).withValues(alpha: 0.2), width: 2),
                              ),
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(color: const Color(0xFFFF5252).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                                  child: Icon(Icons.delete_forever_rounded, size: 28, color: const Color(0xFFFF5252)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: widget.titleStyle ?? TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey.shade800, height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: widget.subtitleStyle ?? TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey.shade600, height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      backScreen();
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: const Color(0xFFFF5252).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: widget.isDeleteLoading
                                        ? null
                                        : () {
                                            HapticFeedback.mediumImpact();
                                            widget.onDelete?.call();
                                          },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child: widget.isDeleteLoading
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  "Deleting...",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.delete_outline, size: 20, color: Colors.white),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Yes, Delete",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
