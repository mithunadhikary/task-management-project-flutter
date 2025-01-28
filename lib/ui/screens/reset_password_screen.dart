import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/controllers/auth_controller.dart';
import 'package:task_management_project_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_flutter/ui/utils/app_colors.dart';
import 'package:task_management_project_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management_project_flutter/ui/widgets/screen_background.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  static const String name = '/forgot-password/reset-password';

  final String? email;
  final String? otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
  TextEditingController();
  final TextEditingController _confirmPasswordTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _restPasswordScreenInProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text('Set Password', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Minimum length of password should be more than 8 letters.',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(hintText: 'New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration:
                    const InputDecoration(hintText: 'Confirm New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter confirm new password';
                      }
                      if (value != _newPasswordTEController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _restPasswordScreenInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapResetPasswordScreenInButton,
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: _buildSignInSection(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapResetPasswordScreenInButton() {
    if (_formKey.currentState!.validate()) {
      _resetPasswordIn();
    }
  }

  Future<void> _resetPasswordIn() async {
    _restPasswordScreenInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _newPasswordTEController.text.trim(),
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.recoverResetPasswordUrl, body: requestBody);
    _restPasswordScreenInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _newPasswordTEController.clear();
      _confirmPasswordTEController.clear();
      await AuthController.clearUserData();
      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.name, (predicate) => false);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an account? ",
        style:
        const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}