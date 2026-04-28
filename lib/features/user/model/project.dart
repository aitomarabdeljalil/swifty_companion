enum ProjectStatus {
  success,
  failed,
  inProgress,
  unknown,
}

class Project {
  Project({
    required this.name,
    required this.status,
    this.finalMark,
  });

  final String name;
  final ProjectStatus status;
  final int? finalMark;
}
