
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nasheedapp/starting/resetPasswordPage.dart';

import '../configuration/images.dart';
import '../configuration/theme.dart';
import '../home/dynamicHomePage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isRegistering = false;
  bool _codeSent = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _verificationId = '';

  bool _guestModeEnabled = false; // ADD THIS

  @override
  void initState() {
    super.initState();
    _checkGuestMode(); // ADD THIS
  }

  // ADD THIS METHOD
  Future<void> _checkGuestMode() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('admin')
          .get();
      if (mounted) {
        setState(() {
          _guestModeEnabled = doc.data()?['guest_mode_enabled'] == true;
        });
      }
    } catch (_) {}
  }

  // ADD THIS METHOD
  Future<void> _continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    await prefs.setBool('is_logged_in', false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DynamicHomePage()),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Hash password with salt
  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate random salt
  String _generateSalt() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return _hashPassword(timestamp, 'salt_seed');
  }

  // Format phone number
  String _formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (phoneNumber.startsWith('00962')) {
      phoneNumber = '+${phoneNumber.substring(2)}';
    } else if (phoneNumber.startsWith('0962')) {
      phoneNumber = '+${phoneNumber.substring(1)}';
    } else if (phoneNumber.startsWith('962')) {
      phoneNumber = '+$phoneNumber';
    } else if (phoneNumber.startsWith('07')) {
      phoneNumber = '+962${phoneNumber.substring(1)}';
    } else if (phoneNumber.startsWith('7') && phoneNumber.length == 9) {
      phoneNumber = '+962$phoneNumber';
    } else if (!phoneNumber.startsWith('+')) {
      return '';
    }
    return phoneNumber;
  }

  // Save login session to SharedPreferences
  Future<void> _saveLoginSession(String uid, String phoneNumber, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
    await prefs.setString('user_phone', phoneNumber);
    await prefs.setString('user_name', name);
    await prefs.setBool('is_logged_in', true);
  }

  // LOGIN with phone + password (NO OTP!)
  Future<void> _loginWithPassword() async {
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phoneNumber.isEmpty || password.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم الهاتف وكلمة المرور');
      return;
    }

    phoneNumber = _formatPhoneNumber(phoneNumber);
    if (phoneNumber.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم الهاتف بصيغة صحيحة');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Query Firestore for user with this phone number
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() => _isLoading = false);
        _showSnackBar('المستخدم غير موجود. الرجاء التسجيل أولاً');
        return;
      }

      final userData = querySnapshot.docs.first.data();

      // Check if account is disabled
      if (userData['is_disabled'] == true) {
        setState(() => _isLoading = false);
        _showSnackBar('هذا الحساب معطل. الرجاء التواصل مع الإدارة');
        return;
      }

      final storedPasswordHash = userData['passwordHash'];
      final storedSalt = userData['passwordSalt'] ?? '';

      // Hash the entered password with the stored salt
      final enteredPasswordHash = storedSalt.isNotEmpty
          ? _hashPassword(password, storedSalt)
          : _hashPassword(password, '');

      if (storedPasswordHash != enteredPasswordHash) {
        setState(() => _isLoading = false);
        _showSnackBar('كلمة المرور غير صحيحة');
        return;
      }

      // ✅ Password is correct - save session
      String uid = querySnapshot.docs.first.id;
      String userName = userData['name'] ?? 'User';

      // Update last login in Firestore
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      // Save session in SharedPreferences (for persistence)
      await _saveLoginSession(uid, phoneNumber, userName);

      setState(() => _isLoading = false);

      // Navigate to home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DynamicHomePage()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('خطأ في تسجيل الدخول: $e');
    }
  }

  // REGISTER - Step 1: Send OTP
  Future<void> _sendOTPForRegistration() async {
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (phoneNumber.isEmpty || password.isEmpty || name.isEmpty) {
      _showSnackBar('الرجاء ملء جميع الحقول');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    phoneNumber = _formatPhoneNumber(phoneNumber);
    if (phoneNumber.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم الهاتف بصيغة صحيحة مع رمز الدولة');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if user already exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() => _isLoading = false);
        _showSnackBar('هذا الرقم مسجل بالفعل. الرجاء تسجيل الدخول');
        return;
      }

      // Send OTP via Firebase Phone Authentication
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _completeRegistration(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          String errorMessage = _getErrorMessage(e);
          _showSnackBar(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
          _showSnackBar('تم إرسال رمز التحقق بنجاح');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _verificationId = verificationId);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('خطأ: $e');
    }
  }

  // REGISTER - Step 2: Verify OTP and complete registration
  Future<void> _verifyOTPAndRegister() async {
    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );

      await _completeRegistration(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('رمز التحقق غير صحيح: $e');
    }
  }

  // Complete registration: Create Firebase Auth user + Save to Firestore
  Future<void> _completeRegistration(PhoneAuthCredential credential) async {
    try {
      // ✅ Sign in with phone credential (creates Firebase Auth user)
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String phoneNumber = _formatPhoneNumber(_phoneController.text.trim());
        String password = _passwordController.text.trim();
        String name = _nameController.text.trim();

        // Generate salt and hash password
        String salt = _generateSalt();
        String passwordHash = _hashPassword(password, salt);

        // ✅ Save user data to Firestore (with password hash)
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'phoneNumber': phoneNumber,
          'name': name,
          'passwordHash': passwordHash,
          'passwordSalt': salt,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'is_admin': false,
          'is_super_admin': false,
          'is_disabled': false,
        });

        // Save session
        await _saveLoginSession(user.uid, phoneNumber, name);

        setState(() => _isLoading = false);

        // Navigate to home
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DynamicHomePage()),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('فشل التسجيل: $e');
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'صيغة رقم الهاتف غير صحيحة';
      case 'too-many-requests':
        return 'عدد كبير من المحاولات. الرجاء المحاولة لاحقاً';
      case 'operation-not-allowed':
        return 'المصادقة عبر الهاتف غير مفعلة';
      default:
        return 'خطأ: ${e.message}';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),

                  // Logo
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImagePath.qubah1,
                      height: 150,
                    ),
                  ),

                  Text(
                    'تطبيق قصائد زاوية الكردي',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme_Information.Color_5,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Toggle between Login and Registration
                  if (!_codeSent) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _isRegistering = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isRegistering
                                  ? Theme_Information.Primary_Color
                                  : Colors.grey[300],
                              foregroundColor: !_isRegistering ? Colors.white : Colors.black,
                            ),
                            child: Text('تسجيل الدخول'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _isRegistering = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isRegistering
                                  ? Theme_Information.Primary_Color
                                  : Colors.grey[300],
                              foregroundColor: _isRegistering ? Colors.white : Colors.black,
                            ),
                            child: Text('إنشاء حساب'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],

                  // OTP VERIFICATION SCREEN
                  if (_codeSent) ...[
                    Text(
                      'أدخل رمز التحقق',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme_Information.Color_5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'رمز التحقق',
                          hintText: 'XXXXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTPAndRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme_Information.Primary_Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'تأكيد التسجيل',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _codeSent = false;
                          _otpController.clear();
                        });
                      },
                      child: Text('تغيير المعلومات'),
                    ),
                  ]
                  // LOGIN/REGISTRATION FORM
                  else ...[
                    // Name field (only for registration)
                    if (_isRegistering) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم الكامل',
                          hintText: 'أدخل اسمك',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],

                    // Phone number field
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          hintText: '0096279XXXXXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        hintText: _isRegistering ? '6 أحرف على الأقل' : 'أدخل كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                    ),

                    // Forgot Password link (only for login)
                    if (!_isRegistering) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: Theme_Information.Primary_Color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: _isRegistering ? 25 : 10),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _isRegistering
                            ? _sendOTPForRegistration
                            : _loginWithPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme_Information.Primary_Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          _isRegistering ? 'إرسال رمز التحقق' : 'تسجيل الدخول',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],

                  if (_guestModeEnabled && !_codeSent) ...[
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _continueAsGuest,
                        child: Text(
                          'تصفح بدون تسجيل',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 40),

                  // Bottom logo
                  Image.asset(
                    ImagePath.logoMediaBlackWithLink,
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}