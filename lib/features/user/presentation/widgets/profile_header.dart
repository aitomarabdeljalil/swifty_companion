import 'package:flutter/material.dart';

import '../../model/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundImage: user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
              child: user.imageUrl.isEmpty ? const Icon(Icons.person, size: 32) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.login,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(user.email),
                  const SizedBox(height: 4),
                  Text('Location: ${user.location}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
