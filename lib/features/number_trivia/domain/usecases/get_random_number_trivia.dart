import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:reso_coder_clean_code_tdd/core/error/failures.dart';
import 'package:reso_coder_clean_code_tdd/core/usecases/usecase.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
