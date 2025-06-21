import 'package:get_it/get_it.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/services/implementations/booking_service_impl.dart';
import 'package:sample_app/services/implementations/navigation_service_impl.dart';
import 'package:sample_app/services/interfaces/booking_service.dart';
import 'package:sample_app/services/interfaces/navigation_service.dart';
import 'package:sample_app/services/services.dart';


final GetIt serviceLocator = GetIt.instance;

Future setupServiceLocator(
  String? applicationDocumentsDirectoryPath,
  // Isar isar,
) async {
  // Providers
  // serviceLocator.registerSingleton<UserSettingsRepository>(
  //   UserSettingsRepositoryImpl(isar: isar),
  // );
  // var userSettingSvc = UserSettingsServiceImpl();
  // await Future.wait([
  //   userSettingSvc.initialize(),
  // ]);
  // serviceLocator.registerSingleton<UserSettingsService>(userSettingSvc);

  // serviceLocator
  //     .registerSingleton<UserSettingsProvider>(UserSettingsProviderImpl());
  serviceLocator.registerSingleton<AppStateManager>(AppStateManager());
  serviceLocator
      .registerSingleton<AuthenticationService>(AuthenticationServiceImpl());

  // Un-register internet connectivity provider from FMI core
  // then register our custom provider.
  // Repositories
  // Services
  // serviceLocator.registerSingleton<ProfileService>(ProfileServiceImpl());
  serviceLocator
      .registerSingleton<NotificationService>(NotificationServiceImpl());
  serviceLocator.registerSingleton<BookingService>(BookingServiceImpl());
  serviceLocator.registerSingleton<NavigationService>(NavigationServiceImpl());
}
