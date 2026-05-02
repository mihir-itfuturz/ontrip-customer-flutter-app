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
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            scrolledUnderElevation: 8,
            // leading: Container(
            //   margin: const EdgeInsets.all(8),
            //   child: const CustomBackBtn(),
            // ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                child: IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              // decoration: BoxDecoration(
              //   color: const Color(0xFFF1F5F9),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
              ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Constant.instance.primary,
                        Constant.instance.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Group Members",
                  style: AppTextStyle.bold.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              _buildHeader(controller),
              _buildSearchBar(controller),
              Expanded(
                child: Obx(() {
                  final _ = controller.searchQuery.value;
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      _buildInfoSection(),
                      _buildAgentsSection(controller),
                      _buildTravelersSection(controller),
                    ],
                  );
                }),
              ),
              SizedBox(height: 50,)
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(agent.name, roleColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        agent.name ?? "Unknown",
                        style: AppTextStyle.bold.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      // SizedBox(width: 10,),
                      Spacer(),
                       Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: roleColor.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                roleLabel,
                style: AppTextStyle.bold.copyWith(
                  fontSize: 12,
                  color: roleColor,
                ),
              ),
            ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agent.email ?? "",
                    style: AppTextStyle.medium.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: 10,),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: roleColor.withValues(alpha: 0.1),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(
            //       color: roleColor.withValues(alpha: 0.2),
            //     ),
            //   ),
            //   child: Text(
            //     roleLabel,
            //     style: AppTextStyle.bold.copyWith(
            //       fontSize: 12,
            //       color: roleColor,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelerTile(CustomerMember member, GroupMembersCtrl controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(member.name, Constant.instance.green2),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.name ?? "Unknown",
                        style: AppTextStyle.bold.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Spacer(),
                      Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Constant.instance.green2.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Constant.instance.green2.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 14,
                    color: Constant.instance.green2,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Traveler",
                    style: AppTextStyle.bold.copyWith(
                      fontSize: 12,
                      color: Constant.instance.green2,
                    ),
                  ),
                ],
              ),
            ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.email ?? "",
                    style: AppTextStyle.medium.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Constant.instance.green2.withValues(alpha: 0.1),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(
            //       color: Constant.instance.green2.withValues(alpha: 0.2),
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.verified_user_rounded,
            //         size: 14,
            //         color: Constant.instance.green2,
            //       ),
            //       const SizedBox(width: 4),
            //       Text(
            //         "Traveler",
            //         style: AppTextStyle.bold.copyWith(
            //           fontSize: 12,
            //           color: Constant.instance.green2,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? name, Color color) {
    final initial = (name?.isNotEmpty == true) ? name![0].toUpperCase() : "?";
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTextStyle.bold.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GroupMembersCtrl controller) {
    return Obx(() {
      final totalAgents = controller.filteredAgents.length;
      final totalTravelers = controller.filteredCustomers.length;
      final totalMembers = totalAgents + totalTravelers;
      
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.people_rounded,
                label: "Total Members",
                value: totalMembers.toString(),
                color: Constant.instance.primary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFE2E8F0),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.support_agent_rounded,
                label: "Agents",
                value: totalAgents.toString(),
                color: Constant.instance.orange,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFE2E8F0),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.luggage_rounded,
                label: "Travelers",
                value: totalTravelers.toString(),
                color: Constant.instance.green2,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyle.bold.copyWith(
            fontSize: 18,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyle.medium.copyWith(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(GroupMembersCtrl controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          style: AppTextStyle.medium.copyWith(
            fontSize: 15,
            color: const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: "Search members by name or email...",
            hintStyle: AppTextStyle.medium.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 15,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search_rounded,
                color: Constant.instance.primary.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Constant.instance.primary.withValues(alpha: 0.05),
            Constant.instance.primary.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Constant.instance.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constant.instance.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Constant.instance.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your agent manages who can send messages in this group.",
              style: AppTextStyle.medium.copyWith(
                fontSize: 14,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentsSection(GroupMembersCtrl controller) {
    if (controller.filteredAgents.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Constant.instance.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  color: Constant.instance.orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Agents",
                style: AppTextStyle.semiBold.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Constant.instance.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${controller.filteredAgents.length}",
                  style: AppTextStyle.bold.copyWith(
                    fontSize: 12,
                    color: Constant.instance.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...controller.filteredAgents.map((agent) => _buildAgentTile(agent)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTravelersSection(GroupMembersCtrl controller) {
    if (controller.filteredCustomers.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Constant.instance.green2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.luggage_rounded,
                  color: Constant.instance.green2,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Travelers",
                style: AppTextStyle.semiBold.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Constant.instance.green2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${controller.filteredCustomers.length}",
                  style: AppTextStyle.bold.copyWith(
                    fontSize: 12,
                    color: Constant.instance.green2,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...controller.filteredCustomers.map((member) => _buildTravelerTile(member, controller)),
      ],
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
