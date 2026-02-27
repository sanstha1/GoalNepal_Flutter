enum RegistrationStatus { initial, loading, success, error }

class RegistrationState {
  final RegistrationStatus status;
  final String? errorMessage;

  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.errorMessage,
  });

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? errorMessage,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
