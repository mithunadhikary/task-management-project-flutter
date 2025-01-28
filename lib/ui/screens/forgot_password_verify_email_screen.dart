import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_management_project_flutter/ui/utils/app_colors.dart';
import 'package:task_management_project_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management_project_flutter/ui/widgets/screen_background.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forgot-password/verify-email';

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _forgotPasswordVerifyEmailScreenInProgress = false;

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
                  Text('Your Email Address', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits of OTP will be sent to your email address',
                      style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email address';
                      }
                      if (!value!.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _forgotPasswordVerifyEmailScreenInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapForgotPasswordVerifyEmailScreenInButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapForgotPasswordVerifyEmailScreenInButton() {
    if (_formKey.currentState!.validate()) {
      _forgotPasswordIn();
    }
  }

  Future<void> _forgotPasswordIn() async {
    _forgotPasswordVerifyEmailScreenInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.recoverVerifyEmailUrl(_emailTEController.text.trim()));

    if (response.isSuccess && response.responseData!['status'] != "fail") {
      final email = response.responseData!['data']['accepted'][0];
      Navigator.pushNamed(
          context,
          ForgotPasswordVerifyOtpScreen.name,
          arguments: {'email': email},
      );
    } else {
      _forgotPasswordVerifyEmailScreenInProgress = false;
      setState(() {});
      if (response.statusCode == 401) {
        showSnackBarMessage(context, 'Email is invalid! Try again.');
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
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
                Navigator.pop(context);
              },
          )
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}