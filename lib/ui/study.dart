import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordling/ui/definition_card.dart';
import 'package:wordling/ui/helper_dialog.dart';
import 'package:wordling/util/dbhelper.dart';
import '../models/definition.dart';
import '../SRS/srs.dart';

const Map<int, String> comments = {
  1: 'very easy',
  2: 'easy',
  3: 'fine',
  4: "couldn't recall",
  5: 'totally forgot',
};

class Study extends StatefulWidget {
  const Study({Key? key}) : super(key: key);

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> {
  DbHelper helper = DbHelper();
  FlipCardController flipCardController = FlipCardController();
  List<Definition>? dueDefns;
  int currentDefnIndex = 0;
  double sliderValue = 0;

  @override
  void initState() {
    getDefnsToStudy();
    super.initState();
  }

  void getDefnsToStudy() async {
    dueDefns = await helper.getDueDefinitions();
    setState(() {
      dueDefns = dueDefns;
    });
  }

  void checkAndShowHelp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print('in check and display help');
    bool? studyHelp = prefs.getBool('studyHelp');
    print('studyHelp in prefs is : $studyHelp');
    if (studyHelp == null || studyHelp) {
      showDialog(
        context: context,
        builder: (context) => HelperDialog.buildStudyPageHelpDialog(context),
      );
      prefs.setBool('studyHelp', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // check and show help
    checkAndShowHelp(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Study'),
            const Expanded(flex: 4, child: SizedBox()),
            if (dueDefns != null && dueDefns!.length - currentDefnIndex > 0)
              Text('Left: ${dueDefns!.length - currentDefnIndex}'),
            const Expanded(flex: 1, child: SizedBox())
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),
      body: SafeArea(
        child: _buildMainDisplay(context),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'previous',
            onPressed: () {
              if (currentDefnIndex > 0) {
                // flip the card to front if it's facing back before changeing it.
                // because we don't want to reveal the back of the first card.
                if (!flipCardController.state!.isFront) {
                  flipCardController.toggleCard();
                  Future.delayed(const Duration(milliseconds: 250), () {
                    _previousCard();
                  });
                } else {
                  _previousCard();
                }
              }
            },
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 30),
          FloatingActionButton(
            heroTag: 'forward',
            onPressed: () {
              if (currentDefnIndex < dueDefns!.length - 1) {
                // again, check if the card is on its backk and flip it before changing it.
                if (!flipCardController.state!.isFront) {
                  flipCardController.toggleCard();
                  // we delay changing the card for 200 millis till the card flips back.
                  Future.delayed(const Duration(milliseconds: 250), () {
                    _nextCard();
                  });
                } else {
                  _nextCard();
                }
              }
            },
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  void _nextCard() {
    // takes us to the next card
    setState(() {
      currentDefnIndex += 1;
    });
  }

  void _previousCard() {
    //takes us to the previous card
    setState(() {
      currentDefnIndex -= 1;
    });
  }

  _buildMainDisplay(BuildContext context) {
    double sliderHeight;
    MediaQuery.of(context).orientation == Orientation.portrait
        ? sliderHeight = 280
        : sliderHeight = 200;
    if (dueDefns == null) {
      // the list of due cards hasn't loaded yet.
      return Container();
    } else if (dueDefns!.isEmpty) {
      // the list is loaded but is empity. there's no due card.
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_cards_due.png', width: 90),
            const Text(
              'No cards due',
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    } else {
      // there are some due cards loaded so show them.
      if (currentDefnIndex == dueDefns!.length) {
        // the cards are exhausted so show a congrats message and disable the
        // buttons and slider.
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/done_studying.png', width: 90),
              const Text(
                'Congrats! you\'re done for now',
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        );
      } else {
        // display the current card.
        return Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.shortestSide * 0.8,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FlipCard(
                          controller: flipCardController,
                          speed: 200,
                          front: DefinitionCard(dueDefns![currentDefnIndex],
                              isIdle: true, isFront: true),
                          back: DefinitionCard(
                            dueDefns![currentDefnIndex],
                            isIdle: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: sliderHeight,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      min: 0,
                      max: 5,
                      divisions: 5,
                      value: sliderValue,
                      label: (sliderValue != 0)
                          ? '${comments[sliderValue]}'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        // do the updating stuff
                        if (value > 0) {
                          helper.insertDefinition(
                            SRS.srsFunction(
                              dueDefns![currentDefnIndex],
                              6 - sliderValue.toInt(),
                            ),
                          );
                          // flip the card to front if it's facing back before changeing it.
                          // because we don't want to reveal the back of the first card.
                          if (!flipCardController.state!.isFront) {
                            flipCardController.toggleCard();
                            // it takes 200 millisecons for the car to flip back so
                            // delay changing the card for 200 milliseconds.
                            Future.delayed(const Duration(milliseconds: 250),
                                () {
                              setState(() {
                                _nextCard();
                                sliderValue = 0;
                              });
                            });
                          } else {
                            _nextCard();
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Column(
                    children: const [
                      Text(
                        'D',
                        textScaleFactor: 1.6,
                      ),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      }
    }
  }
}
