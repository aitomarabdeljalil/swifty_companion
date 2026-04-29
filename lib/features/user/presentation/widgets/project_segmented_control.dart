import 'package:flutter/material.dart';

enum ProjectFilter {
  core,
  piscine,
}

class ProjectSegmentedControl extends StatelessWidget {
  const ProjectSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProjectFilter value;
  final ValueChanged<ProjectFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ProjectFilter>(
      segments: const [
        ButtonSegment<ProjectFilter>(
          value: ProjectFilter.core,
          label: Text('Core Projects'),
        ),
        ButtonSegment<ProjectFilter>(
          value: ProjectFilter.piscine,
          label: Text('Piscine'),
        ),
      ],
      selected: <ProjectFilter>{value},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
    );
  }
}
