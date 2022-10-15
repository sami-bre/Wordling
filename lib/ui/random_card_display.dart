import 'package:flutter/material.dart';
import 'package:wordling/ui/wordling_card.dart';
import 'package:wordling/util/dbhelper.dart';
import '../models/card.dart' as model;

class RandomCardDisplay extends StatefulWidget {
  const RandomCardDisplay({Key? key}) : super(key: key);

  @override
  State<RandomCardDisplay> createState() => RandomCardDisplayState();
}

class RandomCardDisplayState extends State<RandomCardDisplay> {
  final DbHelper helper = DbHelper();
  model.Card? card;

  void showCard() async {
    model.Card starter = model.Card(
        id: 0,
        front: 'starter',
        back:
            'Food items served before the main courses of a meal (prior to an entrée). Synonymous with an appetizer',
        origin: model.Origin.created);
    card = await helper.getRandomCard() ?? starter;
    setState(() {
      card = card;
    });
  }

  @override
  void initState() {
    showCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (card == null)
        ? Container()
        : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: WordlingCard(card!),
              ),
            ),
          );
  }
}
