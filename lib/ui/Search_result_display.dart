import 'package:flutter/material.dart';
import '../models/definition.dart';
import '../util/dbhelper.dart';
import '../util/httpHelper.dart';
import 'definition_card.dart';

class SearchResultDisplay extends StatefulWidget {
  final String searchTerm;
  const SearchResultDisplay(this.searchTerm, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SearchResultDisplay> createState() =>
      SearchResultDisplayState(searchTerm);
}

class SearchResultDisplayState extends State<SearchResultDisplay> {
  DbHelper helper = DbHelper();
  String searchTerm;

  SearchResultDisplayState(this.searchTerm);

  void update(String searchTerm) {
    setState(() {
      this.searchTerm = searchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // here too, the results display (and thus the cards) should
        // be 0.8 times the screen width.
        width: MediaQuery.of(context).size.shortestSide * 0.8,
        child: FutureBuilder(
          future: HttpHelper.search(searchTerm),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Definition> defnList = snapshot.data! as List<Definition>;
                // when the search result is empty.
                if (defnList.isEmpty) {
                  return const Center(
                    child: Text('Nothing found.'),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (Definition defn in defnList) DefinitionCard(defn)
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Network problem.');
              } else {
                throw Exception(
                    'both snapshot.hasError and snapshot.hasData are false. '
                    'something else is happening. which is unexpected.');
              }
            } else {
              return const Center(
                child: SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
