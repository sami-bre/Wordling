import 'package:flutter/material.dart';
import 'package:wordling/models/definition.dart';
import 'package:wordling/util/dbhelper.dart';

class AddDefinitionDialog {
  TextEditingController txtWord = TextEditingController();
  TextEditingController txtDefinition = TextEditingController();
  TextEditingController txtExample = TextEditingController();
  DbHelper helper = DbHelper();

  AlertDialog showDialog(
    BuildContext context, {
    required Definition defn,
    required bool isNew,
  }) {
    if (!isNew) {
      txtWord.text = defn.word;
      txtDefinition.text = defn.definition;
      txtExample.text = defn.example;
    } else {
      // the the next available id for the definition.
      helper.getNextCreatedDefinitionId().then((value) {
        defn.id = value;
      });
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: true,
      title: Text(isNew ? 'New definition' : 'Edit definition'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: txtWord,
              decoration: const InputDecoration(label: Text('Word')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 3,
              maxLines: 6,
              controller: txtDefinition,
              decoration: const InputDecoration(label: Text('Definition')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 2,
              maxLines: 4,
              controller: txtExample,
              decoration: const InputDecoration(label: Text('Example')),
            ),
          )
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
            defn.word = txtWord.text;
            defn.definition = txtDefinition.text;
            defn.example = txtExample.text;
            helper.insertDefinition(defn);
            Navigator.pop(context, defn);
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
