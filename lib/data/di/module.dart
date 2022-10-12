import 'package:injectable/injectable.dart';
import 'package:get_storage/get_storage.dart';

@module
abstract class AppModule {
  @singleton
  @preResolve
  Future<GetStorage> get getStorageInstance async {
    await GetStorage.init();
    return GetStorage();
  }
}
