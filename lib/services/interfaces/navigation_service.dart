abstract class NavigationService {
  Future<void> navigateTo(String routeName, {Object? arguments});
  void goBack({Object? result});
  void popUntil(String routeName);
}