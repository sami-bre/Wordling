import 'package:flutter/material.dart';
import 'package:wordling/models/card.dart' as model;
import 'package:wordling/util/dbhelper.dart';

class AddCardDialog {
  TextEditingController txtFront = TextEditingController();
  TextEditingController txtBack = TextEditingController();
  DbHelper helper = DbHelper();

  AlertDialog showDialog(
    BuildContext context, {
    required model.Card card,
    required bool isNew,
  }) {
    if (!isNew) {
      txtFront.text = card.front;
      txtBack.text = card.back;
    } else {
      // the the next available id for the card.
      helper.getNextCreatedCardId().then((value) {
        card.id = value;
      });
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: true,
      title: Text(isNew ? 'New card' : 'Edit card'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 3,
              maxLines: 6,
              controller: txtFront,
              decoration: const InputDecoration(label: Text('Front')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 3,
              maxLines: 6,
              controller: txtBack,
              decoration: const InputDecoration(label: Text('Back')),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            card.front = txtFront.text;
            card.back = txtBack.text;
            helper.insertCard(card);
            Navigator.pop(context, card);
          },
          child: const Text('Save'),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
