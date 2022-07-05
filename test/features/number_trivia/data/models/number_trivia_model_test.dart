import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_coder_clean_code_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJSON',
    () {
      test(
        'should return a valid model when the JSON is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should return a valid model when the JSON is regarded as a double',
        () {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia_double.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () {
          // act
          final result = tNumberTriviaModel.toJson();
          // assert
          final expectedMap = {
            "text": "Test Text",
            "number": 1,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
