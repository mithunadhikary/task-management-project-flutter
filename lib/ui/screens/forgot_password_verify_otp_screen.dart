import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/screens/reset_password_screen.dart';
import 'package:task_management_project_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_flutter/ui/utils/app_colors.dart';
import 'package:task_management_project_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management_project_flutter/ui/widgets/screen_background.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key, required this.email});

  static const String name = '/forgot-password/verify-otp';

  final String? email;

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _verifyOtpScreenInProgress = false;

  @override
  void initState() {
    super.initState();
  }

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
                  Text('PIN Verification', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits of OTP has been sent to your email address',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildPinCodeTextField(),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _verifyOtpScreenInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapVerifyOtpScreenInButton,
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

  void _onTapVerifyOtpScreenInButton() {
    if (_formKey.currentState!.validate()) {
      _verifyOtpIn();
    }
  }

  Future<void> _verifyOtpIn() async {
    final finalEmail = widget.email;
    _verifyOtpScreenInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.verifyEmailOtpUrl(finalEmail!, _otpTEController.text.trim()));

    if (response.isSuccess && response.responseData!['status'] != "fail") {
      Navigator.pushNamed(context, ResetPasswordScreen.name);
    } else {
      _verifyOtpScreenInProgress = false;
      setState(() {});
      if (response.statusCode == 401) {
        showSnackBarMessage(context, 'Invalid OTP! Try again.');
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpTEController,
      appContext: context,
    );
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
    _otpTEController.dispose();
    super.dispose();
  }
}