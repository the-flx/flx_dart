import 'package:flutter_test/flutter_test.dart';

import 'package:the_flx/the_flx.dart';

void main() {
  test('test capital', () {
    expect(Flx.capital(Flx.toChar('C')), true);
    expect(Flx.capital(Flx.toChar('c')), false);
    expect(Flx.capital(Flx.toChar(' ')), false);
  });

  test('test incVec', () {
    expect(Flx.incVec([1, 2, 3], 1, null, null), [2, 3, 4]);
    expect(Flx.incVec([1, 2, 3], 1, 1, null), [1, 3, 4]);
  });

  test('test getHashForString', () {
    expect(Flx.getHashForString("switch-to-buffer"), {
      114: [15],
      101: [14],
      102: [12, 13],
      117: [11],
      98: [10],
      45: [6, 9],
      111: [8],
      116: [3, 7],
      104: [5],
      99: [4],
      105: [2],
      119: [1],
      115: [0]
    });
  });

  test('test biggerSublist 1', () {
    expect(Flx.biggerSublist([1, 2, 3, 4], null), [1, 2, 3, 4]);
  });

  test('test biggerSublist 2', () {
    expect(Flx.biggerSublist([1, 2, 3, 4], 2), [3, 4]);
  });

  test('test score `switch-to-buffer`', () {
    Result? result = Flx.score("switch-to-buffer", "stb");
    expect(result?.indices, [0, 7, 10]);
    expect(result?.score, 237);
    expect(result?.tail, 0);
  });

  test('test score `TestSomeFunctionExterme`', () {
    Result? result = Flx.score("TestSomeFunctionExterme", "met");
    expect(result?.indices, [6, 16, 18]);
    expect(result?.score, 57);
    expect(result?.tail, 0);
  });

  test('test score `MetaX_Version`', () {
    Result? result = Flx.score("MetaX_Version", "met");
    expect(result?.indices, [0, 1, 2]);
    expect(result?.score, 211);
    expect(result?.tail, 2);
  });
}
