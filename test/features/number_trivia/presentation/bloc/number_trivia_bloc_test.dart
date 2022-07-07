import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reso_coder_clean_code_tdd/core/error/failures.dart';
import 'package:reso_coder_clean_code_tdd/core/util/input_converter.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTrivia extends Mock
    implements GetRandomNumberTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(
    () {
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();
      bloc = NumberTriviaBloc(
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          inputConverter: mockInputConverter);
    },
  );

  test(
    'initialState should be Empty',
    () async {
      // assert
      expect(bloc.state, equals(Empty()));
    },
  );

  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

      test(
        'should get data for the random use case',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          bloc.add(GetTriviaForRandomNumberEvent());
          await untilCalled(() => mockGetRandomNumberTrivia(NoParams()));
          // assert
          verify(() => mockGetRandomNumberTrivia(NoParams()));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Loaded(trivia: tNumberTrivia),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumberEvent());
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Error(message: serverFailureMessage),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumberEvent());
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Error(message: cacheFailureMessage),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumberEvent());
        },
      );
    },
  );

  group(
    'GetTriviaForRandomNumber',
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(any()));
          // assert
          verify(
              () => mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        'should emit [error] when the input is invalid',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));
          // assert
          final expected = [const Error(message: invalidInputFailure)];
          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        },
      );

      test(
        'should get data for the concrete use case',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          await untilCalled(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
          // assert
          verify(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Loaded(trivia: tNumberTrivia),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Error(message: serverFailureMessage),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(
                  const Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            const Error(message: cacheFailureMessage),
          ];

          expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        },
      );
    },
  );
}
