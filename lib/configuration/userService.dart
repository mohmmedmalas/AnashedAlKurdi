import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// /// User data model
// class UserData {
//   final String uid;
//   final String name;
//   final String phoneNumber;
//   final bool isAdmin;
//   final bool isSuperAdmin;
//   final bool isDisabled;
//   final DateTime? createdAt;
//   final DateTime? lastLogin;
//   final DateTime? disabledAt;
//   final String? disabledBy;
//
//   UserData({
//     required this.uid,
//     required this.name,
//     required this.phoneNumber,
//     required this.isAdmin,
//     required this.isSuperAdmin,
//     this.isDisabled = false,
//     this.createdAt,
//     this.lastLogin,
//     this.disabledAt,
//     this.disabledBy,
//   });
//
//   factory UserData.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     return UserData(
//       uid: doc.id,
//       name: data['name'] ?? '',
//       phoneNumber: data['phoneNumber'] ?? '',
//       isSuperAdmin: data['is_super_admin'] ?? false,
//       isAdmin: data['is_admin'] ?? false,
//       isDisabled: data['is_disabled'] ?? false,
//       createdAt: data['createdAt'] != null
//           ? (data['createdAt'] as Timestamp).toDate()
//           : null,
//       lastLogin: data['lastLogin'] != null
//           ? (data['lastLogin'] as Timestamp).toDate()
//           : null,
//       disabledAt: data['disabled_at'] != null
//           ? (data['disabled_at'] as Timestamp).toDate()
//           : null,
//       disabledBy: data['disabled_by'],
//     );
//   }
// }
//
// /// Service class for user operations
// class UserService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   /// Get current user UID from SharedPreferences
//   static Future<String?> getCurrentUserUid() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('user_uid');
//   }
//
//   /// Get current user data from Firestore
//   static Future<UserData?> getCurrentUserData() async {
//     String? uid = await getCurrentUserUid();
//
//     if (uid == null) return null;
//
//     try {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//
//       if (!doc.exists) return null;
//
//       return UserData.fromFirestore(doc);
//     } catch (e) {
//       print('Error getting user data: $e');
//       return null;
//     }
//   }
//
//   /// Check if current user is admin
//   static Future<bool> isCurrentUserAdmin() async {
//     UserData? userData = await getCurrentUserData();
//     return userData?.isAdmin ?? false;
//   }
//
//   /// Check if current user is superAdmin
//   static Future<bool> isCurrentUserSuperAdmin() async {
//     UserData? userData = await getCurrentUserData();
//     return userData?.isSuperAdmin ?? false;
//   }
//
//   /// Get user data by UID
//   static Future<UserData?> getUserByUid(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//
//       if (!doc.exists) return null;
//
//       return UserData.fromFirestore(doc);
//     } catch (e) {
//       print('Error getting user: $e');
//       return null;
//     }
//   }
//
//   /// Update user admin status
//   static Future<Map<String, dynamic>> updateAdminStatus(String uid, bool isAdmin) async {
//     try {
//       await _firestore.collection('users').doc(uid).update({
//         'is_admin': isAdmin,
//       });
//
//       // Log the action
//       String? currentUid = await getCurrentUserUid();
//       await _firestore.collection('admin_logs').add({
//         'action': isAdmin ? 'admin_granted' : 'admin_revoked',
//         'performed_by': currentUid,
//         'target_user': uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       return {
//         'success': true,
//         'message': isAdmin ? 'تم منح صلاحيات المسؤول' : 'تم إزالة صلاحيات المسؤول',
//       };
//     } catch (e) {
//       print('Error updating admin status: $e');
//       return {
//         'success': false,
//         'message': 'فشل تحديث الصلاحيات: ${e.toString()}',
//       };
//     }
//   }
//
//
//   /// Update user admin status
//   static Future<Map<String, dynamic>> updateSuperAdminStatus(String uid, bool isSuperAdmin) async {
//     try {
//       await _firestore.collection('users').doc(uid).update({
//         'is_super_admin': isSuperAdmin,
//       });
//
//       // Log the action
//       String? currentUid = await getCurrentUserUid();
//       await _firestore.collection('admin_logs').add({
//         'action': isSuperAdmin ? 'super_admin_granted' : 'super_admin_revoked',
//         'performed_by': currentUid,
//         'target_user': uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       return {
//         'success': true,
//         'message': isSuperAdmin ? 'تم منح صلاحيات المسؤول' : 'تم إزالة صلاحيات المسؤول',
//       };
//     } catch (e) {
//       print('Error updating admin status: $e');
//       return {
//         'success': false,
//         'message': 'فشل تحديث الصلاحيات: ${e.toString()}',
//       };
//     }
//   }
//
//   /// Disable user account
//   static Future<Map<String, dynamic>> disableAccount(String uid, String userName) async {
//     try {
//       String? currentUid = await getCurrentUserUid();
//
//       await _firestore.collection('users').doc(uid).update({
//         'is_disabled': true,
//         'disabled_at': FieldValue.serverTimestamp(),
//         'disabled_by': currentUid,
//         'account_status': 'disabled',
//       });
//
//       // Log the action
//       await _firestore.collection('admin_logs').add({
//         'action': 'account_disabled',
//         'performed_by': currentUid,
//         'target_user': uid,
//         'target_user_name': userName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       return {
//         'success': true,
//         'message': 'تم تعطيل حساب "$userName" بنجاح',
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'فشل تعطيل الحساب: $e',
//       };
//     }
//   }
//
//   /// Enable user account
//   static Future<Map<String, dynamic>> enableAccount(String uid, String userName) async {
//     try {
//       await _firestore.collection('users').doc(uid).update({
//         'is_disabled': false,
//         'disabled_at': FieldValue.delete(),
//         'disabled_by': FieldValue.delete(),
//         'account_status': 'active',
//         'enabled_at': FieldValue.serverTimestamp(),
//       });
//
//       // Log the action
//       String? currentUid = await getCurrentUserUid();
//       await _firestore.collection('admin_logs').add({
//         'action': 'account_enabled',
//         'performed_by': currentUid,
//         'target_user': uid,
//         'target_user_name': userName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       return {
//         'success': true,
//         'message': 'تم تفعيل حساب "$userName" بنجاح',
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'فشل تفعيل الحساب: $e',
//       };
//     }
//   }
//
//   /// Toggle account status (disable/enable)
//   static Future<Map<String, dynamic>> toggleAccountStatus(String uid, bool currentStatus, String userName) async {
//     if (currentStatus) {
//       // Currently disabled, so enable it
//       return await enableAccount(uid, userName);
//     } else {
//       // Currently enabled, so disable it
//       return await disableAccount(uid, userName);
//     }
//   }
//
//   /// Update user profile
//   static Future<bool> updateUserProfile(String uid, {String? name}) async {
//     try {
//       Map<String, dynamic> updates = {};
//
//       if (name != null) updates['name'] = name;
//
//       if (updates.isEmpty) return false;
//
//       await _firestore.collection('users').doc(uid).update(updates);
//
//       // Update SharedPreferences if it's current user
//       String? currentUid = await getCurrentUserUid();
//       if (currentUid == uid && name != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('user_name', name);
//       }
//
//       return true;
//     } catch (e) {
//       print('Error updating profile: $e');
//       return false;
//     }
//   }
//
//   /// Get all users (for admin) - including disabled accounts
//   static Stream<List<UserData>> getAllUsersStream() {
//     return _firestore
//         .collection('users')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => UserData.fromFirestore(doc))
//         .toList());
//   }
//
//   /// Get only active users (not disabled)
//   static Stream<List<UserData>> getActiveUsersStream() {
//     return _firestore
//         .collection('users')
//         .where('is_disabled', isEqualTo: false)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => UserData.fromFirestore(doc))
//         .toList());
//   }
//
//   /// Get disabled users only
//   static Stream<List<UserData>> getDisabledUsersStream() {
//     return _firestore
//         .collection('users')
//         .where('is_disabled', isEqualTo: true)
//         .orderBy('disabled_at', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => UserData.fromFirestore(doc))
//         .toList());
//   }
//
//   /// Get users count
//   static Future<int> getUsersCount() async {
//     try {
//       AggregateQuerySnapshot snapshot =
//       await _firestore.collection('users').count().get();
//       return snapshot.count ?? 0;
//     } catch (e) {
//       print('Error getting users count: $e');
//       return 0;
//     }
//   }
//
//   /// Get active users count
//   static Future<int> getActiveUsersCount() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('is_disabled', isEqualTo: false)
//           .get();
//       return snapshot.docs.length;
//     } catch (e) {
//       print('Error getting active users count: $e');
//       return 0;
//     }
//   }
//
//   /// Get disabled users count
//   static Future<int> getDisabledUsersCount() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('is_disabled', isEqualTo: true)
//           .get();
//       return snapshot.docs.length;
//     } catch (e) {
//       print('Error getting disabled users count: $e');
//       return 0;
//     }
//   }
//
//   /// Get admin users count
//   static Future<int> getAdminsCount() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('is_admin', isEqualTo: true)
//           .get();
//       return snapshot.docs.length;
//     } catch (e) {
//       print('Error getting admins count: $e');
//       return 0;
//     }
//   }
//
//   /// Get admin users count
//   static Future<int> getSuperAdminsCount() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('is_super_admin', isEqualTo: true)
//           .get();
//       return snapshot.docs.length;
//     } catch (e) {
//       print('Error getting admins count: $e');
//       return 0;
//     }
//   }
//
//   /// Check if user account is disabled
//   static Future<bool> isAccountDisabled(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//       if (!doc.exists) return true;
//       return (doc.data() as Map)['is_disabled'] ?? false;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   /// Logout
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//
//     // Sign out from Firebase Auth if signed in
//     if (_auth.currentUser != null) {
//       await _auth.signOut();
//     }
//   }
//
//   /// Check if user is logged in
//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('is_logged_in') ?? false;
//   }
// }
///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User data model
class UserData {
  final String uid;
  final String name;
  final String phoneNumber;
  final bool isAdmin;
  final bool isSuperAdmin;
  final bool isDisabled;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final DateTime? disabledAt;
  final String? disabledBy;

