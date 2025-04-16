

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/update_profile_model.dart';
import '../../data/source/update_profile_service.dart';
import 'package:dio/dio.dart'as dio;
abstract class UpdateProfileRepository {
  final UpdateProfileService updateProfileService;

  UpdateProfileRepository(this.updateProfileService);

  Future<Response<UpdateProfileModel?>?> updateProfilePass();
}
