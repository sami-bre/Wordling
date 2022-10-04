import 'package:flutter/material.dart';
import 'package:wordling/models/definition.dart';
import '../util/dbhelper.dart';

class DefinitionCard extends StatefulWidget {
  final Definition definition;

  // ignore: use_key_in_widget_constructors
  const DefinitionCard(this.definition);

  @override
  _DefinitionCardState createState() =>
      // ignore: no_logic_in_create_state
      _DefinitionCardState(definition: definition);
}

class _DefinitionCardState extends State<DefinitionCard> {
  DbHelper helper = DbHelper();
  final Definition definition;
  bool isSaved = false;
  final Color savedColor = const Color.fromARGB(255, 142, 183, 255);
  final Color unsavedColor = const Color.fromARGB(255, 217, 227, 231);

  _DefinitionCardState({
    required this.definition,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onDoubleTap: () {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (definition.word != '')
                      Text(
                        'word',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (definition.word != '')
                      Text(
                        definition.word,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    if (definition.definition != '')
                      const SizedBox(
                        height: 30.0,
                      ),
                    if (definition.definition != '')
                      Text(
                        'definition',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (definition.definition != '')
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (definition.definition != '')
                      Text(
                        definition.definition,
                        textScaleFactor: 1.1,
                      ),
                    if (definition.example != '')
                      const SizedBox(
                        height: 30.0,
                      ),
                    if (definition.example != '')
                      Text(
                        'example',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (definition.example != '')
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (definition.example != '')
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
}
