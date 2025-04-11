import 'package:sample_app/dependency_injection/service_locator.dart';

class SampleAppInit {
  static Future launchInit(String? applicationDocumentsDirectoryPath) async {
    // List<CollectionSchema> isarCollections = [];
    // // isarCollections.addAll(IsarConfiguration.isarSchemas);

    // var isar = await Isar.open(isarCollections,
    //     directory: applicationDocumentsDirectoryPath ?? '', inspector: false);

    await setupServiceLocator(
      applicationDocumentsDirectoryPath,
      // isar,
    );
  }
}
