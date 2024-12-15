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
}
