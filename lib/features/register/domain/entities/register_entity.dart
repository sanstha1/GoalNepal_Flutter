class PlayerEntity {
  final String name;
  final String? position;
  final int? jerseyNumber;

  const PlayerEntity({required this.name, this.position, this.jerseyNumber});

  Map<String, dynamic> toJson() => {
    'name': name,
    if (position != null) 'position': position,
    if (jerseyNumber != null) 'jerseyNumber': jerseyNumber,
  };
}

class RegistrationEntity {
  final String? id;
  final String tournamentId;
  final String teamName;
  final String captainName;
  final String captainPhone;
  final String captainEmail;
  final int playerCount;
  final List<PlayerEntity> players;
  final String status;
  final String registeredBy;
  final DateTime? createdAt;

  const RegistrationEntity({
    this.id,
    required this.tournamentId,
    required this.teamName,
    required this.captainName,
    required this.captainPhone,
    required this.captainEmail,
    required this.playerCount,
    required this.players,
    required this.status,
    required this.registeredBy,
    this.createdAt,
  });
}
