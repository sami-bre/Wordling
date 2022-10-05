import 'package:flutter/material.dart';
import 'package:wordling/ui/add_definition_dialogue.dart';
import 'package:wordling/ui/definition_card.dart';

import '../models/definition.dart';
import '../util/dbhelper.dart';
import '../util/local_search_engine.dart';

class SavedDefinitions extends StatefulWidget {
  const SavedDefinitions({Key? key}) : super(key: key);

  @override
  State<SavedDefinitions> createState() => _SavedDefinitionsState();
}

class _SavedDefinitionsState extends State<SavedDefinitions> {
  DbHelper helper = DbHelper();
  List<Definition> definitions = [];
  bool searchBarDisplayed = false;

  @override
  void initState() {
    showAllDefinitions();
    super.initState();
  }

  void showAllDefinitions() async {
    definitions = await helper.getAllDefinitions();
    setState(() {
      definitions = definitions;
    });
  }

  void showSearchResults(String searchTerm) async {
    definitions = await LocalSearchEngine.localSearch(searchTerm);
    setState(() {
      definitions = definitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBarDisplayed
            ? TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  showSearchResults(value);
                },
                autofocus: true,
                style: const TextStyle(
                  color: Color(0xffCFD8DC),
                  fontSize: 22,
                ),
                decoration: const InputDecoration(
                  label: Text(
                    'Search my cards',
                    style: TextStyle(color: Color(0xffCFD8DC)),
                  ),
                ),
              )
            : const Text("My cards"),
        backgroundColor: const Color.fromARGB(255, 72, 72, 72),
        foregroundColor: const Color(0xffCFD8DC),
        centerTitle: true,
        actions: [
          if (!searchBarDisplayed)
            IconButton(
              onPressed: () {
                setState(() {
                  searchBarDisplayed = true;
                });
              },
              icon: const Icon(Icons.search),
            ),
          if (searchBarDisplayed)
            IconButton(
              onPressed: () {
                setState(() {
                  searchBarDisplayed = false;
                  // update the definitions list so it contains all of them
                  showAllDefinitions();
                });
              },
              icon: const Icon(
                Icons.cancel_outlined,
                size: 30,
              ),
            ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: definitions.length,
          itemBuilder: (context, index) {
            Definition current = definitions[index];
            return Dismissible(
              // I'm giving the dismissibles a unique key here.
              key: UniqueKey(),
              onDismissed: (direction) {
                helper.deleteDefinition(current).then((value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(_buildDeleteSnackBar(current));
                });
                setState(() {
                  definitions.remove(current);
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(current.word),
                    subtitle: Text(
                      current.definition,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Icon((current.origin == Origin.created)
                        ? Icons.storage_rounded
                        : Icons.cloud),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AddDefinitionDialog().showDialog(
                            context,
                            defn: Definition(
                              id: current.id,
                              word: current.word,
                              definition: current.definition,
                              example: current.example,
                              origin: current.origin,
                            ),
                            isNew: false,
                          ),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              definitions[index] = value;
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    onTap: () {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          scrollable: true,
                          backgroundColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(0),
                          content: DefinitionCard(
                            current,
                            onSerialize: (isBeingSaved) {
                              setState(() {
                                isBeingSaved
                                    ? definitions.add(current)
                                    : definitions.remove(current);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDefinitionDialog().showDialog(
              context,
              defn: Definition(
                  id: 0, // the id for the new defn will be set by the AddDefinitionDialog class.
                  // we can't do it here because we'll need to wait for an asynchronous gap to get the id.
                  word: '',
                  definition: '',
                  example: '',
                  origin: Origin.created),
              isNew: true,
            ),
          ).then((value) {
            if (value != null) {
              setState(() {
                definitions.add(value);
              });
            }
          });
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  SnackBar _buildDeleteSnackBar(Definition defn) {
    return SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${defn.word} deleted.'),
            TextButton.icon(
              onPressed: () {
                helper
                    .insertDefinition(defn)
                    .then((value) => showAllDefinitions());
              },
              label: const Text('Undo'),
              icon: const Icon(Icons.undo_rounded),
            )
          ],
        ),
      ),
    );
  }
}
