enum PlayerRole { informed, impostor, innocent }

extension PlayerRoleExt on PlayerRole {
  String get name {
    switch (this) {
      case PlayerRole.informed:
        return 'Informed';
      case PlayerRole.impostor:
        return 'Impostor';
      case PlayerRole.innocent:
      default:
        return 'Innocent';
    }
  }
}
