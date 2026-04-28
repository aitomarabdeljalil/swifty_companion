import 'package:flutter/material.dart';

import '../../model/project.dart';

class ProjectTile extends StatelessWidget {
  const ProjectTile({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(project.name),
        subtitle: Text(_statusLabel(project.status)),
        trailing: Text(project.finalMark?.toString() ?? '-'),
      ),
    );
  }

  String _statusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.success:
        return 'Success';
      case ProjectStatus.failed:
        return 'Failed';
      case ProjectStatus.inProgress:
        return 'In progress';
      case ProjectStatus.unknown:
        return 'Unknown';
    }
  }
}
