import 'dart:math';

import 'package:wordling/models/definition.dart';
import 'package:wordling/util/dbhelper.dart';

class LocalSearchEngine {
  static DbHelper dbHelper = DbHelper();

  static Future<List<Definition>> localSearch(String searchTerm) async {
    List<Definition> all = await dbHelper.getAllDefinitions();
    all.sort(((a, b) => compareSimilarity(a, b, searchTerm)));
    // this states how many entries will be in the search result.
    const int limitResults = 15;
    return (all.length) <= limitResults
        ? all
        : all.getRange(0, limitResults).toList();
  }

  static int compareSimilarity(
      Definition firstDefn, Definition secondDefn, String searchTerm) {
    int firstValue = 0;
    int secondValue = 0;
    // compering the searchTerm with the word of the definition.
    firstValue += 10 * lcss(firstDefn.word, searchTerm);
    secondValue += 10 * lcss(secondDefn.word, searchTerm);
    // finally return the comparison result
    return secondValue.compareTo(firstValue);
  }

  // the longest common substring function
  static int lcss(String strOne, String strTwo) {
    // if one of the strings is empty, we return 0;
    if (strOne.isEmpty || strTwo.isEmpty) return 0;
    // generating the matrix.
    List<List<int>> matrix = List.generate(strOne.length, (index) {
      return List.generate(strTwo.length, (index) => 0);
    });

    // the get element function. its a function in a method.
    int getElement(int i, int j) {
      if (i == -1 || j == -1) return 0;
      return matrix[i][j];
    }

    // now do the dynamic programming.
    for (int i = 0; i < strOne.length; i++) {
      for (int j = 0; j < strTwo.length; j++) {
        if (strOne[i] == strTwo[j]) {
          matrix[i][j] = getElement(i - 1, j - 1) + 1;
        } else {
          matrix[i][j] = max(getElement(i - 1, j), getElement(i, j - 1));
        }
      }
    }
    // finally, return the result
    return matrix[strOne.length - 1][strTwo.length - 1];
  }
}
