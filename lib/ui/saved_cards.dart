import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordling/ui/add_card_dialogue.dart';
import 'package:wordling/ui/wordling_card.dart';
import 'package:wordling/ui/helper_dialog.dart';
import '../models/card.dart' as model;
import '../util/dbhelper.dart';
import '../util/local_search_engine.dart';

class SavedCards extends StatefulWidget {
  const SavedCards({Key? key}) : super(key: key);

  @override
  State<SavedCards> createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  DbHelper helper = DbHelper();
  List<model.Card>? cards;
  bool searchBarDisplayed = false;

  @override
  void initState() {
    showAllCards();
    super.initState();
  }

  void showAllCards() async {
    cards = await helper.getAllCards();
    setState(() {
      cards = cards;
    });
  }

  void showSearchResults(String searchTerm) async {
    cards = await LocalSearchEngine.localSearch(searchTerm);
    setState(() {
      cards = cards;
    });
  }

  void checkAndShowHelp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? myCardsHelp = prefs.getBool('myCardsHelp');
    if (myCardsHelp == null || myCardsHelp) {
      showDialog(
        context: context,
        builder: (context) => HelperDialog.buildMyCardsPageHelpDialog(context),
      );
      prefs.setBool('myCardsHelp', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // check and display help for the page
    checkAndShowHelp(context);
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
                  // update the cards list so it contains all of them
                  showAllCards();
                });
              },
              icon: const Icon(
                Icons.cancel_outlined,
                size: 30,
              ),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (cards == null) {
            return Container();
          } else if (cards!.isEmpty) {
            return _buildNoCardsView();
          } else {
            return _buildListView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCardDialog().showDialog(
              context,
              card: model.Card(
                  id: 0, // the id for the new card will be set by the AddCardDialog class.
                  // we can't do it here because we'll need to wait for an asynchronous gap to get the id.
                  front: '',
                  back: '',
                  origin: model.Origin.created),
              isNew: true,
            ),
          ).then((value) {
            if (value != null) {
              setState(() {
                // I'm assuming the add button won't be pressed in the very short interval
                // when the cards list is null.
                cards!.add(value);
              });
            }
          });
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildListView() {
    return Center(
      child: ListView.builder(
        itemCount: cards!.length,
        itemBuilder: (context, index) {
          model.Card current = cards![index];
          return Dismissible(
            // I'm giving the dismissibles a unique key here.
            key: UniqueKey(),
            onDismissed: (direction) {
              helper.deleteCard(current).then((value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(_buildDeleteSnackBar(current));
              });
              setState(() {
                cards!.remove(current);
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(current.front),
                  subtitle: Text(
                    current.back,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Icon((current.origin == model.Origin.created)
                      ? Icons.storage_rounded
                      : Icons.cloud),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddCardDialog().showDialog(
                          context,
                          card: model.Card(
                            id: current.id,
                            front: current.front,
                            back: current.back,
                            origin: current.origin,
                            n: current.n,
                            eFactor: current.eFactor,
                            interval: current.interval,
                            lastStudyTime: current.lastStudyTime,
                          ),
                          isNew: false,
                        ),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            cards![index] = value;
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
                        // this transparent color is theme independent.
                        backgroundColor: Colors.transparent,
                        contentPadding: const EdgeInsets.all(0),
                        content: WordlingCard(
                          current,
                          onSerialize: (isBeingSaved) {
                            setState(() {
                              isBeingSaved
                                  ? cards!.add(current)
                                  : cards!.remove(current);
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
    );
  }

  Widget _buildNoCardsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_saved_cards.png', width: 90),
          const Text(
            'No saved cards',
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  SnackBar _buildDeleteSnackBar(model.Card card) {
    return SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${card.front} deleted.'),
            TextButton.icon(
              onPressed: () {
                helper.insertCard(card).then((value) => showAllCards());
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
