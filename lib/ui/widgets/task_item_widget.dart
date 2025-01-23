import 'package:flutter/material.dart';
import 'package:task_management_project_flutter/data/models/task_model.dart';
import 'package:task_management_project_flutter/data/services/network_caller.dart';
import 'package:task_management_project_flutter/data/utils/urls.dart';
import 'package:task_management_project_flutter/ui/widgets/snack_bar_message.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskModel.description ?? ''),
            Text('Date: ${taskModel.createdDate ?? ''}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _getStatusColor(taskModel.status ?? 'New'),
                  ),
                  child: Text(
                    taskModel.status ?? 'New',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteTask(context, taskModel.sId);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        _updateTaskStatus(context, taskModel.sId, taskModel.status);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context, id) async {
    bool? confirmStatusUpdate = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Return false on "No"
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Return true on "Yes"
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (confirmStatusUpdate == true) {
      final NetworkResponse response =
      await NetworkCaller.getRequest(url: Urls.deleteTaskUrl(id));
      if (response.isSuccess) {
        showSnackBarMessage(context, "This Task has been successfully deleted!");
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  Future<void> _updateTaskStatus(BuildContext context, id, status) async {
    bool? confirmStatusUpdate = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Update Status'),
          content: const Text('Are you sure you want to update this task status?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Return false on "No"
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Return true on "Yes"
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (confirmStatusUpdate == true) {
      final NetworkResponse response =
      await NetworkCaller.getRequest(url: Urls.updateTaskStatusUrl(id, _getNextStatus(status)));
      if (response.isSuccess) {
        showSnackBarMessage(context, "Task status updated successfully!");
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  String _getNextStatus(String status) {
    if (status == 'New') {
      return 'Progress';
    } else if (status == 'Progress') {
      return 'Completed';
    } else if (status == 'Completed') {
      return 'Cancelled';
    } else {
      return 'New';
    }
  }
}