import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/models/task_model.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/screens/completed_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_management_project_flutter/ui/screens/progress_task_list_screen.dart';
import 'package:task_management_project_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management_project_flutter/ui/widgets/screen_background.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_management_project_flutter/ui/widgets/tm_app_bar.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({super.key, required this.task});

  static const String name = '/update-task';

  final TaskModel task;

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final TextEditingController _statusTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateTaskLoading= false;

  @override
  void initState() {
    super.initState();
    _statusTEController.text = widget.task.status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String? _selectedStatus = _statusTEController.text;

    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text('Update Task Status', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: ['New', 'Progress', 'Completed', 'Cancelled']
                        .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                        _statusTEController.text = _selectedStatus ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _updateTaskLoading == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                            _updateTask();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateTask() async {
    _updateTaskLoading = true;
    setState(() {});

    final status = _statusTEController.text ?? '';

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.updateTaskStatusUrl(widget.task.sId ?? '', status));

    _updateTaskLoading = false;
    setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, "Task status updated successfully!");
      Navigator.pushNamed(context, _getNextScreen(status));
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  String _getNextScreen(String status) {
    if (status == 'New') {
      return MainBottomNavScreen.name;
    } else if (status == 'Progress') {
      return ProgressTaskListScreen.name;
    } else if(status == 'Completed') {
      return CompletedTaskListScreen.name;
    } else {
      return CancelledTaskListScreen.name;
    }
  }
}
