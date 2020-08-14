import 'package:get_it/get_it.dart';
import 'navigation_service_file.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
    locator.registerLazySingleton (() => NavigationService ()); 
}