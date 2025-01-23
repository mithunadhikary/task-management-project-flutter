import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management_project_flutter/ui/widgets/screen_background.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';
import 'package:task_management_project_flutter/ui/widgets/task_item_widget.dart';
import 'package:task_management_project_flutter/ui/widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _getCancelledTaskListInProgress = false;
  TaskListByStatusModel? progressTaskListModel;

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Visibility(
              visible: _getCancelledTaskListInProgress == false,
              replacement: const CenteredCircularProgressIndicator(),
              child: _buildTaskListView()),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: progressTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: progressTaskListModel!.taskList![index],
        );
      },
    );
  }

  Future<void> _getCancelledTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Cancelled'));
    if (response.isSuccess) {
      progressTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }
}
