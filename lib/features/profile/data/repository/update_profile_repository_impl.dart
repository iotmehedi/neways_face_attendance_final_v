
import '../../../../../../core/source/model/api_response.dart';
import '../../domain/repository/update_profile_repository.dart';
import '../model/update_profile_model.dart';
import '../source/update_profile_service.dart';
import 'package:dio/dio.dart'as dio;
class UpdateProfileRepositoryImpl extends UpdateProfileRepository {
  UpdateProfileRepositoryImpl(UpdateProfileService updateProfileService) : super(updateProfileService);

  @override
  Future<Response<UpdateProfileModel?>?> updateProfilePass() async {
    Response<UpdateProfileModel>? apiResponse;
    apiResponse = await updateProfileService.updateProfilePass();
    return apiResponse;
  }

}
