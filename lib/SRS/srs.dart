/* This is the SM-2 spaced repitition algorithm from SuperMemo.
See https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
more reference can be found here:
https://www.freshcardsapp.com/srs/simulator/
https://www.freshcardsapp.com/srs/write-your-own-algorithm.html
*/

import 'dart:math';
import 'package:wordling/models/card.dart';

class SRS {
  // the Spaced Repitition System class
// the spaced repitition system function.
  static Card srsFunction(Card previousState, int score) {
    // this function takes a card with an old state from a previous study
    // and evaluationscore for the current study and returns the state for the
    // curent study.
    // if this is the first time a card is examined, the lastStudyTime (and eFactor and n and interval)
    // are null. so let's set default values.
    if (previousState.lastStudyTime == null) {
      previousState.n = 0;
      previousState.eFactor = 2.2;
      previousState.interval = 0;
    }
    // now let's make the card have a new state.
    int n;
    double eFactor, interval;

    eFactor = max(
        1.3,
        previousState.eFactor! +
            (0.1 - (5 - score) * (0.08 + (5 - score) * 0.02)));

    if (score < 3) {
      // this is failure.
      n = 0;
      interval = 1 * 86400000;
    } else {
      n = previousState.n! + 1;
      if (previousState.n == 0) {
        interval = 1 * 86400000;
      } else if (previousState.n == 1) {
        interval = 4 * 86400000;
      } else {
        interval = (previousState.intervalInDays! * eFactor).ceilToDouble();
        interval *= 86400000; // converting the interval back to milliseconds.
      }
    }
    // finally, set the new values into the card and return it.
    Card newState = previousState;
    newState.n = n;
    newState.eFactor = eFactor;
    newState.interval = interval;
    newState.lastStudyTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    return newState;
  }
}
