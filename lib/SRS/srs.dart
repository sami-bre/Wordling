/* This is the SM-2 spaced repitition algorithm from SuperMemo.
See https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
more reference can be found here:
https://www.freshcardsapp.com/srs/simulator/
https://www.freshcardsapp.com/srs/write-your-own-algorithm.html
*/

import 'dart:math';

class SRSState {
  int n; // this is the number of successful recalls in a row.
  double
      eFactor; // this is the measure of the easiness to recall a card (from 1.3 to 2.5)
  double
      interval; // this is the amount of days that would pass before the next study.

  SRSState({
    required this.n,
    required this.eFactor,
    required this.interval,
  });
}

class Evaluation {
  int score; // this is the easy of recall for one session (from 1 - 5) 1 and 2 are considered failure.
  double
      lateness; // this is the amount of days passed between the scheduled and actual study times.

  Evaluation({
    required this.score,
    required this.lateness,
  });
}

class SRS {
  // the Spaced Repitition System class
// the spaced repitition system function.
  static SRSState srsFunction(SRSState? previousState, Evaluation evaluation) {
    // this function takes the state from a previous study and evaluation for the current study
    // and returns the state for the cuurent study.
    // if this is the first time a card is examined, it wouldn't have a previousState. so we make one.
    previousState ??= SRSState(n: 0, eFactor: 2.2, interval: 0);
    // now let's make the state
    int n;
    double eFactor, interval;

    eFactor = max(
        1.3,
        previousState.eFactor +
            (0.1 -
                (5 - evaluation.score) *
                    (0.08 + (5 - evaluation.score) * 0.02)));

    if (evaluation.score < 3) {
      // this is failure.
      n = 0;
      interval = 1;
    } else {
      n = previousState.n + 1;

      if (previousState.n == 0) {
        interval = 1;
      } else if (previousState.n == 1) {
        interval = 4;
      } else {
        interval = (previousState.interval * eFactor).ceilToDouble();
      }
    }
    // finally, build and return the new state
    return SRSState(n: n, eFactor: eFactor, interval: interval);
  }
}
