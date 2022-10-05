import 'package:flutter/material.dart';
import 'package:wordling/models/definition.dart';
import '../util/dbhelper.dart';

class DefinitionCard extends StatefulWidget {
  final Definition definition;
  final bool isFront; // if isFront, the card only shows the word.
  final bool isIdle; // if idle, the card won't respond to a double tap
  final Function(bool isBeingSaved)? onSerialize;

  const DefinitionCard(
    this.definition, {
    this.isFront = false,
    this.isIdle = false,
    this.onSerialize,
    Key? key,
  }) : super(key: key);

  @override
  DefinitionCardState createState() =>
      // ignore: no_logic_in_create_state
      DefinitionCardState(
          definition: definition,
          isFront: isFront,
          isIdle: isIdle,
          onSerialize: onSerialize);
}

class DefinitionCardState extends State<DefinitionCard> {
  DbHelper helper = DbHelper();
  final Definition definition;
  bool isFront;
  bool isIdle;
  final Function(bool)?
      onSerialize; // a function to do sth in addition to saving/deleting uopn double click.
  bool isSaved = false;
  final Color savedColor = const Color.fromARGB(255, 142, 183, 255);
  final Color unsavedColor = const Color.fromARGB(255, 217, 227, 231);

  DefinitionCardState({
    required this.definition,
    required this.isFront,
    required this.isIdle,
    this.onSerialize,
  });

  @override
  void initState() {
    helper.isSaved(definition).then((value) {
      setState(() {
        isSaved = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // the style of the word text depends on whether this is a front
    TextStyle wordTextStyle;
    TextStyle wordLabelStyle;
    if (isFront) {
      wordTextStyle = Theme.of(context).textTheme.displaySmall!;
      wordLabelStyle = Theme.of(context).textTheme.labelLarge!;
    } else {
      wordTextStyle = Theme.of(context).textTheme.headline6!;
      wordLabelStyle = Theme.of(context).textTheme.labelSmall!;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onDoubleTap: isIdle
            ? null
            : () {
                // act upon double tap only if the card is not idle.
                if (!isSaved) {
                  // the word is not saved so save it.
                  helper.insertDefinition(definition);
                  setState(() {
                    isSaved = true;
                  });
                } else {
                  // the word is saved so delete it.
                  helper.deleteDefinition(definition);
                  setState(() {
                    isSaved = false;
                  });
                }
                // if we are given the onSerialize function, we call it
                // here after saving/deleting the definition from the database.
                if (onSerialize != null) onSerialize!(isSaved);
              },
        child: Material(
          elevation: 3.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: isSaved ? savedColor : unsavedColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'word',
                      style: wordLabelStyle,
                      textAlign: isFront ? TextAlign.center : null,
                    ),
                    Text(
                      definition.word,
                      style: wordTextStyle,
                      textAlign: isFront ? TextAlign.center : null,
                    ),
                    if (definition.definition != '' && !isFront)
                      const SizedBox(
                        height: 30.0,
                      ),
                    if (definition.definition != '' && !isFront)
                      Text(
                        'definition',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (definition.definition != '' && !isFront)
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (definition.definition != '' && !isFront)
                      Text(
                        definition.definition,
                        textScaleFactor: 1.1,
                      ),
                    if (definition.example != '' && !isFront)
                      const SizedBox(
                        height: 30.0,
                      ),
                    if (definition.example != '' && !isFront)
                      Text(
                        'example',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (definition.example != '' && !isFront)
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (definition.example != '' && !isFront)
                      Text(
                        definition.example,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  toggleFront() {
    setState(() {
      isFront = !isFront;
    });
  }
}
