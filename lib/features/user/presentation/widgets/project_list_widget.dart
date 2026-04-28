import 'package:flutter/material.dart';

import '../../../../core/utils/app_card.dart';
import '../../model/project.dart';

class ProjectListWidget extends StatelessWidget {
  const ProjectListWidget({super.key, required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final finishedProjects = projects.where((project) => project.isFinished).toList();

    if (finishedProjects.isEmpty) {
      return const Text('No projects found');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: finishedProjects.length,
      itemBuilder: (context, index) {
        final project = finishedProjects[index];
        final color = project.isSuccess ? Colors.green.shade700 : Colors.red.shade600;
        final markLabel = project.finalMark?.toString() ?? 'N/A';

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 220),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(project.isSuccess ? Icons.check_circle : Icons.cancel, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  markLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
