import 'package:goal_nepal/core/constants/hive_table_constant.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTableTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String? profilePicture;

  AuthHiveModel({
    String? authId, // this is auto increment so using Uuid
    required this.fullName,
    required this.email,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  //From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  get id => null;

  //To entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //To Entity list
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
