import '../repository/get_employee_face_repository.dart';

abstract class GetEmployeeFaceUseCase {
  final GetEmployeeFaceRepository getEmployeeFaceRepository;

  GetEmployeeFaceUseCase(this.getEmployeeFaceRepository);
}
