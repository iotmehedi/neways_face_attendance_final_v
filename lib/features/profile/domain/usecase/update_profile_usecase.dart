import '../repository/update_profile_repository.dart';

abstract class UpdateProfileUseCase {
  final UpdateProfileRepository updateProfileRepository;

  UpdateProfileUseCase(this.updateProfileRepository);
}

