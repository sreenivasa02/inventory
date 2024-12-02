import 'package:get/get.dart';

import '../controllers/new_billings_controller.dart';

class NewBillingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewBillingsController>(
      () => NewBillingsController(),
    );
  }
}
