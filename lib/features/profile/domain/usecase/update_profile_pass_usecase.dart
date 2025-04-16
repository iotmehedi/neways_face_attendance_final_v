
import 'package:dio/dio.dart'as dio;

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/update_profile_model.dart';
import 'update_profile_usecase.dart';

class UpdateProfilePassUseCase extends UpdateProfileUseCase {
  UpdateProfilePassUseCase(super.updateProfileRepository);

  Future<Response<UpdateProfileModel?>?> call() async {

    var response = await updateProfileRepository.updateProfilePass();
    return response;
  }
}

