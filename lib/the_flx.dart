import 'dart:math';

class Util {
  static dictSet(Map<int, List<Result>> result, int? key, List<Result> val) {
    if (key == null) return;

    if (!result.containsKey(key)) {
      result[key] = val;
    }

    result[key] = val;
  }

  static List<T>? dictGet<T>(Map<int, List<T>> dict, int? key) {
    if (key == null) return null;

    if (!dict.containsKey(key)) return null;

    return dict[key];
  }

  static void dictInsert(Map<int, List<int>> result, int? key, int val) {
    if (key == null) return;

    if (!result.containsKey(key)) result[key] = [];

    List<int>? lst = result[key];

    if (lst == null) return;

    lst.insert(0, val);
  }
}

class Result {
  List<int> indices = [];
  int score;
  int tail;

  Result(this.indices, this.score, this.tail);
}

class Flx {
  /* Variables */

  static const int int32Min = -2147483648; /* -(2^31) */

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

  /// Convert [ch] to lowercase char.
  static int? toLowerCase(int? ch) {
    if (ch == null) return null;
    return String.fromCharCodes([ch]).toLowerCase().codeUnitAt(0);
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

  /// Return hash-table for string where keys are characters.
  /// Value is a sorted list of indexes for character occurrences.
  static Map<int, List<int>>? getHashForString(String? str) {
    if (str == null) return null;

    Map<int, List<int>> result = {};

    int strLen = str.length;
    int index = strLen - 1;
    int? ch;
    int? downCh;

    while (0 <= index) {
      ch = toChar(str[index]);

      if (capital(ch)) {
        Util.dictInsert(result, ch, index);

        downCh = toLowerCase(ch);
      } else {
        downCh = ch;
      }

      Util.dictInsert(result, downCh, index);

      --index;
    }

    return result;
  }

  /// Generate the heatmap vector of string.
  static List<int>? getHeatmapStr(String? str, int? groupSeparator) {
    if (str == null) return null;

    List<int> scores = [];
    int strLen = str.length;
    int strLastIndex = strLen - 1;

    for (int i = 0; i < strLen; ++i) {
      scores.add(defaultScore);
    }

    int penaltyLead = toChar('.');

    List<int> inner = [-1, 0];
    List<List<int>> groupAlist = [inner];

    // final char bonus
    scores[strLastIndex] += 1;

    // Establish baseline mapping
    int? lastCh;
    int groupWordCount = 0;

    for (int index = 0; index < str.length; ++index) {
      int ch = toChar(str[index]);

      // before we find any words, all separaters are
      // considered words of length 1.  This is so "foo/__ab"
      // gets penalized compared to "foo/ab".
      int? effectiveLastChar = ((groupWordCount == 0) ? null : lastCh);

      if (boundary(effectiveLastChar, ch)) {
        groupAlist[0].insert(2, index);
      }

      if (!word(lastCh) && word(ch)) {
        ++groupWordCount;
      }

      // ++++ -45 penalize extension
      if (lastCh != null && lastCh == penaltyLead) {
        scores[index] += -45;
      }

      if (groupSeparator != null && groupSeparator == ch) {
        groupAlist[0][1] = groupWordCount;
        groupWordCount = 0;
        groupAlist.insert(0, [index, groupWordCount]);
      }

      if (index == strLastIndex) {
        groupAlist[0][1] = groupWordCount;
      } else {
        lastCh = ch;
      }
    }

    int groupCount = groupAlist.length;
    int separatorCount = groupCount - 1;

    // ++++ slash group-count penalty
    if (separatorCount != 0) {
      incVec(scores, groupCount * -2, null, null);
    }

    int index2 = separatorCount;
    int? lastGroupLimit;
    bool basepathFound = false;

    // score each group further
    for (List<int> group in groupAlist) {
      int groupStart = group[0];
      int wordCount = group[1];
      // this is the number of effective word groups
      int wordsLength = group.length - 2;
      bool basepathP = false;

      if (wordsLength != 0 && !basepathFound) {
        basepathFound = true;
        basepathP = true;
      }

      int num;
      if (basepathP) {
        // ++++ basepath separator-count boosts
        int boosts = 0;
        if (separatorCount > 1) boosts = separatorCount - 1;
        // ++++ basepath word count penalty
        int penalty = -wordCount;
        num = 35 + boosts + penalty;
      }
      // ++++ non-basepath penalties
      else {
        if (index2 == 0) {
          num = -3;
        } else {
          num = -5 + (index2 - 1);
        }
      }

      incVec(scores, num, groupStart + 1, lastGroupLimit);

      List<int> cddrGroup = List.from(group); // clone it
      cddrGroup.removeAt(0);
      cddrGroup.removeAt(0);

      int wordIndex = wordsLength - 1;
      int lastWord = (lastGroupLimit != null) ? lastGroupLimit : strLen;

      for (int word in cddrGroup) {
        // ++++  beg word bonus AND
        scores[word] += 85;

        int index3 = word;
        int charI = 0;

        while (index3 < lastWord) {
          scores[index3] += (-3 * wordIndex) - // ++++ word order penalty
              charI; // ++++ char order penalty
          ++charI;

          ++index3;
        }

        lastWord = word;
        --wordIndex;
      }

      lastGroupLimit = groupStart + 1;
      --index2;
    }

    return scores;
  }

  /// Return sublist bigger than [val] from sorted [sorted-list].
  static List<int>? biggerSublist(List<int>? sortedList, int? val) {
    if (sortedList == null) return null;

    List<int> result = [];

    if (val != null) {
      for (var sub in sortedList) {
        if (sub > val) {
          result.add(sub);
        }
      }
    } else {
      for (var sub in sortedList) {
        result.add(sub);
      }
    }

    return result;
  }

  /// Recursively compute the best match for a string, passed as STR-INFO and
  /// HEATMAP, according to QUERY.
  static void findBestMatch(
      List<Result> imatch,
      Map<int, List<int>> strInfo,
      List<int> heatmap,
      int? greaterThan,
      String query,
      int queryLength,
      int qIndex,
      Map<int, List<Result>> matchCache) {
    int? greaterNum = (greaterThan != null) ? greaterThan : 0;
    int? hashKey = qIndex + (greaterNum * queryLength);
    List<Result>? hashValue = Util.dictGet(matchCache, hashKey);

    if (hashValue != null) {
      // Process matchCache here
      imatch.clear();
      for (var val in hashValue) {
        imatch.add(val);
      }
    } else {
      int uchar = toChar(query[qIndex]);
      List<int>? sortedList = Util.dictGet(strInfo, uchar);
      List<int>? indexes = biggerSublist(sortedList, greaterThan);
      if (indexes == null) {
        return;
      }
      int tempScore;
      int bestScore = int32Min;

      if (qIndex >= queryLength - 1) {
        // At the tail end of the recursion, simply generate all possible
        // matches with their scores and return the list to parent.
        for (int index in indexes) {
          List<int> indices = [];
          indices.add(index);
          imatch.add(Result(indices, heatmap[index], 0));
        }
      } else {
        for (int index in indexes) {
          List<Result> elemGroup = [];
          findBestMatch(elemGroup, Map.from(strInfo), List.from(heatmap), index,
              query, queryLength, qIndex + 1, matchCache);

          for (Result elem in elemGroup) {
            int caar = elem.indices[0];
            int cadr = elem.score;
            int cddr = elem.tail;

            if ((caar - 1) == index) {
              tempScore = cadr +
                  heatmap[index] +
                  (min(cddr, 3) * 15) + // boost contiguous matches
                  60;
            } else {
              tempScore = cadr + heatmap[index];
            }

            // We only care about the optimal match, so only forward the match
            // with the best score to parent
            if (tempScore > bestScore) {
              bestScore = tempScore;

              imatch.clear();
              List<int> indices = List.from(elem.indices);
              indices.insert(0, index);
              int tail = 0;
              if ((caar - 1) == index) tail = cddr + 1;
              imatch.add(Result(indices, tempScore, tail));
            }
          }
        }
      }

      // Calls are cached to avoid exponential time complexity
      Util.dictSet(matchCache, hashKey, List.from(imatch));
    }
  }

  /// Return best score matching [query] against [str].
  static Result? score(String? str, String? query) {
    if (str == null || query == null) return null;
    if (str == '' || query == '') return null;

    Map<int, List<int>>? strInfo = getHashForString(str);
    if (strInfo == null) return null;

    List<int>? heatmap = getHeatmapStr(str, null);
    if (heatmap == null) return null;

    int queryLength = query.length;
    bool fullMatchBoost = (1 < queryLength) && (queryLength < 5);
    Map<int, List<Result>> matchCache = {};
    List<Result> optimalMatch = [];

    findBestMatch(optimalMatch, strInfo, heatmap, null, query, queryLength, 0,
        matchCache);

    if (optimalMatch.isEmpty) return null;

    Result result1 = optimalMatch[0];
    int caar = result1.indices.length;

    if (fullMatchBoost && caar == str.length) {
      result1.score += 10000;
    }

    return result1;
  }
}
