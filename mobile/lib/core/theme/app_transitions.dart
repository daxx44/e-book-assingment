import 'package:get/get.dart';

class AppTransitions {
  AppTransitions._();

  static const Duration duration = Duration(milliseconds: 380);

  static GetPage<T> page<T>({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    bool fullscreen = false,
  }) {
    return GetPage<T>(
      name: name,
      page: page,
      binding: binding,
      transition: Transition.cupertino,
      transitionDuration: duration,
      fullscreenDialog: fullscreen,
    );
  }

  static GetPage<T> fade<T>({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
  }) {
    return GetPage<T>(
      name: name,
      page: page,
      binding: binding,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 320),
    );
  }
}
