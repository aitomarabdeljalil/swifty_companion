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
    required this.rawStatus,
    required this.validated,
    this.finalMark,
  });

  final String name;
  final ProjectStatus status;
  final String rawStatus;
  final bool? validated;
  final int? finalMark;

  bool get isFinished => rawStatus == 'finished';

  bool get isSuccess => validated == true;
}
