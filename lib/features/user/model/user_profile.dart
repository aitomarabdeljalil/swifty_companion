import 'project.dart';
import 'skill.dart';

class UserProfile {
  UserProfile({
    required this.id,
    required this.login,
    required this.email,
    required this.wallet,
    required this.level,
    required this.location,
    required this.imageUrl,
    required this.coalitionCoverUrl,
    required this.isStaff,
    required this.skills,
    required this.projects,
  });

  final int id;
  final String login;
  final String email;
  final int wallet;
  final double level;
  final String location;
  final String imageUrl;
  final String? coalitionCoverUrl;
  final bool isStaff;
  final List<Skill> skills;
  final List<Project> projects;

  UserProfile copyWith({
    String? coalitionCoverUrl,
  }) {
    return UserProfile(
      id: id,
      login: login,
      email: email,
      wallet: wallet,
      level: level,
      location: location,
      imageUrl: imageUrl,
      coalitionCoverUrl: coalitionCoverUrl ?? this.coalitionCoverUrl,
      isStaff: isStaff,
      skills: skills,
      projects: projects,
    );
  }

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    final cursusUsers = (json['cursus_users'] as List?) ?? <dynamic>[];
    Map<String, dynamic>? selectedCursus;

    for (final cursus in cursusUsers) {
      final cursusMap = cursus as Map<String, dynamic>;
      final id = (cursusMap['cursus'] as Map<String, dynamic>?)?['id'];
      if (id == 21) {
        selectedCursus = cursusMap;
        break;
      }
    }

    selectedCursus ??= cursusUsers.isNotEmpty ? cursusUsers.first as Map<String, dynamic> : null;

    final skillsJson = (selectedCursus?['skills'] as List?) ?? <dynamic>[];
    final skills = skillsJson
        .map((skill) {
          final skillMap = skill as Map<String, dynamic>;
          return Skill(
            name: skillMap['name'] as String? ?? 'Unknown',
            level: (skillMap['level'] as num? ?? 0).toDouble(),
          );
        })
        .toList();

    final projectsJson = (json['projects_users'] as List?) ?? <dynamic>[];
    final projects = projectsJson
        .map((entry) {
          final project = (entry as Map<String, dynamic>)['project'] as Map<String, dynamic>?;
          final name = project?['name'] as String? ?? 'Unknown';
          final statusRaw = entry['status'] as String? ?? 'unknown';
          final validated = entry['validated?'] as bool?;
          final status = _mapProjectStatus(statusRaw, validated);
          final mark = (entry['final_mark'] as num?)?.toInt();
          return Project(
            name: name,
            status: status,
            rawStatus: statusRaw,
            validated: validated,
            finalMark: mark,
          );
        })
        .where((project) => project.name.isNotEmpty)
        .toList();

    return UserProfile(
      id: (json['id'] as num? ?? 0).toInt(),
      login: json['login'] as String? ?? 'unknown',
      email: json['email'] as String? ?? 'unknown',
      wallet: (json['wallet'] as num? ?? 0).toInt(),
      level: (selectedCursus?['level'] as num? ?? 0).toDouble(),
      location: json['location'] as String? ?? 'Unavailable',
      imageUrl: (json['image'] as Map<String, dynamic>?)?['link'] as String? ?? '',
      coalitionCoverUrl: null,
      isStaff: (json['staff?'] as bool?) ?? (json['staff'] as bool?) ?? false,
      skills: skills,
      projects: projects,
    );
  }

  static ProjectStatus _mapProjectStatus(String status, bool? validated) {
    if (status == 'in_progress') {
      return ProjectStatus.inProgress;
    }
    if (validated == true) {
      return ProjectStatus.success;
    }
    if (validated == false && status == 'finished') {
      return ProjectStatus.failed;
    }
    return ProjectStatus.unknown;
  }
}
