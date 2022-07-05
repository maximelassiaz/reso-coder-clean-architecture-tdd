import 'package:dartz/dartz.dart';
import 'package:reso_coder_clean_code_tdd/core/error/exceptions.dart';
import 'package:reso_coder_clean_code_tdd/core/error/failures.dart';
import 'package:reso_coder_clean_code_tdd/core/network/network_info.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandomTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandomTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
