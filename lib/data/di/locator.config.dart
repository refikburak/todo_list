// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../repositories/get_storage_repository.dart' as _i5;
import '../repositories/note_repository_interface.dart' as _i4;
import 'module.dart' as _i6;

const String _prod = 'prod';
const String _dev = 'dev';
const String _test = 'test';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  await gh.singletonAsync<_i3.GetStorage>(
    () => appModule.getStorageInstance,
    preResolve: true,
  );
  gh.lazySingleton<_i4.INoteRepository>(
    () => _i5.NoteRepositoryImpl(get<_i3.GetStorage>()),
    registerFor: {
      _prod,
      _dev,
    },
  );
  gh.lazySingleton<_i4.INoteRepository>(
    () => _i5.TestNoteRepositoryImpl(),
    registerFor: {_test},
  );
  return get;
}

class _$AppModule extends _i6.AppModule {}
