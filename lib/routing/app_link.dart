import '/routing/app_link_location_keys.dart';

/// AppLink is an intermediary object between a URL string and the state of the application
/// The objective of this class is to parse the navigation configuration to and from a URL string
class AppLink {
  String locationKey;
  String realPath;
  Map<String, String>? parameters;

  AppLink({required this.locationKey, required this.realPath, this.parameters});

  /// Converts a URL to an AppLink object
  static AppLink fromLocation(String? location) {
    location = Uri.decodeFull(location ?? '');
    location = location.replaceFirst('/#/', '/');

    final uri = Uri.parse(location);

    var subPathSegments = uri.pathSegments;
    var locationKey = AppLinkLocationKeys.home;

    if (subPathSegments.isNotEmpty) {
      // Handle '/home'
      if (location == AppLinkLocationKeys.home) {
        locationKey = AppLinkLocationKeys.home;
      }
    }
    return AppLink(locationKey: locationKey, realPath: uri.path);
  }

  /// Converts an AppLink object to a url
  String toLocation() {
    // Used to build up query parameters
    // String addKeyValPair({
    //   required String key,
    //   String? value,
    // }) =>
    //     value == null ? '' : '$key=$value&';

    switch (locationKey) {
      case AppLinkLocationKeys.login:
      case AppLinkLocationKeys.home:
        return realPath;
      default:
        return AppLinkLocationKeys.home;
    }
  }
}
