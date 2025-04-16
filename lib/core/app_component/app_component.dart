import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:neways_face_attendance_pro/features/profile/data/repository/update_profile_repository_impl.dart';
import 'package:neways_face_attendance_pro/features/profile/data/source/update_profile_service.dart';
import 'package:neways_face_attendance_pro/features/profile/domain/repository/update_profile_repository.dart';
import 'package:neways_face_attendance_pro/features/profile/presentation/controller/profile_controller.dart';
import '../../features/authentication/sign_in/data/repository/login_repository_impl.dart';
import '../../features/authentication/sign_in/data/source/login_service.dart';
import '../../features/authentication/sign_in/domain/repository/login_repository.dart';
import '../../features/authentication/sign_in/presentation/controller/signin_controller.dart';
import '../../features/homepage/data/repository/get_employee_face_repository_impl.dart';
import '../../features/homepage/data/source/get_employee_face_service.dart';
import '../../features/homepage/domain/repository/get_employee_face_repository.dart';
import '../../features/homepage/presentation/controller/get_employee_face_controller.dart';
import '../source/dio_client.dart';

final locator = GetIt.instance;

Future<void> init() async {
  locator.registerFactory<Dio>(
      () => Dio()..interceptors.add(InterceptorsWrapper()));
  locator.registerFactory<DioClient>(() => DioClient(locator<Dio>()));

  //login
  locator.registerFactory<SigninController>(() => Get.put(SigninController()));
  locator.registerFactory<SignInService>(() => SignInService());
  locator.registerFactory<SignInRepository>(
      () => SignInRepositoryImpl(locator<SignInService>()));

  //sign up
  locator.registerFactory<GetEmployeeFaceController>(
      () => Get.put(GetEmployeeFaceController()));
  locator
      .registerFactory<GetEmployeeFaceService>(() => GetEmployeeFaceService());
  locator.registerFactory<GetEmployeeFaceRepository>(
      () => GetEmployeeFaceRepositoryImpl(locator<GetEmployeeFaceService>()));
  //profile page
  locator.registerFactory<ProfileController>(
      () => Get.put(ProfileController()));
  locator
      .registerFactory<UpdateProfileService>(() => UpdateProfileService());
  locator.registerFactory<UpdateProfileRepository>(
      () => UpdateProfileRepositoryImpl(locator<UpdateProfileService>()));
}
