import 'package:flutter/material.dart';
import 'random_word_display.dart';
import 'Search_result_display.dart';

class Front extends StatefulWidget {
  const Front({Key? key}) : super(key: key);

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  bool searchResultDisplayed = false;
  bool searchBarDisplayed = false;
  Widget displayed = const RandomWordDisplay();
  // the key below gives me a reference to the state object to call update() on it.
  final GlobalKey<SearchResultDisplayState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (searchResultDisplayed) {
          setState(() {
            displayed = const RandomWordDisplay();
            searchResultDisplayed = false;
            searchBarDisplayed = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: searchBarDisplayed
              ? TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      // this is for first time build. seems like the widget gets built only once.
                      // i don't know why but the initState doesn't run on subsequent calls to the constructor.
                      displayed = SearchResultDisplay(key: _key, value);
                      // this is for updating the searchTerm in subsequent searches.
                      _key.currentState?.update(value);
                      searchResultDisplayed = true;
                    });
                  },
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xffCFD8DC),
                    fontSize: 22,
                  ),
                  decoration: const InputDecoration(
                    label: Text(
                      'Search ',
                      style: TextStyle(color: Color(0xffCFD8DC)),
                    ),
                  ),
                )
              : const Text("Wordling"),
          backgroundColor: const Color(0xff212121),
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
                    searchResultDisplayed = false;
                    displayed = const RandomWordDisplay();
                  });
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 30,
                ),
              ),
          ],
        ),
        body: displayed,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.card_membership),
        ),
      ),
    );
  }
}
