import 'package:flutter/material.dart';
import 'package:wordling/ui/definition_card.dart';
import 'package:wordling/util/dbhelper.dart';
import '../models/definition.dart';

class RandomDefinitionDisplay extends StatefulWidget {
  const RandomDefinitionDisplay({Key? key}) : super(key: key);

  @override
  State<RandomDefinitionDisplay> createState() =>
      _RandomDefinitionDisplayState();
}

class _RandomDefinitionDisplayState extends State<RandomDefinitionDisplay> {
  final DbHelper helper = DbHelper();
  Definition? word;

  void showWord() async {
    Definition starter = Definition(
      id: 0,
        word: 'starter',
        definition:
            'Food items served before the main courses of a meal (prior to an entrée). Synonymous with an appetizer',
        example: 'This menu has a ton of a starters!');
    word = await helper.getRandomDefinition() ?? starter;
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
                child: DefinitionCard(word!),
              ),
            ),
          );
  }
}
