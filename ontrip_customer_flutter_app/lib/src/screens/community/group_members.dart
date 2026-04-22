import '../../../../../app_export.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupMembersCtrl>(
      init: GroupMembersCtrl(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const CustomBackBtn(),
            title: Text("Group members", style: AppTextStyle.bold.copyWith(fontSize: 18, color: const Color(0xFF1E293B))),
            centerTitle: false,
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search members",
                      hintStyle: AppTextStyle.medium.copyWith(color: const Color(0xFFB0BEC5), fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFB0BEC5), size: 18),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Obx(() {
                  // read searchQuery to trigger rebuilds
                  final _ = controller.searchQuery.value;
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      // ── TRAVELER MESSAGING SECTION ──
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("TRAVELER MESSAGING", style: AppTextStyle.bold.copyWith(fontSize: 11, color: const Color(0xFF475569), letterSpacing: 1.0)),
                            // const SizedBox(height: 6),
                            // Text(
                            //   "Control who can send text and photos in this chat (all travelers or selected only).",
                            //   style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF94A3B8)),
                            // ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Your agent manage who can send messages in this group.",
                                    style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF64748B)),
                                  ),
                                  // TextSpan(
                                  //   text: "Turn the switch on to allow everyone again.",
                                  //   style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF4338CA)),
                                  // ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 12),
                            // Toggle Row
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(12),
                            //     border: Border.all(color: const Color(0xFFE2E8F0)),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text("All travelers can send", style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                            //       Obx(
                            //         () => controller.isUpdating.value
                            //             ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            //             : Checkbox(
                            //                 value: controller.allTravelersCanSend.value,
                            //                 activeColor: const Color(0xFF4338CA),
                            //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            //                 onChanged: (val) => controller.toggleGlobal(val ?? false),
                            //               ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Info Text when global is OFF
                            // if (!controller.allTravelersCanSend.value) ...[
                            //   const SizedBox(height: 8),
                            //   RichText(
                            //     text: TextSpan(
                            //       children: [
                            //         TextSpan(
                            //           text: "Only travelers with \"Can send\" below may post. ",
                            //           style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF64748B)),
                            //         ),
                            //         TextSpan(
                            //           text: "Turn the switch on to allow everyone again.",
                            //           style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF4338CA)),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ],
                          ],
                        ),
                      ),

                      // ── AGENTS SECTION ──
                      SizedBox(height: 20),
                      if (controller.filteredAgents.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Text("Agents", style: AppTextStyle.medium.copyWith(fontSize: 13, color: const Color(0xFF64748B))),
                        ),
                        ...controller.filteredAgents.map((agent) => _buildAgentTile(agent)),
                      ],

                      SizedBox(height: 20),
                      if (controller.filteredCustomers.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Text("Travelers", style: AppTextStyle.medium.copyWith(fontSize: 13, color: const Color(0xFF64748B))),
                        ),
                        ...controller.filteredCustomers.map((member) => _buildTravelerTile(member, controller)),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgentTile(AgentMember agent) {
    final roleLabel = _formatRole(agent.role);
    final roleColor = _roleColor(agent.role);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          _buildAvatar(agent.name, const Color(0xFF4338CA)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(agent.name ?? "Unknown", style: AppTextStyle.bold.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(agent.email ?? "", style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF94A3B8))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
            child: Text(roleLabel, style: AppTextStyle.bold.copyWith(fontSize: 11, color: roleColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerTile(CustomerMember member, GroupMembersCtrl controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          _buildAvatar(member.name, const Color(0xFF0F172A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name ?? "Unknown", style: AppTextStyle.bold.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(member.email ?? "", style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF94A3B8))),
              ],
            ),
          ),
          // Badge scoped inside its own Obx
          // Obx(() {
          //   final canSend = controller.canTravelerSend(member.id);
          //   return GestureDetector(
          //     onTap: controller.isUpdating.value ? null : () => controller.toggleTraveler(member),
          //     child: AnimatedContainer(
          //       duration: const Duration(milliseconds: 200),
          //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          //       decoration: BoxDecoration(
          //         color: canSend ? const Color(0xFF4338CA).withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Text(
          //         canSend ? "Can send" : "Muted",
          //         style: AppTextStyle.bold.copyWith(fontSize: 12, color: canSend ? const Color(0xFF4338CA) : const Color(0xFF94A3B8)),
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? name, Color color) {
    final initial = (name?.isNotEmpty == true) ? name![0].toUpperCase() : "?";
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Center(
        child: Text(initial, style: AppTextStyle.bold.copyWith(fontSize: 15, color: color)),
      ),
    );
  }

  String _formatRole(String? role) {
    if (role == null) return "Member";
    switch (role) {
      case 'parent_agent':
        return 'Parent Agent';
      case 'child_agent':
        return 'Child Agent';
      case 'sub_child_agent':
        return 'Sub Child Agent';
      case 'admin':
        return 'Admin';
      default:
        return role.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');
    }
  }

  Color _roleColor(String? role) {
    switch (role) {
      case 'parent_agent':
        return const Color(0xFF4338CA);
      case 'child_agent':
        return const Color(0xFF0891B2);
      case 'sub_child_agent':
        return const Color(0xFF7E22CE);
      case 'admin':
        return const Color(0xFF475569);
      default:
        return const Color(0xFF64748B);
    }
  }
}
