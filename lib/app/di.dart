import 'package:dio/dio.dart';
import 'package:ecommerce_mvvm/app/app_preferences.dart';
import 'package:ecommerce_mvvm/data/data_source/local_data_source.dart';
import 'package:ecommerce_mvvm/data/data_source/remote_data_source.dart';
import 'package:ecommerce_mvvm/data/network/app_api.dart';
import 'package:ecommerce_mvvm/data/network/dio_factory.dart';
import 'package:ecommerce_mvvm/data/network/network_info.dart';
import 'package:ecommerce_mvvm/data/repository/repository_impl.dart';
import 'package:ecommerce_mvvm/domain/repository/repository.dart';
import 'package:ecommerce_mvvm/domain/usecase/login_usecase.dart';
import 'package:ecommerce_mvvm/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:ecommerce_mvvm/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecase/home_usecase.dart';
import '../domain/usecase/register_usercase.dart';
import '../presentation/main/pages/home/viewmodel/home_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() async {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initRegisterModule() async {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() async {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}
