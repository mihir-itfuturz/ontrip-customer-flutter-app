class BACKEND {
  /// Auth
  static const signIn = 'mobile/member/sign-in';
  static const signUp = 'admin/user-card/save-public';
  static const deleteAccount = 'mobile/delete-account';

  static const banners = 'mobile/banners';

  /// Duty attendance
  static const _attendanceManagement = 'mobile/attendance';
  static const String getEmployee = 'mobile/employee/get';
  static const String updateProfileImageLockProfile = 'mobile/employee/updateProfileImageLockProfile';
  static const String getMyAttendanceRange = '$_attendanceManagement/my-list-range';
  static const String getMyAttendanceDetails = '$_attendanceManagement/my-details';
  static const String getHolidaysByDateRange = '$_attendanceManagement/holidays';
  static const String getEmployeesOnLeave = '$_attendanceManagement/employees-on-leave';
  static const String getEmployeeLeaveHistory = 'mobile/employee/leave/history';
  static const String getMyPaidLeaveBalance = '$_attendanceManagement/my-paid-leave-balance';
  static const String applyLeaveMultipleDates = '$_attendanceManagement/apply-leave';
  static const String listAttendance = '$_attendanceManagement/list';
  static const String attendanceCheck = '$_attendanceManagement/check';
  static const String attendanceStatus = '$_attendanceManagement/status';
  static const String getAssignedOffices = '$_attendanceManagement/getAssignedOffices';

  /// Task Management
  static const _taskManagement = 'mobile/task-management/dashboard';
  static const recentActivities = '$_taskManagement/recent-activities';
  static const recentlyCreatedTasks = '$_taskManagement/recently-created-tasks';

  /// Role Management
  static const _roleManagement = 'web/task';
  static const taskStats = '$_roleManagement/dashboard/stats';
  static const employeeDayWiseTasks = '$_roleManagement/dashboard/employee-day-wise-tasks';
  static const memberAllTasks = '$_roleManagement/dashboard/member-all-tasks';
  static const memberCompletedTasks = '$_roleManagement/dashboard/member-completed-tasks';
  static const memberDeletedTasks = '$_roleManagement/dashboard/member-deleted-tasks';
  static const getAllMember = "$_roleManagement/teamMember/getAll";
  static const updateMemberRole = "$_roleManagement/teamMember/changeRole";
  static const addMemberRole = "$_roleManagement/teamMember/add";
  static const updateMember = "$_roleManagement/teamMember/update-member";
  static const getCurrentUser = "$_roleManagement/get-current-user";
  static const teamMemberUpdate = "$_roleManagement/teamMember/update";
  static const deleteMemberRole = "$_roleManagement/teamMember/delete";
  static const resendInvitation = "$_roleManagement/teamMember/resend-invitation";
  static const teamMemberStatusToggle = "$_roleManagement/teamMember/status/toggle";
  static const getRoleMaster = "$_roleManagement/role-master/list";
  static const createRoleMaster = "$_roleManagement/role-master/create";
  static const updateRoleMaster = "$_roleManagement/role-master/update";
  static const deleteRoleMaster = "$_roleManagement/role-master/delete";
  static const availableProducts = "web/user/available-products";
  static const teamMemberProducts = "web/user/team-member-products";
  static const manageMemberProducts = "web/user/manage-member-products";
  static const getDailyUpdates = "$_roleManagement/daily-update/get-entries";
  static const dailyUpdateFields = "$_roleManagement/daily-update/fields";
  static const dailySubmit = "$_roleManagement/daily-update/submit";
  static const fieldsManage = "$_roleManagement/daily-update/fields/manage";

  /// Web Task Management
  static const _webTaskManagement = 'web/task';
  static const memberSignIn = "$_webTaskManagement/sign-in";
  static const memberAllBoard = "$_webTaskManagement/board/joined";
  static const getSelectableTeamMembers = "$_webTaskManagement/teamMember/getSelectableTeamMembers";
  static const boardDetails = '$_webTaskManagement/board/get-details';
  static const getAllTeams = '$_webTaskManagement/team/get-all';
  static const addTeam = '$_webTaskManagement/team/add';
  static const deleteTeam = '$_webTaskManagement/team/delete';
  static const reorderTeam = '$_webTaskManagement/team/reorder';
  static const createTeam = '$_webTaskManagement/team/create-bulk';
  static const teamBoardMemberUpdate = '$_webTaskManagement/board/member/update';
  static const updateBoardCategories = '$_webTaskManagement/board/categories/update';
  static const getAvailableBoardMembers = '$_webTaskManagement/board/members/available';

  static const getTaskDetails = '$_webTaskManagement/team/get-details';
  static const updateTaskStatus = '$_webTaskManagement/team/update/status';
  static const updateTaskCategory = '$_webTaskManagement/team/update/category';
  static const updateTaskDueDate = '$_webTaskManagement/team/update/due-date';
  static const updateTaskPriority = '$_webTaskManagement/team/update/priority';
  static const updateTaskAssignment = '$_webTaskManagement/team/update/assignment';
  static const updateTaskTitle = '$_webTaskManagement/team/update/title';
  static const updateTaskDescription = '$_webTaskManagement/team/update/description';
  static const addComment = '$_webTaskManagement/team/comment/add';
  static const addTeamAttachment = '$_webTaskManagement/attachment/add';
  static const deleteTeamAttachment = '$_webTaskManagement/attachment/delete';

  /// Web Task Management
  static const _webGoalTracking = 'web/goal-tracking';
  static const goalDashboard = '$_webGoalTracking/dashboard';
  static const createGoal = '$_webGoalTracking/create';
  static const addActivityGoal = '$_webGoalTracking/activity/add';
  static const getGoals = '$_webGoalTracking/get';
  static const cancelGoal = '$_webGoalTracking/cancel';
  static const historyGoals = '$_webGoalTracking/history';

  /// Web Support Tickets
  static const webSupportCategories = 'web/support-tickets/categories';
  static const createSupportCategory = 'web/support-tickets/categories/create';
  static const updateSupportCategory = 'web/support-tickets/categories/update';
  static const deleteSupportCategory = 'web/support-tickets/categories/delete';
  static const webSupportTemplates = 'web/support-tickets/templates';
  static const createSupportTemplate = 'web/support-tickets/templates/create';
  static const updateSupportTemplate = 'web/support-tickets/templates/update';
  static const deleteSupportTemplate = 'web/support-tickets/templates/delete';
  static const webSupportTickets = 'web/support-tickets';
  static const createTicket = 'web/support-ticket';
  static const deleteTicket = 'web/delete/support-ticket';
  static const resolveTicket = 'web/resolve/support-ticket';
  static const inProgressSupportTicket = 'web/in-progress/support-ticket';

  /// Web Google Review
  static const getReviews = 'web/review/getReviews';
  static const addReview = 'web/review/add';
  static const deleteReview = 'web/review/delete';

  /// Office Management
  static const _officeManagement = 'mobile/office';
  static const getAllOffice = '$_officeManagement/getAll';
  static const createOffice = '$_officeManagement/create';
  static const updateOffice = '$_officeManagement/update';
  static const deleteOffice = '$_officeManagement/delete';

  /// Employee Management
  static const _employeesManagement = 'web/employee';
  static const getEmployees = 'web/employees/get';
  static const createEmployee = '$_employeesManagement/create';
  static const updateEmployee = '$_employeesManagement/update';
  static const deleteEmployee = '$_employeesManagement/delete';

  /// Project Boards Management
  static const _projectBoardsManagement = 'web/task/';
  static const String getTasks = '$_projectBoardsManagement/personal/all';
  static const String getAllBoards = '$_projectBoardsManagement/board/all';
  static const String createBoard = '$_projectBoardsManagement/board/create';
  static const String updateBoard = '$_projectBoardsManagement/board/update';
  static const String deleteBoard = '$_projectBoardsManagement/board/delete';
  static const String memberTasks = '$_projectBoardsManagement/get-member-task-report';

  /// Idea Board
  static const _ideaBoard = 'mobile/ideas';
  static const addIdea = '$_ideaBoard/add';
  static const listIdea = '$_ideaBoard/list';
  static const updateIdea = '$_ideaBoard/update';
  static const deleteIdea = '$_ideaBoard/delete';
  static const _categories = '$_ideaBoard/categories';
  static const addIdeaCategory = '$_categories/add';
  static const listIdeaCategory = '$_categories/list';
  static const updateIdeaCategory = '$_categories/update';
  static const deleteIdeaCategory = '$_categories/delete';

  /// CRM Management
  static const _crmManagement = 'mobile/crm';
  static const getCustomer = 'web/customer/getCustomer';
  static const updateCustomer = 'web/customer/updateCustomer';
  static const getAllLeads = 'web/crm/lead/get-all';
  static const addRemark = 'web/crm/lead/add-remark';
  static const getAllColumn = '$_crmManagement/columns/get-all';
  static const getTeamMembers = '$_crmManagement/team-members/get-all';

  /// CRM Reports Management
  static const _webCrmManagement = 'web/crm';
  static const memberReport = '$_webCrmManagement/member-report';
  static const leadDetails = '$_webCrmManagement/lead/get-details';

  /// Attachment
  static const _crmAttachment = '$_crmManagement/attachment';
  static const getAttachment = '$_crmAttachment/get';
  static const addAttachment = '$_crmAttachment/add';
  static const deleteAttachment = '$_crmAttachment/delete';

  /// Followup
  static const _crmFollowup = '$_crmManagement/followup';
  static const getFollowup = '$_crmFollowup/get-by-lead';
  static const createFollowup = '$_crmFollowup/create';
  static const updateFollowup = '$_crmFollowup/update';
  static const deleteFollowup = '$_crmFollowup/delete';

  /// Followup-leads
  static const createQuotation = '$_crmManagement/lead/update/quotation-date';
  static const updateQuotation = '$_crmManagement/leads/quotation-details/update';
  static const deleteQuotation = '$_crmManagement/leads/quotation-details/delete';

  /// Lead Management
  static const _lead = 'mobile/lead';
  static const createLead = '$_lead/create';
  static const getCategories = '$_lead/get-category-wise';
  static const getColumnWise = '$_lead/get-column-wise';
  static const updateColumn = '$_lead/update-column';
  static const updateLeadDetails = '$_lead/update-details';
  static const markWon = '$_lead/mark-won';
  static const markLost = '$_lead/mark-lost';
  static const generateInvoice = 'mobile/crm/lead/generate-invoice';
  static const generateQuotation = 'mobile/crm/lead/generate-quotation';

  /// Web Hosting Management
  static const _webHostBooking = 'web/host-booking';
  static const hostBookings = '$_webHostBooking/bookings';
  static const hostConfig = '$_webHostBooking/config';
  static const hostCancel = '$_webHostBooking/cancel';

  /// Booking Management
  static const _book = 'api/book';
  static const bookCreate = '$_book/create';
  static const bookReschedule = '$_book/reschedule';
  static const bookCancel = '$_book/cancel';

  /// Product Management
  static const _product = 'mobile/product';
  static const statsProducts = '$_product/stats';
  static const createProducts = '$_product/create';
  static const getAllProducts = '$_product/get-all';
  static const getProductsDropdown = '$_product/dropdown';
  static const updateProducts = '$_product/update';
  static const deleteProducts = '$_product/delete';

  static const scanCard = 'mobile/scanned-cards';
  static const save = 'save';
  static const delete = 'delete';
  static const shareAdd = "mobile/shares/add";
  static const shareEdit = "mobile/shares/edit";
  static const shareDelete = "mobile/shares/delete";
  static const dashboardCounts = 'mobile/dashboard';
  static const businessCards = 'mobile/business-cards';
  static const businessCard = 'mobile/business-card';
  static const image = 'image';
  static const business = 'business';
  static const update = 'update';
  static const shares = 'mobile/shares';
  static const history = 'history';
  static const themes = 'mobile/themes';

  static const _group = 'mobile/group';
  static const getAll = '$_group/get-all';
  static const initialize = '$_group/initialize';
  static const createGroup = '$_group/create';
  static const updateGroup = '$_group/update';
  static const removeGroup = '$_group/remove';

  static const _task = 'mobile/task';
  static const createTask = '$_task/create';
  static const readTask = '$_task/get-all-group-task';
  static const updateTask = '$_task/update-task';
  static const updateTaskSync = '$_task/update-task/sync';
  static const deleteTask = '$_task/delete-task';

  static const getProducts = 'mobile/getProducts';
  static const createProduct = 'mobile/businessCard/createProducts';
  static const deleteProduct = 'mobile/businessCard/deleteProducts';
  static const getServices = 'mobile/getServices';
  static const createService = 'mobile/businessCard/createServices';
  static const deleteService = 'mobile/businessCard/deleteServices';
  static const getContacts = 'mobile/get/contacts';

  /// Web Income-expense
  static const _incomeExpense = 'web/income-expense';
  static const incomeExpenseSummary = '$_incomeExpense/summary';
  static const incomeExpenseTransactions = '$_incomeExpense/combined';
  static const incomeExpenseCategories = '$_incomeExpense/categories/list';
  static const incomeExpenseCategoryAdd = '$_incomeExpense/categories/add';
  static const incomeExpenseCategoryUpdate = '$_incomeExpense/categories/update';
  static const incomeExpenseCategoryDelete = '$_incomeExpense/categories/delete';
  static const incomeAdd = '$_incomeExpense/income/add';
  static const incomeUpdate = '$_incomeExpense/income/update';
  static const incomeDelete = '$_incomeExpense/income/delete';
  static const expenseAdd = '$_incomeExpense/expense/add';
  static const expenseUpdate = '$_incomeExpense/expense/update';
  static const expenseDelete = '$_incomeExpense/expense/delete';

  static const String getQuotations = 'mobile/crm/leads/for-quotation';
  static const String deleteDraftQuotation = 'mobile/crm/quotation/delete';
}
