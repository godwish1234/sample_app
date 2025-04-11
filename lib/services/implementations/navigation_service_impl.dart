import 'package:sample_app/services/interfaces/navigation_service.dart';

class NavigationServiceImpl extends NavigationService {
  Future<void> navigateTo(String routeName, {Object? arguments}) {
    // Implement your navigation logic here
    // For example, using Navigator.pushNamed(context, routeName, arguments: arguments);
    return Future.value();
  }
  void goBack({Object? result}) {
    // Implement your back navigation logic here
    // For example, using Navigator.pop(context, result);
  }
  void popUntil(String routeName) {
    // Implement your popUntil logic here
    // For example, using Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}