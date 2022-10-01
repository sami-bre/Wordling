import 'package:flutter/material.dart';
import 'package:wordling/models/word.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final Function()? onDoubleTap;

  const WordCard({
    required this.word,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: Material(
          elevation: 3.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          child: Container(
              width: 280,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 217, 227, 231),
                borderRadius: BorderRadius.all(
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
                    Text(
                      'word',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      word.term,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'definition',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      word.definition,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'example',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      word.example,
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