  UserData({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.isAdmin,
    this.isSuperAdmin = false,
    this.isDisabled = false,
    this.createdAt,
    this.lastLogin,
    this.disabledAt,
    this.disabledBy,
  });

  // Get user role display name
  String get roleDisplay {
    if (isSuperAdmin) return 'مدير عام';
    if (isAdmin) return 'مدير';
    return 'مستخدم';
  }

  // Check if user has any admin privileges
  bool get hasAdminAccess => isAdmin || isSuperAdmin;

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserData(
      uid: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      isAdmin: data['is_admin'] ?? false,
      isSuperAdmin: data['is_super_admin'] ?? false,
      isDisabled: data['is_disabled'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
      disabledAt: data['disabled_at'] != null
          ? (data['disabled_at'] as Timestamp).toDate()
          : null,
      disabledBy: data['disabled_by'],
    );
  }
}

/// Service class for user operations
class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user UID from SharedPreferences
  static Future<String?> getCurrentUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

  /// Get current user data from Firestore
  static Future<UserData?> getCurrentUserData() async {
    String? uid = await getCurrentUserUid();

    if (uid == null) return null;

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      return UserData.fromFirestore(doc);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Check if current user is admin (regular or super)
  static Future<bool> isCurrentUserAdmin() async {
    UserData? userData = await getCurrentUserData();
    return userData?.hasAdminAccess ?? false;
  }

  /// Check if current user is super admin
  static Future<bool> isCurrentUserSuperAdmin() async {
    UserData? userData = await getCurrentUserData();
    return userData?.isSuperAdmin ?? false;
  }

  /// Check if current user is super admin od admin
  static Future<bool> isCurrentUserSuperAdminAdmin() async {
    UserData? userData = await getCurrentUserData();
    return (userData?.isAdmin ?? false) || (userData?.isSuperAdmin ?? false);
  }

  /// Get user data by UID
  static Future<UserData?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      return UserData.fromFirestore(doc);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Update user admin status (requires super admin)
  static Future<Map<String, dynamic>> updateAdminStatus(
      String uid,
      bool isAdmin,
      bool isSuperAdmin,
      ) async {
    try {
      // Check if current user is super admin
      UserData? currentUser = await getCurrentUserData();
      if (currentUser?.isSuperAdmin != true) {
        return {
          'success': false,
          'message': 'هذه العملية تتطلب صلاحيات المدير العام',
        };
      }

      await _firestore.collection('users').doc(uid).update({
        'is_admin': isAdmin,
        'is_super_admin': isSuperAdmin,
      });

      // Log the action
      String? currentUid = await getCurrentUserUid();
      await _firestore.collection('admin_logs').add({
        'action': isSuperAdmin
            ? 'super_admin_granted'
            : isAdmin
            ? 'admin_granted'
            : 'admin_revoked',
        'performed_by': currentUid,
        'target_user': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      String message = isSuperAdmin
          ? 'تم منح صلاحيات المدير العام'
          : isAdmin
          ? 'تم منح صلاحيات المدير'
          : 'تم إزالة الصلاحيات';

      return {
        'success': true,
        'message': message,
      };
    } catch (e) {
      print('Error updating admin status: $e');
      return {
        'success': false,
        'message': 'فشل تحديث الصلاحيات: ${e.toString()}',
      };
    }
  }

  /// Disable user account
  static Future<Map<String, dynamic>> disableAccount(String uid, String userName) async {
    try {
      String? currentUid = await getCurrentUserUid();
      UserData? currentUser = await getCurrentUserData();
      UserData? targetUser = await getUserByUid(uid);

      // Prevent disabling super admins unless you're a super admin
      if (targetUser?.isSuperAdmin == true && currentUser?.isSuperAdmin != true) {
        return {
          'success': false,
          'message': 'لا يمكن تعطيل حساب المدير العام',
        };
      }

      await _firestore.collection('users').doc(uid).update({
        'is_disabled': true,
        'disabled_at': FieldValue.serverTimestamp(),
        'disabled_by': currentUid,
        'account_status': 'disabled',
      });

      // Log the action
      await _firestore.collection('admin_logs').add({
        'action': 'account_disabled',
        'performed_by': currentUid,
        'target_user': uid,
        'target_user_name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'تم تعطيل حساب "$userName" بنجاح',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'فشل تعطيل الحساب: $e',
      };
    }
  }

  /// Enable user account
  static Future<Map<String, dynamic>> enableAccount(String uid, String userName) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'is_disabled': false,
        'disabled_at': FieldValue.delete(),
        'disabled_by': FieldValue.delete(),
        'account_status': 'active',
        'enabled_at': FieldValue.serverTimestamp(),
      });

      // Log the action
      String? currentUid = await getCurrentUserUid();
      await _firestore.collection('admin_logs').add({
        'action': 'account_enabled',
        'performed_by': currentUid,
        'target_user': uid,
        'target_user_name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'تم تفعيل حساب "$userName" بنجاح',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'فشل تفعيل الحساب: $e',
      };
    }
  }

  /// Toggle account status (disable/enable)
  static Future<Map<String, dynamic>> toggleAccountStatus(String uid, bool currentStatus, String userName) async {
    if (currentStatus) {
      return await enableAccount(uid, userName);
    } else {
      return await disableAccount(uid, userName);
    }
  }


  /// Check if user account is disabled
  static Future<bool> isAccountDisabled(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return true;
      return (doc.data() as Map)['is_disabled'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}