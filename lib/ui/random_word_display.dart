import 'package:flutter/material.dart';
import 'package:wordling/ui/word_card.dart';
import 'package:wordling/util/dbhelper.dart';
import '../models/word.dart';

class RandomWordDisplay extends StatefulWidget {
  const RandomWordDisplay({Key? key}) : super(key: key);

  @override
  State<RandomWordDisplay> createState() => _RandomWordDisplayState();
}

class _RandomWordDisplayState extends State<RandomWordDisplay> {
  final DbHelper helper = DbHelper();
  Word? word;

  void showWord() async {
    Word starter = Word(
        term: 'starter',
        definition:
            'Food items served before the main courses of a meal (prior to an entrée). Synonymous with an appetizer',
        example: 'This menu has a ton of a starters!');
    word = await helper.getRandomWord() ?? starter;
    setState(() {
      word = word;
    });
  }

  @override
  void initState() {
    showWord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (word == null)
        ? Container()
        : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: WordCard(word: word!),
              ),
            ),
          );
  }
}