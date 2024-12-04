import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/main_controller.dart';

class TemplateController {
  final _auth = AuthService();

  signout() {
    _auth.signOut();
    MainController.navigatorKey.currentState!.pushReplacementNamed('/login');
  }

  goToHome() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/home');
  }

  goToEventsList() {
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/eventsList');
  }

  goToMyPledgedGifts() {
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/myPledgedGifts');
  }

  goToProfile() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/profile');
  }

  goToSignUp() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/signUp');
  }

  goToLogin() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
