import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../configuration/theme.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _verificationId = '';
  bool _codeSent = false;
  bool _otpVerified = false;
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _userDocId;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Hash password with salt (more secure)
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

  // Step 1: Send OTP to verify phone number
  Future<void> _sendOTPForReset() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم الهاتف');
      return;
    }

    phoneNumber = _formatPhoneNumber(phoneNumber);
    if (phoneNumber.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم الهاتف بصيغة صحيحة');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if user exists in Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() => _isLoading = false);
        _showSnackBar('لا يوجد حساب مسجل بهذا الرقم');
        return;
      }

      // Check if account is disabled
      Map<String, dynamic> userData = querySnapshot.docs.first.data();
      if (userData['is_disabled'] == true) {
        setState(() => _isLoading = false);
        _showSnackBar('هذا الحساب معطل. لا يمكن إعادة تعيين كلمة المرور');
        return;
      }

      // Store user document ID for later use
      _userDocId = querySnapshot.docs.first.id;

      // Send OTP
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification on some devices
          await _verifyOTPAutomatically(credential);
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

  // Step 2: Verify OTP
  Future<void> _verifyOTP() async {
    String otpCode = _otpController.text.trim();

    if (otpCode.isEmpty || otpCode.length != 6) {
      _showSnackBar('الرجاء إدخال رمز التحقق المكون من 6 أرقام');
      return;
    }

    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      await _verifyOTPAutomatically(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('رمز التحقق غير صحيح');
    }
  }

  Future<void> _verifyOTPAutomatically(PhoneAuthCredential credential) async {
    try {
      // Verify the credential (we don't need to actually sign in)
      await _auth.signInWithCredential(credential);

      setState(() {
        _otpVerified = true;
        _isLoading = false;
      });

      _showSnackBar('تم التحقق بنجاح! يمكنك الآن إنشاء كلمة مرور جديدة');

      // Sign out immediately as we just needed to verify
      await _auth.signOut();
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('فشل التحقق: $e');
    }
  }

  // Step 3: Update password in Firestore
  Future<void> _updatePassword() async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('الرجاء ملء جميع الحقول');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('كلمتا المرور غير متطابقتين');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Generate new salt and hash password
      String salt = _generateSalt();
      String passwordHash = _hashPassword(newPassword, salt);

      // Update password in Firestore
      await _firestore.collection('users').doc(_userDocId).update({
        'passwordHash': passwordHash,
        'passwordSalt': salt,
        'passwordUpdatedAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      // Show success message
      _showSnackBar('تم تغيير كلمة المرور بنجاح!');

      // Navigate back to login after 2 seconds
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('خطأ في تحديث كلمة المرور: $e');
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
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور'),
        backgroundColor: Theme_Information.Primary_Color,
        foregroundColor: Colors.white,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),

                  // Icon
                  Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Theme_Information.Primary_Color,
                  ),

                  SizedBox(height: 20),

                  Text(
                    'استعادة الحساب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme_Information.Color_5,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    _otpVerified
                        ? 'أدخل كلمة المرور الجديدة'
                        : _codeSent
                        ? 'أدخل رمز التحقق المرسل إلى هاتفك'
                        : 'أدخل رقم الهاتف المسجل لإرسال رمز التحقق',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(height: 40),

                  // STEP 1: Phone Number Input
                  if (!_codeSent && !_otpVerified) ...[
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
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendOTPForReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme_Information.Primary_Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'إرسال رمز التحقق',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],

                  // STEP 2: OTP Verification
                  if (_codeSent && !_otpVerified) ...[
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
                          prefixIcon: Icon(Icons.sms),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme_Information.Primary_Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'تحقق من الرمز',
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
                      child: Text('تغيير رقم الهاتف'),
                    ),
                  ],

                  // STEP 3: New Password Input
                  if (_otpVerified) ...[
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        hintText: '6 أحرف على الأقل',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => _obscureNewPassword = !_obscureNewPassword);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        hintText: 'أعد إدخال كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                                    () => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme_Information.Primary_Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'تحديث كلمة المرور',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}