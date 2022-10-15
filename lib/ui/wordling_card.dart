import 'package:flutter/material.dart';
import 'package:wordling/models/card.dart' as model;
import '../util/dbhelper.dart';
import 'package:get/get.dart';

class WordlingCard extends StatefulWidget {
  final model.Card card;
  late final bool isFront; // if isFront, the card only shows the front text.
  final bool isIdle; // if idle, the card won't respond to a double tap
  final Function(bool isBeingSaved)?
      onSerialize; // a function to do sth in addition to saving/deleting upon double click.

  WordlingCard(
    this.card, {
    this.isFront = false,
    this.isIdle = false,
    this.onSerialize,
    Key? key,
  }) : super(key: key);

  @override
  WordlingCardState createState() => WordlingCardState();
}

class WordlingCardState extends State<WordlingCard> {
  DbHelper helper = DbHelper();
  bool isSaved = false;

  WordlingCardState();

  @override
  void initState() {
    helper.isSaved(widget.card).then((value) {
      setState(() {
        isSaved = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set the correct collors. these colors are theme independent (unlike the other colors in the app)
    Color savedColor;
    Color unsavedColor;
    bool isDark = Get.isDarkMode;
    if (!isDark) {
      savedColor = const Color.fromARGB(255, 142, 183, 255);
      unsavedColor = const Color.fromARGB(255, 217, 227, 231);
    } else {
      savedColor = const Color.fromARGB(255, 25, 67, 95);
      unsavedColor = const Color.fromARGB(255, 70, 70, 70);
    }
    // the style of the front text depends on whether this card is a front card
    TextStyle frontTextStyle;
    if (widget.isFront) {
      frontTextStyle = TextStyle(fontSize: 30);
    } else {
      frontTextStyle = Theme.of(context).textTheme.headline6!;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onDoubleTap: widget.isIdle
            ? null
            : () {
                // act upon double tap only if the card is not idle.
                if (!isSaved) {
                  // the card is not saved so save it.
                  helper.insertCard(widget.card);
                  setState(() {
                    isSaved = true;
                  });
                } else {
                  // the card is saved so delete it.
                  helper.deleteCard(widget.card);
                  setState(() {
                    isSaved = false;
                  });
                }
                // if we are given the onSerialize function, we call it
                // here after saving/deleting the card from the database.
                if (widget.onSerialize != null) widget.onSerialize!(isSaved);
              },
        child: Material(
          elevation: 3.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          child: Container(
              // the width of a card should be .8 * the screen width.
              width: MediaQuery.of(context).size.shortestSide * 0.8,
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
                      widget.card.front,
                      style: frontTextStyle,
                      textAlign: widget.isFront ? TextAlign.center : null,
                    ),
                    if (!widget.isFront)
                      const SizedBox(
                        height: 36.0,
                      ),
                    if (widget.card.back != '' && !widget.isFront)
                      Text(
                        widget.card.back,
                        textScaleFactor: 1.1,
                      ),
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
