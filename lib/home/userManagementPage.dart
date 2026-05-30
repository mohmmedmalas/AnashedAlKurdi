import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configuration/theme.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configuration/userService.dart';

// class UserManagementPage extends StatefulWidget {
//   const UserManagementPage({Key? key}) : super(key: key);
//
//   @override
//   State<UserManagementPage> createState() => _UserManagementPageState();
// }

// class _UserManagementPageState extends State<UserManagementPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _currentUserUid = '';
//   bool _isSuperAdmin = false;
//   String _filter = 'all'; // 'all', 'active', 'disabled', 'admins'
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   Future<void> _getCurrentUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool superAdmin = await UserService.isCurrentUserSuperAdmin();
//     setState(() {
//       _currentUserUid = prefs.getString('user_uid') ?? '';
//       _isSuperAdmin = superAdmin;
//     });
//   }
//
//   // Show role selection dialog
//   Future<void> _showRoleDialog(String uid, String userName, bool currentIsAdmin, bool currentIsSuperAdmin) async {
//     if (!_isSuperAdmin) {
//       _showSnackBar('هذه العملية تتطلب صلاحيات المدير العام');
//       return;
//     }
//
//     // Prevent changing own role
//     if (uid == _currentUserUid) {
//       _showSnackBar('لا يمكنك تغيير صلاحياتك الخاصة');
//       return;
//     }
//
//     String? selectedRole = await showDialog<String>(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           title: Text('تغيير صلاحيات "$userName"'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RadioListTile<String>(
//                 title: Text('مستخدم عادي'),
//                 subtitle: Text('لا يمتلك صلاحيات إدارية'),
//                 value: 'user',
//                 groupValue: currentIsSuperAdmin ? 'super_admin' : currentIsAdmin ? 'admin' : 'user',
//                 onChanged: (value) => Navigator.pop(context, value),
//               ),
//               RadioListTile<String>(
//                 title: Text('مدير'),
//                 subtitle: Text('يمكنه تعطيل الحسابات'),
//                 value: 'admin',
//                 groupValue: currentIsSuperAdmin ? 'super_admin' : currentIsAdmin ? 'admin' : 'user',
//                 onChanged: (value) => Navigator.pop(context, value),
//               ),
//               RadioListTile<String>(
//                 title: Row(
//                   children: [
//                     Text('مدير عام'),
//                     SizedBox(width: 8),
//                     Icon(Icons.star, color: Colors.amber, size: 18),
//                   ],
//                 ),
//                 subtitle: Text('جميع الصلاحيات + إدارة المدراء'),
//                 value: 'super_admin',
//                 groupValue: currentIsSuperAdmin ? 'super_admin' : currentIsAdmin ? 'admin' : 'user',
//                 onChanged: (value) => Navigator.pop(context, value),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('إلغاء'),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     if (selectedRole == null) return;
//
//     // Show loading
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       bool isAdmin = selectedRole == 'admin' || selectedRole == 'super_admin';
//       bool isSuperAdmin = selectedRole == 'super_admin';
//
//       final result = await UserService.updateAdminStatus(uid, isAdmin, isSuperAdmin);
//
//       if (mounted) Navigator.pop(context); // Close loading
//
//       _showSnackBar(result['message']);
//     } catch (e) {
//       if (mounted) Navigator.pop(context); // Close loading
//       _showSnackBar('خطأ في تحديث الصلاحيات: $e');
//     }
//   }
//
//   // Toggle account status (disable/enable)
//   Future<void> _toggleAccountStatus(String uid, bool isDisabled, String userName, bool isSuperAdmin) async {
//     // Prevent disabling super admins unless you're super admin
//     if (isSuperAdmin && !_isSuperAdmin) {
//       _showSnackBar('لا يمكن تعطيل حساب المدير العام');
//       return;
//     }
//
//     // Prevent disabling own account
//     if (uid == _currentUserUid) {
//       _showSnackBar('لا يمكنك تعطيل حسابك الخاص');
//       return;
//     }
//
//     // Show confirmation dialog
//     bool? confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           title: Text(isDisabled ? 'تأكيد التفعيل' : 'تأكيد التعطيل'),
//           content: Text(
//               isDisabled
//                   ? 'هل تريد تفعيل حساب "$userName"؟\n\nسيتمكن المستخدم من تسجيل الدخول مرة أخرى.'
//                   : 'هل تريد تعطيل حساب "$userName"؟\n\nلن يتمكن المستخدم من تسجيل الدخول.'
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text('إلغاء'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: TextButton.styleFrom(
//                 foregroundColor: isDisabled ? Colors.green : Colors.orange,
//               ),
//               child: Text(isDisabled ? 'تفعيل' : 'تعطيل'),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     if (confirm != true) return;
//
//     // Show loading
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       final result = await UserService.toggleAccountStatus(uid, isDisabled, userName);
//
//       if (mounted) Navigator.pop(context); // Close loading
//
//       _showSnackBar(result['message']);
//     } catch (e) {
//       if (mounted) Navigator.pop(context); // Close loading
//       _showSnackBar('خطأ: $e');
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: Duration(seconds: 3)),
//     );
//   }
//
//   // Get ALL users (for stats)
//   Stream<QuerySnapshot> _getAllUsersStream() {
//     return _firestore
//         .collection('users')
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }
//
//   // Get filtered users (for list display)
//   List<DocumentSnapshot> _filterUsers(List<DocumentSnapshot> allUsers) {
//     if (_filter == 'active') {
//       return allUsers.where((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return data['is_disabled'] != true;
//       }).toList();
//     } else if (_filter == 'disabled') {
//       return allUsers.where((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return data['is_disabled'] == true;
//       }).toList();
//     } else if (_filter == 'admins') {
//       return allUsers.where((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return data['is_admin'] == true;
//       }).toList();
//     }
//     // 'all' returns everything
//     return allUsers;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('إدارة المستخدمين'),
//           backgroundColor: Theme_Information.Primary_Color,
//           foregroundColor: Colors.white,
//         ),
//         body: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Column(
//             children: [
//               // Filter tabs
//               Container(
//                 margin: EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       _buildFilterChip('الكل', 'all'),
//                       SizedBox(width: 8),
//                       _buildFilterChip('النشطين', 'active'),
//                       SizedBox(width: 8),
//                       _buildFilterChip('المعطلين', 'disabled'),
//                       SizedBox(width: 8),
//                       _buildFilterChip('المدراء', 'admins'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Users list with stats
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: _getAllUsersStream(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//
//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text('خطأ في تحميل البيانات: ${snapshot.error}'),
//                       );
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.people_outline, size: 80, color: Colors.grey),
//                             SizedBox(height: 16),
//                             Text(
//                               'لا يوجد مستخدمين',
//                               style: TextStyle(fontSize: 18, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     // Get ALL users for stats calculation
//                     List<DocumentSnapshot> allUsers = snapshot.data!.docs;
//
//                     // Calculate stats from ALL users (always correct)
//                     int totalUsers = allUsers.length;
//                     int activeUsers = allUsers.where((u) => (u.data() as Map)['is_disabled'] != true).length;
//                     int disabledUsers = allUsers.where((u) => (u.data() as Map)['is_disabled'] == true).length;
//                     int admins = allUsers.where((u) => (u.data() as Map)['is_admin'] == true).length;
//                     int superAdmins = allUsers.where((u) => (u.data() as Map)['is_super_admin'] == true).length;
//
//                     // Filter users for display based on selected filter
//                     List<DocumentSnapshot> displayUsers = _filterUsers(allUsers);
//
//                     return Column(
//                       children: [
//                         // Stats card (ALWAYS SHOWS, based on ALL users)
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Theme_Information.Primary_Color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               _buildStatItem(
//                                 icon: Icons.people,
//                                 label: 'الكل',
//                                 value: totalUsers.toString(),
//                                 color: Colors.blue,
//                               ),
//                               _buildStatDivider(),
//                               _buildStatItem(
//                                 icon: Icons.check_circle,
//                                 label: 'نشط',
//                                 value: activeUsers.toString(),
//                                 color: Colors.green,
//                               ),
//                               _buildStatDivider(),
//                               _buildStatItem(
//                                 icon: Icons.block,
//                                 label: 'معطل',
//                                 value: disabledUsers.toString(),
//                                 color: Colors.orange,
//                               ),
//                               _buildStatDivider(),
//                               _buildStatItem(
//                                 icon: Icons.admin_panel_settings,
//                                 label: 'مدير',
//                                 value: admins.toString(),
//                                 color: Colors.red,
//                               ),
//                               _buildStatDivider(),
//                               _buildStatItem(
//                                 icon: Icons.star,
//                                 label: 'مدير عام',
//                                 value: superAdmins.toString(),
//                                 color: Colors.amber,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: 16),
//
//                         // Users list (filtered)
//                         if (displayUsers.isEmpty)
//                           Expanded(
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.people_outline, size: 80, color: Colors.grey),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     _getEmptyMessage(),
//                                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         else
//                           Expanded(
//                             child: ListView.builder(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               itemCount: displayUsers.length,
//                               itemBuilder: (context, index) {
//                                 Map<String, dynamic> userData = displayUsers[index].data() as Map<String, dynamic>;
//                                 String uid = displayUsers[index].id;
//                                 String name = userData['name'] ?? 'بدون اسم';
//                                 String phone = userData['phoneNumber'] ?? '';
//                                 bool isAdmin = userData['is_admin'] ?? false;
//                                 bool isSuperAdmin = userData['is_super_admin'] ?? false;
//                                 bool isDisabled = userData['is_disabled'] ?? false;
//                                 bool isCurrentUser = uid == _currentUserUid;
//
//
//                                 Color cardBorderColor = isSuperAdmin
//                                     ? Colors.amber.shade300
//                                     : isAdmin
//                                     ? Colors.red.shade200
//                                     : isDisabled
//                                     ? Colors.orange.shade200
//                                     : Colors.transparent;
//
//                                 return Card(
//                                   elevation: 2,
//                                   margin: EdgeInsets.only(bottom: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     side: BorderSide(color: cardBorderColor, width: cardBorderColor != Colors.transparent ? 1.5 : 0),
//                                   ),
//                                   child: ExpansionTile(
//                                     leading: Stack(
//                                       children: [
//                                         CircleAvatar(
//                                           backgroundColor: isDisabled
//                                               ? Colors.grey
//                                               : isSuperAdmin
//                                               ? Colors.amber
//                                               : isAdmin
//                                               ? Colors.red
//                                               : Theme_Information.Primary_Color,
//                                           child: Text(
//                                             name.isNotEmpty ? name[0].toUpperCase() : 'U',
//                                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         if (isDisabled)
//                                           Positioned(
//                                             right: 0,
//                                             bottom: 0,
//                                             child: Container(
//                                               padding: EdgeInsets.all(2),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Icon(Icons.block, size: 16, color: Colors.orange),
//                                             ),
//                                           ),
//                                         if (isSuperAdmin)
//                                           Positioned(
//                                             left: 0,
//                                             bottom: 0,
//                                             child: Container(
//                                               padding: EdgeInsets.all(2),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Icon(Icons.star, size: 14, color: Colors.amber),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                     title: Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             name,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                               decoration: isDisabled ? TextDecoration.lineThrough : null,
//                                               color: isDisabled ? Colors.grey : null,
//                                             ),
//                                           ),
//                                         ),
//                                         if (isCurrentUser) ...[
//                                           SizedBox(width: 8),
//                                           Container(
//                                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                             decoration: BoxDecoration(
//                                               color: Colors.blue,
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Text(
//                                               'أنت',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                         if (isSuperAdmin) ...[
//                                           SizedBox(width: 8),
//                                           Container(
//                                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                             decoration: BoxDecoration(
//                                               color: Colors.amber,
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Icon(Icons.star, size: 12, color: Colors.white),
//                                                 SizedBox(width: 2),
//                                                 Text(
//                                                   'مدير عام',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 10,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ] else if (isAdmin) ...[
//                                           SizedBox(width: 8),
//                                           Container(
//                                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                             decoration: BoxDecoration(
//                                               color: Colors.red,
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Text(
//                                               'مدير',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                         if (isDisabled) ...[
//                                           SizedBox(width: 8),
//                                           Container(
//                                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                             decoration: BoxDecoration(
//                                               color: Colors.orange,
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Text(
//                                               'معطل',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ],
//                                     ),
//                                     subtitle: Text(
//                                       phone,
//                                       style: TextStyle(
//                                         color: isDisabled ? Colors.grey[400] : Colors.grey[600],
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     children: [
//                                       Divider(height: 1),
//                                       Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             _buildInfoRow(
//                                               icon: Icons.badge,
//                                               label: 'معرف المستخدم',
//                                               value: uid.substring(0, 8) + '...',
//                                             ),
//                                             SizedBox(height: 8),
//                                             _buildInfoRow(
//                                               icon: Icons.shield,
//                                               label: 'الصلاحيات',
//                                               value: isSuperAdmin ? 'مدير عام' : isAdmin ? 'مدير' : 'مستخدم عادي',
//                                             ),
//                                             SizedBox(height: 8),
//                                             _buildInfoRow(
//                                               icon: Icons.calendar_today,
//                                               label: 'تاريخ التسجيل',
//                                               value: _formatDate(userData['createdAt']),
//                                             ),
//                                             SizedBox(height: 8),
//                                             _buildInfoRow(
//                                               icon: Icons.login,
//                                               label: 'آخر دخول',
//                                               value: _formatDate(userData['lastLogin']),
//                                             ),
//                                             if (isDisabled) ...[
//                                               SizedBox(height: 8),
//                                               _buildInfoRow(
//                                                 icon: Icons.block,
//                                                 label: 'تاريخ التعطيل',
//                                                 value: _formatDate(userData['disabled_at']),
//                                               ),
//                                             ],
//                                             SizedBox(height: 16),
//                                             Row(
//                                               children: [
//                                                 // Change role button (Super admin only)
//                                                 if (_isSuperAdmin)
//                                                   Expanded(
//                                                     child: ElevatedButton.icon(
//                                                       onPressed: isCurrentUser || isDisabled
//                                                           ? null
//                                                           : () => _showRoleDialog(uid, name, isAdmin, isSuperAdmin),
//                                                       icon: Icon(Icons.security, size: 18),
//                                                       label: Text(
//                                                         'تغيير الصلاحيات',
//                                                         style: TextStyle(fontSize: 13),
//                                                       ),
//                                                       style: ElevatedButton.styleFrom(
//                                                         backgroundColor: Colors.purple,
//                                                         foregroundColor: Colors.white,
//                                                         padding: EdgeInsets.symmetric(vertical: 8),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 if (_isSuperAdmin) SizedBox(width: 8),
//                                                 // Disable/Enable button
//                                                 Expanded(
//                                                   child: ElevatedButton.icon(
//                                                     onPressed: isCurrentUser
//                                                         ? null
//                                                         : () => _toggleAccountStatus(uid, isDisabled, name, isSuperAdmin),
//                                                     icon: Icon(
//                                                       isDisabled ? Icons.check_circle : Icons.block,
//                                                       size: 18,
//                                                     ),
//                                                     label: Text(
//                                                       isDisabled ? 'تفعيل' : 'تعطيل',
//                                                       style: TextStyle(fontSize: 13),
//                                                     ),
//                                                     style: ElevatedButton.styleFrom(
//                                                       backgroundColor: isDisabled ? Colors.green : Colors.red,
//                                                       foregroundColor: Colors.white,
//                                                       padding: EdgeInsets.symmetric(vertical: 8),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getEmptyMessage() {
//     switch (_filter) {
//       case 'active':
//         return 'لا يوجد مستخدمين نشطين';
//       case 'disabled':
//         return 'لا يوجد مستخدمين معطلين';
//       case 'admins':
//         return 'لا يوجد مدراء';
//       default:
//         return 'لا يوجد مستخدمين';
//     }
//   }
//
//   Widget _buildFilterChip(String label, String value) {
//     bool isSelected = _filter == value;
//     return FilterChip(
//       label: Text(
//         label,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.black,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       selected: isSelected,
//       onSelected: (selected) {
//         setState(() {
//           _filter = value;
//         });
//       },
//       selectedColor: Theme_Information.Primary_Color,
//       backgroundColor: Colors.grey[200],
//       checkmarkColor: Colors.white,
//     );
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 20),
//         SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatDivider() {
//     return Container(
//       height: 35,
//       width: 1,
//       color: Colors.grey[300],
//     );
//   }
//
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[600]),
//         SizedBox(width: 8),
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[700],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatDate(dynamic timestamp) {
//     if (timestamp == null) return 'غير متوفر';
//
//     try {
//       DateTime date = (timestamp as Timestamp).toDate();
//       return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return 'غير متوفر';
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configuration/theme.dart';
import '../configuration/userService.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _currentUserUid = '';
  bool _isSuperAdmin = false;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool superAdmin = await UserService.isCurrentUserSuperAdmin();
    setState(() {
      _currentUserUid = prefs.getString('user_uid') ?? '';
      _isSuperAdmin = superAdmin;
    });
  }

  // ─── Role Dialog ────────────────────────────────────────────────
  Future<void> _showRoleDialog(
      String uid,
      String userName,
      bool currentIsAdmin,
      bool currentIsSuperAdmin,
      bool currentIsUploader,
      ) async {
    if (!_isSuperAdmin) {
      _showSnackBar('هذه العملية تتطلب صلاحيات المدير العام');
      return;
    }
    if (uid == _currentUserUid) {
      _showSnackBar('لا يمكنك تغيير صلاحياتك الخاصة');
      return;
    }

    String currentRole = currentIsSuperAdmin
        ? 'super_admin'
        : currentIsAdmin
        ? 'admin'
        : currentIsUploader
        ? 'uploader'
        : 'user';

    String? selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تغيير صلاحيات "$userName"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('مستخدم عادي'),
                subtitle: Text('لا يمتلك صلاحيات إدارية'),
                value: 'user',
                groupValue: currentRole,
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<String>(
                title: Row(children: [
                  Text('محمّل'),
                  SizedBox(width: 8),
                  Icon(Icons.upload_file, color: Colors.teal, size: 18),
                ]),
                subtitle: Text('يمكنه رفع القصائد فقط'),
                value: 'uploader',
                groupValue: currentRole,
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<String>(
                title: Text('مدير'),
                subtitle: Text('يمكنه تعطيل الحسابات'),
                value: 'admin',
                groupValue: currentRole,
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<String>(
                title: Row(children: [
                  Text('مدير عام'),
                  SizedBox(width: 8),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                ]),
                subtitle: Text('جميع الصلاحيات + إدارة المدراء'),
                value: 'super_admin',
                groupValue: currentRole,
                onChanged: (v) => Navigator.pop(context, v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
          ],
        ),
      ),
    );

    if (selectedRole == null) return;

    _showLoading();

    try {
      if (selectedRole == 'uploader') {
        // Set uploader, clear admin flags
        await _firestore.collection('users').doc(uid).update({
          'is_uploader': true,
          'is_admin': false,
          'is_super_admin': false,
        });
      } else {
        // Clear uploader flag, set admin flags
        bool isAdmin = selectedRole == 'admin' || selectedRole == 'super_admin';
        bool isSuperAdmin = selectedRole == 'super_admin';
        await _firestore.collection('users').doc(uid).update({
          'is_uploader': false,
          'can_push': false,
          'is_admin': isAdmin,
          'is_super_admin': isSuperAdmin,
        });
      }

      if (mounted) Navigator.pop(context);
      _showSnackBar('تم تحديث الصلاحيات بنجاح');
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('خطأ: $e');
    }
  }

  // ─── Toggle can_push ─────────────────────────────────────────────
  Future<void> _toggleCanPush(String uid, bool currentCanPush, String userName) async {
    _showLoading();
    try {
      final result = await UserService.updateCanPush(uid, !currentCanPush);
      if (mounted) Navigator.pop(context);
      _showSnackBar(result['message']);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('خطأ: $e');
    }
  }

  // ─── Toggle disable/enable ───────────────────────────────────────
  Future<void> _toggleAccountStatus(
      String uid,
      bool isDisabled,
      String userName,
      bool isSuperAdmin,
      ) async {
    if (isSuperAdmin && !_isSuperAdmin) {
      _showSnackBar('لا يمكن تعطيل حساب المدير العام');
      return;
    }
    if (uid == _currentUserUid) {
      _showSnackBar('لا يمكنك تعطيل حسابك الخاص');
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(isDisabled ? 'تأكيد التفعيل' : 'تأكيد التعطيل'),
          content: Text(
            isDisabled
                ? 'هل تريد تفعيل حساب "$userName"؟'
                : 'هل تريد تعطيل حساب "$userName"؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: isDisabled ? Colors.green : Colors.orange,
              ),
              child: Text(isDisabled ? 'تفعيل' : 'تعطيل'),
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;

    _showLoading();
    try {
      final result =
      await UserService.toggleAccountStatus(uid, isDisabled, userName);
      if (mounted) Navigator.pop(context);
      _showSnackBar(result['message']);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('خطأ: $e');
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  Stream<QuerySnapshot> _getAllUsersStream() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<DocumentSnapshot> _filterUsers(List<DocumentSnapshot> allUsers) {
    switch (_filter) {
      case 'active':
        return allUsers
            .where((d) => (d.data() as Map)['is_disabled'] != true)
            .toList();
      case 'disabled':
        return allUsers
            .where((d) => (d.data() as Map)['is_disabled'] == true)
            .toList();
      case 'admins':
        return allUsers
            .where((d) => (d.data() as Map)['is_admin'] == true)
            .toList();
      case 'uploaders':
        return allUsers
            .where((d) => (d.data() as Map)['is_uploader'] == true)
            .toList();
      default:
        return allUsers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدارة المستخدمين'),
          backgroundColor: Theme_Information.Primary_Color,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // ── Filter chips ──────────────────────────────────────
            Container(
              margin: EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('الكل', 'all'),
                    SizedBox(width: 8),
                    _filterChip('النشطين', 'active'),
                    SizedBox(width: 8),
                    _filterChip('المعطلين', 'disabled'),
                    SizedBox(width: 8),
                    _filterChip('المدراء', 'admins'),
                    SizedBox(width: 8),
                    _filterChip('المحمّلون', 'uploaders'), // NEW
                  ],
                ),
              ),
            ),

            // ── Users list ────────────────────────────────────────
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getAllUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('خطأ: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('لا يوجد مستخدمين'));
                  }

                  final allUsers = snapshot.data!.docs;

                  // Stats
                  int total = allUsers.length;
                  int active = allUsers
                      .where((u) => (u.data() as Map)['is_disabled'] != true)
                      .length;
                  int disabled = allUsers
                      .where((u) => (u.data() as Map)['is_disabled'] == true)
                      .length;
                  int admins = allUsers
                      .where((u) => (u.data() as Map)['is_admin'] == true)
                      .length;
                  int uploaders = allUsers  // NEW
                      .where((u) => (u.data() as Map)['is_uploader'] == true)
                      .length;

                  final displayUsers = _filterUsers(allUsers);

                  return Column(
                    children: [
                      // ── Stats bar ─────────────────────────────
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme_Information.Primary_Color
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(Icons.people, 'الكل', total, Colors.blue),
                            _divider(),
                            _statItem(Icons.check_circle, 'نشط', active,
                                Colors.green),
                            _divider(),
                            _statItem(Icons.block, 'معطل', disabled,
                                Colors.orange),
                            _divider(),
                            _statItem(Icons.admin_panel_settings, 'مدير',
                                admins, Colors.red),
                            _divider(),
                            _statItem(Icons.upload_file, 'محمّل', uploaders,
                                Colors.teal), // NEW
                          ],
                        ),
                      ),

                      SizedBox(height: 12),

                      // ── List ──────────────────────────────────
                      displayUsers.isEmpty
                          ? Expanded(
                        child: Center(
                          child: Text(
                            _emptyMessage(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                          : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: displayUsers.length,
                          itemBuilder: (context, index) {
                            return _buildUserCard(displayUsers[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── User Card ───────────────────────────────────────────────────
  Widget _buildUserCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final uid = doc.id;
    final name = data['name'] ?? 'بدون اسم';
    final phone = data['phoneNumber'] ?? '';
    final isAdmin = data['is_admin'] ?? false;
    final isSuperAdmin = data['is_super_admin'] ?? false;
    final isUploader = data['is_uploader'] ?? false;   // NEW
    final canPush = data['can_push'] ?? false;          // NEW
    final isDisabled = data['is_disabled'] ?? false;
    final isCurrentUser = uid == _currentUserUid;

    // Card border color
    Color borderColor = isSuperAdmin
        ? Colors.amber.shade300
        : isAdmin
        ? Colors.red.shade200
        : isUploader
        ? Colors.teal.shade200
        : Colors.transparent;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: borderColor != Colors.transparent ? 1.5 : 0,
        ),
      ),
      child: ExpansionTile(
        // ── Avatar ──
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: isDisabled
                  ? Colors.grey
                  : isSuperAdmin
                  ? Colors.amber
                  : isAdmin
                  ? Colors.red
                  : isUploader
                  ? Colors.teal
                  : Theme_Information.Primary_Color,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (isDisabled)
              Positioned(
                right: 0, bottom: 0,
                child: _badgeIcon(Icons.block, Colors.orange),
              ),
            if (isSuperAdmin)
              Positioned(
                left: 0, bottom: 0,
                child: _badgeIcon(Icons.star, Colors.amber),
              ),
            if (isUploader && !isSuperAdmin && !isAdmin)
              Positioned(
                left: 0, bottom: 0,
                child: _badgeIcon(Icons.upload_file, Colors.teal),
              ),
          ],
        ),

        // ── Title row ──
        title: Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration:
                  isDisabled ? TextDecoration.lineThrough : null,
                  color: isDisabled ? Colors.grey : null,
                )),
            if (isCurrentUser) _badge('أنت', Colors.blue),
            if (isSuperAdmin) _badge('مدير عام', Colors.amber),
            if (isAdmin && !isSuperAdmin) _badge('مدير', Colors.red),
            if (isUploader) _badge('محمّل', Colors.teal),        // NEW
            if (canPush) _badge('إرسال', Colors.purple),          // NEW
            if (isDisabled) _badge('معطل', Colors.orange),
          ],
        ),
        subtitle: Text(phone,
            style: TextStyle(
                color: isDisabled ? Colors.grey[400] : Colors.grey[600])),

        // ── Expanded details ──
        children: [
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.badge, 'المعرف', uid.substring(0, 8) + '...'),
                SizedBox(height: 6),
                _infoRow(Icons.shield, 'الصلاحية',
                    isSuperAdmin
                        ? 'مدير عام'
                        : isAdmin
                        ? 'مدير'
                        : isUploader
                        ? 'محمّل'
                        : 'مستخدم'),
                SizedBox(height: 6),
                _infoRow(Icons.calendar_today, 'تاريخ التسجيل',
                    _formatDate(data['createdAt'])),
                SizedBox(height: 6),
                _infoRow(Icons.login, 'آخر دخول',
                    _formatDate(data['lastLogin'])),
                if (isDisabled) ...[
                  SizedBox(height: 6),
                  _infoRow(Icons.block, 'تاريخ التعطيل',
                      _formatDate(data['disabled_at'])),
                ],

                SizedBox(height: 14),

                // ── Action buttons ──
                if (_isSuperAdmin) ...[
                  // Row 1: Change role + Disable/Enable
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isCurrentUser || isDisabled
                              ? null
                              : () => _showRoleDialog(uid, name, isAdmin,
                              isSuperAdmin, isUploader),
                          icon: Icon(Icons.security, size: 16),
                          label: Text('الصلاحيات', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isCurrentUser
                              ? null
                              : () => _toggleAccountStatus(
                              uid, isDisabled, name, isSuperAdmin),
                          icon: Icon(
                            isDisabled ? Icons.check_circle : Icons.block,
                            size: 16,
                          ),
                          label: Text(
                            isDisabled ? 'تفعيل' : 'تعطيل',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isDisabled ? Colors.green : Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Row 2: can_push toggle — only for uploaders
                  if (isUploader) ...[
                    SizedBox(height: 8),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.send, color: Colors.purple, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'السماح بإرسال القصيدة لجميع المستخدمين',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.purple[800]),
                            ),
                          ),
                          Switch(
                            value: canPush,
                            activeColor: Colors.purple,
                            onChanged: isDisabled
                                ? null
                                : (_) =>
                                _toggleCanPush(uid, canPush, name),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────
  Widget _badgeIcon(IconData icon, Color color) => Container(
    padding: EdgeInsets.all(2),
    decoration:
    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Icon(icon, size: 13, color: color),
  );

  Widget _badge(String text, Color color) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(8)),
    child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold)),
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(
    children: [
      Icon(icon, size: 15, color: Colors.grey[600]),
      SizedBox(width: 6),
      Text('$label: ',
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500)),
      Expanded(
          child: Text(value,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
    ],
  );

  Widget _filterChip(String label, String value) {
    bool selected = _filter == value;
    return FilterChip(
      label: Text(label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight:
              selected ? FontWeight.bold : FontWeight.normal)),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: Theme_Information.Primary_Color,
      backgroundColor: Colors.grey[200],
      checkmarkColor: Colors.white,
    );
  }

  Widget _statItem(IconData icon, String label, int value, Color color) =>
      Column(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(height: 2),
          Text(value.toString(),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: TextStyle(fontSize: 9, color: Colors.grey[600])),
        ],
      );

  Widget _divider() => Container(
      height: 35, width: 1, color: Colors.grey[300]);

  String _emptyMessage() {
    switch (_filter) {
      case 'active': return 'لا يوجد مستخدمين نشطين';
      case 'disabled': return 'لا يوجد مستخدمين معطلين';
      case 'admins': return 'لا يوجد مدراء';
      case 'uploaders': return 'لا يوجد محمّلون';
      default: return 'لا يوجد مستخدمين';
    }
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return 'غير متوفر';
    try {
      final d = (ts as Timestamp).toDate();
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'غير متوفر';
    }
  }
}