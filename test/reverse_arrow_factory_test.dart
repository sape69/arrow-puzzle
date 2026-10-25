import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/geometry/arrow_geometry.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_arrow_factory.dart';

void main() {
  const factory = ReverseArrowFactory();
  const geometry = ArrowGeometry();

  test(
    'factory should create an arrow inside the board',
    () {
      final arrow = factory.create(
        boardSize: 10,
        random: Random(1),
      );

      expect(
        geometry.isValidPath(
          arrow,
          10,
        ),
        isTrue,
      );
    },
  );

  test(
    'factory should create an arrow with valid length',
    () {
      final arrow = factory.create(
        boardSize: 10,
        random: Random(2),
      );

      expect(
        arrow.length,
        greaterThanOrEqualTo(1),
      );

      expect(
        arrow.length,
        lessThanOrEqualTo(3),
      );
    },
  );

  test(
    'factory should respect custom maximum length',
    () {
      final arrow = factory.create(
        boardSize: 10,
        random: Random(3),
        maxLength: 1,
      );

      expect(
        arrow.length,
        1,
      );
    },
  );

  test(
    'factory should support a small board',
    () {
      final arrow = factory.create(
        boardSize: 1,
        random: Random(4),
      );

      expect(
        arrow.row,
        0,
      );

      expect(
        arrow.column,
        0,
      );

      expect(
        arrow.length,
        1,
      );
    },
  );

  test(
    'factory should create different candidates from different seeds',
    () {
      final first = factory.create(
        boardSize: 10,
        random: Random(10),
      );

      final second = factory.create(
        boardSize: 10,
        random: Random(20),
      );

      final firstSignature = _signature(
        first,
      );

      final secondSignature = _signature(
        second,
      );

      expect(
        firstSignature,
        isNot(
          equals(secondSignature),
        ),
      );
    },
  );

  test(
    'factory should reject an invalid board size',
    () {
      expect(
        () => factory.create(
          boardSize: 0,
          random: Random(1),
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'factory should reject an invalid maximum length',
    () {
      expect(
        () => factory.create(
          boardSize: 10,
          random: Random(1),
          maxLength: 0,
        ),
        throwsArgumentError,
      );
    },
  );
}

String _signature(
  Arrow arrow,
) {
  return [
    arrow.row,
    arrow.column,
    arrow.direction.name,
    arrow.length,
  ].join(':');
}