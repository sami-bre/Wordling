import 'package:flutter/material.dart';
import 'package:wordling/models/definition.dart';
import 'package:wordling/util/dbhelper.dart';

class AddDefinitionDialog {
  TextEditingController txtFront = TextEditingController();
  TextEditingController txtBack = TextEditingController();
  DbHelper helper = DbHelper();

  AlertDialog showDialog(
    BuildContext context, {
    required Definition defn,
    required bool isNew,
  }) {
    if (!isNew) {
      txtFront.text = defn.front;
      txtBack.text = defn.back;
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
              controller: txtFront,
              decoration: const InputDecoration(label: Text('Word')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 3,
              maxLines: 6,
              controller: txtBack,
              decoration: const InputDecoration(label: Text('Definition')),
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
            defn.front = txtFront.text;
            defn.back = txtBack.text;
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
