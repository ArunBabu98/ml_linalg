import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Float32Vector', () {
    test('should find Euclidean distance (from vector to the same vector)', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);
      expect(distance, equals(0.0),
          reason: 'Wrong vector distance calculation');
    });

    test('should find euclidean distance', () {
      final vector1 = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.euclidean),
          equals(10.88577052853862));
    });

    test('should find manhattan distance', () {
      final vector1 = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.manhattan),
          equals(20.0));
    });

    test('should find cosine distance (the same vectors)', () {
      final vector1 = Vector.fromList([1.0, 0.0]);
      final vector2 = Vector.fromList([1.0, 0.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          equals(0.0));
    });

    test('should find cosine distance (different vectors)', () {
      final vector1 = Vector.fromList([4.0, 3.0]);
      final vector2 = Vector.fromList([2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(0.1055, 1e-4));
    });

    test('should find cosine distance (different vectors with negative '
        'elements)', () {
      final vector1 = Vector.fromList([4.0, -3.0]);
      final vector2 = Vector.fromList([-2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(1.8944, 1e-4));
    });

    test('should find cosine distance (one of two vectors is zero-vector)', () {
      final vector1 = Vector.fromList([0.0, 0.0]);
      final vector2 = Vector.fromList([-2.0, 4.0]);
      expect(() => vector1.distanceTo(vector2, distance: Distance.cosine),
          throwsException);
    });

    test('should find vector norm', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.euclidean), equals(closeTo(7.41, 1e-2)));
      expect(vector.norm(Norm.manhattan), equals(15.0));
    });

    test('should normalize itself (eucleadean norm)', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.normalize(Norm.euclidean);
      final expected = [0.134, 0.269, 0.404, 0.539, 0.674];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.euclidean), closeTo(1.0, 1e-3));
    });

    test('should normalize itself (Manhattan norm)', () {
      final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
      final actual = vector.normalize(Norm.manhattan);
      final expected = [1 / 15, -2 / 15, 3 / 15, -4 / 15, 5 / 15];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.manhattan), closeTo(1.0, 1e-3));
    });

    test('should rescale its every element into range [0...1]', () {
      final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
      final actual = vector.rescale(); // min = -4, diff = 9
      final expected = [5 / 9, 2 / 9, 7 / 9, 0.0, 1.0, 4 / 9];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expected.forEach((element) => expect(element, inInclusiveRange(0, 1)));
    });

    test('should find vector elements sum', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('should find vector elements absolute value', () {
      final vector = Vector.fromList([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('should create a vector using elements on specific inidces from '
        'given list', () {
      final vector = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.sample([1, 1, 0, 3]);
      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.sample([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = Vector.fromList([
        10.0,
        3.0,
        4.0,
        0.0,
        7.0,
        4.0,
        12.0,
        3.0,
        12.0,
        9.0,
        0.0,
        12.0,
        10.0,
        3.0
      ]);
      final unique = vector.unique();
      expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
    });
  });
}
