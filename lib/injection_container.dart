import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:reso_coder_clean_code_tdd/core/network/network_info.dart';
import 'package:reso_coder_clean_code_tdd/core/util/input_converter.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //* Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getRandomNumberTrivia: sl(),
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //* Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //* External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
