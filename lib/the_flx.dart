class Result {
  int score = 0;
  List<int> indicies = [];
}

class Flx {
  /* Variables */

  static List<int> wordSeparators = [
    toChar(' '),
    toChar('-'),
    toChar('_'),
    toChar(':'),
    toChar('.'),
    toChar('/'),
    toChar('\\'),
  ];

  static const int defaultScore = -35;

  /* Functions */

  /// Convert [ch] string to character.
  static int toChar(String ch) {
    return ch.codeUnitAt(0);
  }

  /// Check if [ch] is a word character.
  ///
  /// Return true if [ch] is a word character.
  static bool word(int? ch) {
    if (ch == null) return false;
    return !wordSeparators.contains(ch);
  }

  /// Convert [ch] to uppercase char.
  static int? toUpperCase(int? ch) {
    if (ch == null) return null;
    return String.fromCharCodes([ch]).toUpperCase().codeUnitAt(0);
  }

  /// Check if [ch] is an uppercase character.
  ///
  /// Return true if the [ch] is a Capital character.
  static bool capital(int? ch) {
    if (ch == null) return false;
    return word(ch) && ch == toUpperCase(ch);
  }

  /// Check if [lastCh] is the end of a word and [ch] the start of the next.
  static bool boundary(int? lastCh, int? ch) {
    if (lastCh == null) return true;
    if (!capital(lastCh) && capital(ch)) return true;
    if (!word(lastCh) && word(ch)) return true;
    return false;
  }

  /// Increment each element in [vec] between [beg] and [end] by [inc].
  static List<int> incVec(List<int> vec, int? inc, int? beg, int? end) {
    int tInc = (inc == null) ? 1 : inc;
    int tBeg = (beg == null) ? 0 : beg;
    int tEnd = (end == null) ? vec.length : end;

    while (tBeg < tEnd) {
      vec[tBeg] += tInc;
      ++tBeg;
    }

    return vec;
  }

  /// Return best score matching [query] against [str].
  static Result? score(String str, String query) {
    return null;
  }
}
