import 'package:get/get.dart';

import 'draft_controller.dart';

class DraftListBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DreftListController>(DreftListController());
  }
}
