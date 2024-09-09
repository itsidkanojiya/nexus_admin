import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  static RxInt indexValue = 0.obs;
  static RxInt subTeacherIndex = 0.obs;
  static RxInt analysisIndex = 0.obs;
  static RxInt subQuetionIndex = 0.obs;
  static final storage = GetStorage();
  static String? get token =>
      storage.read('token') != null ? storage.read('token')['jwt'] : null;
}
