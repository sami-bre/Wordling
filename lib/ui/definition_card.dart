import 'package:flutter/material.dart';
import 'package:wordling/models/definition.dart';
import '../util/dbhelper.dart';

class DefinitionCard extends StatefulWidget {
  final Definition definition;
  bool isFront; // if isFront, the card only shows the word.
  final bool isIdle; // if idle, the card won't respond to a double tap
  final Function(bool isBeingSaved)?
      onSerialize; // a function to do sth in addition to saving/deleting uopn double click.

  DefinitionCard(
    this.definition, {
    this.isFront = false,
    this.isIdle = false,
    this.onSerialize,
    Key? key,
  }) : super(key: key);

  @override
  DefinitionCardState createState() => DefinitionCardState();
}

class DefinitionCardState extends State<DefinitionCard> {
  DbHelper helper = DbHelper();
  bool isSaved = false;
  final Color savedColor = const Color.fromARGB(255, 142, 183, 255);
  final Color unsavedColor = const Color.fromARGB(255, 217, 227, 231);

  DefinitionCardState();

  @override
  void initState() {
    helper.isSaved(widget.definition).then((value) {
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
    if (widget.isFront) {
      wordTextStyle = Theme.of(context).textTheme.displaySmall!;
      wordLabelStyle = Theme.of(context).textTheme.labelLarge!;
    } else {
      wordTextStyle = Theme.of(context).textTheme.headline6!;
      wordLabelStyle = Theme.of(context).textTheme.labelSmall!;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onDoubleTap: widget.isIdle
            ? null
            : () {
                // act upon double tap only if the card is not idle.
                if (!isSaved) {
                  // the word is not saved so save it.
                  helper.insertDefinition(widget.definition);
                  setState(() {
                    isSaved = true;
                  });
                } else {
                  // the word is saved so delete it.
                  helper.deleteDefinition(widget.definition);
                  setState(() {
                    isSaved = false;
                  });
                }
                // if we are given the onSerialize function, we call it
                // here after saving/deleting the definition from the database.
                if (widget.onSerialize != null) widget.onSerialize!(isSaved);
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
                      textAlign: widget.isFront ? TextAlign.center : null,
                    ),
                    Text(
                      widget.definition.word,
                      style: wordTextStyle,
                      textAlign: widget.isFront ? TextAlign.center : null,
                    ),
                    if (!widget.isFront)
                      const SizedBox(
                        height: 36.0,
                      ),
                    if (widget.definition.definition != '' && !widget.isFront)
                      Text(
                        'definition',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (widget.definition.definition != '' && !widget.isFront)
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (widget.definition.definition != '' && !widget.isFront)
                      Text(
                        widget.definition.definition,
                        textScaleFactor: 1.1,
                      ),
                    if (widget.definition.example != '' && !widget.isFront)
                      const SizedBox(
                        height: 30.0,
                      ),
                    if (widget.definition.example != '' && !widget.isFront)
                      Text(
                        'example',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (widget.definition.example != '' && !widget.isFront)
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (widget.definition.example != '' && !widget.isFront)
                      Text(
                        widget.definition.example,
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
      widget.isFront = !widget.isFront;
    });
  }
}
