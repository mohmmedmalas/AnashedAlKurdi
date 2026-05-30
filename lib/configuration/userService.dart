import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User data model
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
//     this.isSuperAdmin = false,
//     this.isDisabled = false,
//     this.createdAt,
//     this.lastLogin,
//     this.disabledAt,
//     this.disabledBy,
//   });
//
//   // Get user role display name
//   String get roleDisplay {
//     if (isSuperAdmin) return 'مدير عام';
//     if (isAdmin) return 'مدير';
//     return 'مستخدم';
//   }
//
//   // Check if user has any admin privileges
//   bool get hasAdminAccess => isAdmin || isSuperAdmin;
//
//   factory UserData.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     return UserData(
//       uid: doc.id,
//       name: data['name'] ?? '',
//       phoneNumber: data['phoneNumber'] ?? '',
//       isAdmin: data['is_admin'] ?? false,
//       isSuperAdmin: data['is_super_admin'] ?? false,
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

/// Service class for user operations
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
//   /// Check if current user is admin (regular or super)
//   static Future<bool> isCurrentUserAdmin() async {
//     UserData? userData = await getCurrentUserData();
//     return userData?.hasAdminAccess ?? false;
//   }
//
//   /// Check if current user is super admin
//   static Future<bool> isCurrentUserSuperAdmin() async {
//     UserData? userData = await getCurrentUserData();
//     return userData?.isSuperAdmin ?? false;
//   }
//
//   /// Check if current user is super admin od admin
//   static Future<bool> isCurrentUserSuperAdminAdmin() async {
//     UserData? userData = await getCurrentUserData();
//     return (userData?.isAdmin ?? false) || (userData?.isSuperAdmin ?? false);
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
//   /// Update user admin status (requires super admin)
//   static Future<Map<String, dynamic>> updateAdminStatus(
//       String uid,
//       bool isAdmin,
//       bool isSuperAdmin,
//       ) async {
//     try {
//       // Check if current user is super admin
//       UserData? currentUser = await getCurrentUserData();
//       if (currentUser?.isSuperAdmin != true) {
//         return {
//           'success': false,
//           'message': 'هذه العملية تتطلب صلاحيات المدير العام',
//         };
//       }
//
//       await _firestore.collection('users').doc(uid).update({
//         'is_admin': isAdmin,
//         'is_super_admin': isSuperAdmin,
//       });
//
//       // Log the action
//       String? currentUid = await getCurrentUserUid();
//       await _firestore.collection('admin_logs').add({
//         'action': isSuperAdmin
//             ? 'super_admin_granted'
//             : isAdmin
//             ? 'admin_granted'
//             : 'admin_revoked',
//         'performed_by': currentUid,
//         'target_user': uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       String message = isSuperAdmin
//           ? 'تم منح صلاحيات المدير العام'
//           : isAdmin
//           ? 'تم منح صلاحيات المدير'
//           : 'تم إزالة الصلاحيات';
//
//       return {
//         'success': true,
//         'message': message,
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
//       UserData? currentUser = await getCurrentUserData();
//       UserData? targetUser = await getUserByUid(uid);
//
//       // Prevent disabling super admins unless you're a super admin
//       if (targetUser?.isSuperAdmin == true && currentUser?.isSuperAdmin != true) {
//         return {
//           'success': false,
//           'message': 'لا يمكن تعطيل حساب المدير العام',
//         };
//       }
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
//       return await enableAccount(uid, userName);
//     } else {
//       return await disableAccount(uid, userName);
//     }
//   }
//
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
// userService.dart

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
  final bool isUploader;   // NEW: can add/upload nasheeds
  final bool canPush;      // NEW: can push nasheed to all users
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
    this.isUploader = false,
    this.canPush = false,
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
    if (isUploader) return 'محمّل';
    return 'مستخدم';
  }

  // Check if user has any admin privileges
  bool get hasAdminAccess => isAdmin || isSuperAdmin;

  // Check if user can upload nasheeds
  bool get hasUploadAccess => isAdmin || isSuperAdmin || isUploader;

  // Check if user can push to all users
  bool get hasPushAccess => isAdmin || isSuperAdmin || canPush;

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserData(
      uid: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      isAdmin: data['is_admin'] ?? false,
      isSuperAdmin: data['is_super_admin'] ?? false,
      isUploader: data['is_uploader'] ?? false,   // NEW
      canPush: data['can_push'] ?? false,          // NEW
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

  static Future<String?> getCurrentUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

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

  static Future<bool> isCurrentUserAdmin() async {
    UserData? userData = await getCurrentUserData();
    return userData?.hasAdminAccess ?? false;
  }

  static Future<bool> isUploaderOnly() async {
    UserData? userData = await getCurrentUserData();
    if (userData == null) return false;
    return userData.isUploader &&
        !userData.isAdmin &&
        !userData.isSuperAdmin;
  }

  static Future<bool> isCurrentUserSuperAdmin() async {
    UserData? userData = await getCurrentUserData();
    return userData?.isSuperAdmin ?? false;
  }

  static Future<bool> isCurrentUserSuperAdminAdmin() async {
    UserData? userData = await getCurrentUserData();
    return (userData?.isAdmin ?? false) || (userData?.isSuperAdmin ?? false);
  }

  // NEW: Check if user can upload nasheeds
  static Future<bool> canCurrentUserUpload() async {
    UserData? userData = await getCurrentUserData();
    return userData?.hasUploadAccess ?? false;
  }

  // NEW: Check if user can push to all users
  static Future<bool> canCurrentUserPush() async {
    UserData? userData = await getCurrentUserData();
    return userData?.hasPushAccess ?? false;
  }

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

  static Future<Map<String, dynamic>> updateAdminStatus(
      String uid,
      bool isAdmin,
      bool isSuperAdmin,
      ) async {
    try {
      UserData? currentUser = await getCurrentUserData();
      if (currentUser?.isSuperAdmin != true) {
        return {'success': false, 'message': 'هذه العملية تتطلب صلاحيات المدير العام'};
      }

      await _firestore.collection('users').doc(uid).update({
        'is_admin': isAdmin,
        'is_super_admin': isSuperAdmin,
      });

      String? currentUid = await getCurrentUserUid();
      await _firestore.collection('admin_logs').add({
        'action': isSuperAdmin ? 'super_admin_granted' : isAdmin ? 'admin_granted' : 'admin_revoked',
        'performed_by': currentUid,
        'target_user': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      String message = isSuperAdmin ? 'تم منح صلاحيات المدير العام'
          : isAdmin ? 'تم منح صلاحيات المدير'
          : 'تم إزالة الصلاحيات';

      return {'success': true, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'فشل تحديث الصلاحيات: ${e.toString()}'};
    }
  }

  // NEW: Update uploader role
  static Future<Map<String, dynamic>> updateUploaderStatus(
      String uid,
      bool isUploader,
      ) async {
    try {
      UserData? currentUser = await getCurrentUserData();
      if (currentUser?.isSuperAdmin != true) {
        return {'success': false, 'message': 'هذه العملية تتطلب صلاحيات المدير العام'};
      }

      await _firestore.collection('users').doc(uid).update({
        'is_uploader': isUploader,
        // If removing uploader, also remove can_push
        if (!isUploader) 'can_push': false,
      });

      String? currentUid = await getCurrentUserUid();
      await _firestore.collection('admin_logs').add({
        'action': isUploader ? 'uploader_granted' : 'uploader_revoked',
        'performed_by': currentUid,
        'target_user': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': isUploader ? 'تم منح صلاحية التحميل' : 'تم إزالة صلاحية التحميل',
      };
    } catch (e) {
      return {'success': false, 'message': 'فشل: ${e.toString()}'};
    }
  }

  // NEW: Toggle can_push flag
  static Future<Map<String, dynamic>> updateCanPush(
      String uid,
      bool canPush,
      ) async {
    try {
      UserData? currentUser = await getCurrentUserData();
      if (currentUser?.isSuperAdmin != true) {
        return {'success': false, 'message': 'هذه العملية تتطلب صلاحيات المدير العام'};
      }

      await _firestore.collection('users').doc(uid).update({
        'can_push': canPush,
      });

      return {
        'success': true,
        'message': canPush ? 'تم تفعيل صلاحية الإرسال' : 'تم إلغاء صلاحية الإرسال',
      };
    } catch (e) {
      return {'success': false, 'message': 'فشل: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> disableAccount(String uid, String userName) async {
    try {
      String? currentUid = await getCurrentUserUid();
      UserData? currentUser = await getCurrentUserData();
      UserData? targetUser = await getUserByUid(uid);

      if (targetUser?.isSuperAdmin == true && currentUser?.isSuperAdmin != true) {
        return {'success': false, 'message': 'لا يمكن تعطيل حساب المدير العام'};
      }

      await _firestore.collection('users').doc(uid).update({
        'is_disabled': true,
        'disabled_at': FieldValue.serverTimestamp(),
        'disabled_by': currentUid,
        'account_status': 'disabled',
      });

      await _firestore.collection('admin_logs').add({
        'action': 'account_disabled',
        'performed_by': currentUid,
        'target_user': uid,
        'target_user_name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'تم تعطيل حساب "$userName" بنجاح'};
    } catch (e) {
      return {'success': false, 'message': 'فشل تعطيل الحساب: $e'};
    }
  }

  static Future<Map<String, dynamic>> enableAccount(String uid, String userName) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'is_disabled': false,
        'disabled_at': FieldValue.delete(),
        'disabled_by': FieldValue.delete(),
        'account_status': 'active',
        'enabled_at': FieldValue.serverTimestamp(),
      });

      String? currentUid = await getCurrentUserUid();
      await _firestore.collection('admin_logs').add({
        'action': 'account_enabled',
        'performed_by': currentUid,
        'target_user': uid,
        'target_user_name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'تم تفعيل حساب "$userName" بنجاح'};
    } catch (e) {
      return {'success': false, 'message': 'فشل تفعيل الحساب: $e'};
    }
  }

  static Future<Map<String, dynamic>> toggleAccountStatus(
      String uid, bool currentStatus, String userName) async {
    if (currentStatus) {
      return await enableAccount(uid, userName);
    } else {
      return await disableAccount(uid, userName);
    }
  }

  static Future<bool> isAccountDisabled(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return true;
      return (doc.data() as Map)['is_disabled'] ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}