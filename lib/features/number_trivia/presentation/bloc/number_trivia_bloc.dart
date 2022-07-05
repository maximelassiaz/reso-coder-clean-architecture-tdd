import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailure =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTrivia;
  final GetRandomNumberTriviaUseCase getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getRandomNumberTrivia,
    required this.getConcreteNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumberEvent>(_onGetTriviaForConcreteNumberEvent);
  }

  _onGetTriviaForConcreteNumberEvent(
      GetTriviaForConcreteNumberEvent event, Emitter<NumberTriviaState> emit) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (failure) => emit(const Error(message: invalidInputFailure)),
      (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        print('NumberTriviaBloc: $failureOrTrivia');
        failureOrTrivia.fold(
          (failure) => throw UnimplementedError(),
          (trivia) => emit(Loaded(trivia: trivia)),
        );
      },
    );
  }
}
