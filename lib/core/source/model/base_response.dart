import '../../network/configuration.dart';

class BaseResponse {
  int status = NetworkConfiguration.connectionError;

  int get getStatusCode => status;
}
