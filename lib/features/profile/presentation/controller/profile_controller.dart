
import 'package:get/get.dart';
import '../../../../core/app_component/app_component.dart';
import '../../data/model/update_profile_model.dart';
import '../../domain/repository/update_profile_repository.dart';
import '../../domain/usecase/update_profile_pass_usecase.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileModel = UpdateProfileModel().obs;

  @override
  void onInit() {
    profileFun();
    super.onInit();
  }


  void profileFun() async {
    isLoading.value = true;

    // try {
      final useCase =
      UpdateProfilePassUseCase(locator<UpdateProfileRepository>());
      final response = await useCase();

      if (response?.data != null) {
        profileModel.value = response!.data!;
        isLoading.value = false;

      }
        isLoading.value = false;

    // } catch (e) {
    //   isLoading.value = false;
    // } finally {
    //   isLoading.value = false;
    // }
    update();
  }


}
