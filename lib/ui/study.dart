import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordling/ui/definition_card.dart';
import 'package:wordling/ui/random_definition_display.dart';
import 'package:wordling/util/dbhelper.dart';

import '../models/definition.dart';

class Study extends StatefulWidget {
  const Study({Key? key}) : super(key: key);

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> {
  DbHelper helper = DbHelper();
  List<Definition> defnsToStudy = [];

  @override
  void initState() {
    getDefnsToStudy();
    super.initState();
  }

  void getDefnsToStudy() async {
    defnsToStudy = await helper.getAllDefinitions();
    setState(() {
      defnsToStudy = defnsToStudy;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sliderHeight;
    MediaQuery.of(context).orientation == Orientation.portrait
        ? sliderHeight = 280
        : sliderHeight = 220;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: defnsToStudy.isEmpty
                      ? Container()
                      : FlipCard(
                          speed: 200,
                          fill: Fill.fillFront,
                          front: DefinitionCard(defnsToStudy[0],
                              isIdle: true, isFront: true),
                          back: DefinitionCard(
                            defnsToStudy[0],
                            isIdle: true,
                          ),
                        ),
                ),
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
                      value: 0,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    children: const [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Diff',
                          textScaleFactor: 1.2,
                        ),
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
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'previous',
            onPressed: () {},
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 30),
          FloatingActionButton(
            heroTag: 'forward',
            onPressed: () {},
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
