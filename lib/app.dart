import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/models/task_model.dart';
import 'package:task_management_project_flutter/ui/screens/add_new_task_screen.dart';
import 'package:task_management_project_flutter/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/screens/completed_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_management_project_flutter/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_management_project_flutter/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_management_project_flutter/ui/screens/progress_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/screens/reset_password_screen.dart';
import 'package:task_management_project_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_flutter/ui/screens/sign_up_screen.dart';
import 'package:task_management_project_flutter/ui/screens/splash_screen.dart';
import 'package:task_management_project_flutter/ui/screens/update_profile_screen.dart';
import 'package:task_management_project_flutter/ui/screens/update_task_screen.dart';
import 'package:task_management_project_flutter/ui/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          fillColor: Colors.white,
          hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),

      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;

        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();
        } else if (settings.name == SignInScreen.name) {
          widget = const SignInScreen();
        } else if (settings.name == SignUpScreen.name) {
          widget = const SignUpScreen();
        } else if (settings.name == ForgotPasswordVerifyEmailScreen.name) {
          widget = const ForgotPasswordVerifyEmailScreen();
        } else if (settings.name == ForgotPasswordVerifyOtpScreen.name) {
          final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
          widget = ForgotPasswordVerifyOtpScreen(email: args?['email']);
        } else if (settings.name == ResetPasswordScreen.name) {
          final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
          widget = ResetPasswordScreen(email: args?['email'], otp: args?['otp']);
        } else if (settings.name == MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();
        } else if (settings.name == ProgressTaskListScreen.name) {
          widget = const ProgressTaskListScreen();
        } else if (settings.name == CompletedTaskListScreen.name) {
          widget = const CompletedTaskListScreen();
        } else if (settings.name == CancelledTaskListScreen.name) {
          widget = const CancelledTaskListScreen();
        } else if (settings.name == AddNewTaskScreen.name) {
          widget = const AddNewTaskScreen();
        } else if (settings.name == UpdateProfileScreen.name) {
          widget = const UpdateProfileScreen();
        } else if (settings.name == UpdateTaskScreen.name) {
          final TaskModel task = settings.arguments as TaskModel;
          widget = UpdateTaskScreen(task: task);
        }

        return MaterialPageRoute(builder: (ctx) => widget);
      },
    );
  }
}