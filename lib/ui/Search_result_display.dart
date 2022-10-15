import 'package:flutter/material.dart';
import '../models/card.dart' as model;
import '../util/dbhelper.dart';
import '../util/http_helper.dart';
import 'wordling_card.dart';

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
                List<model.Card> cardList = snapshot.data! as List<model.Card>;
                // when the search result is empty.
                if (cardList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/search_found_nothing.png',
                            width: 90),
                        const Text(
                          'Nothing found',
                          textScaleFactor: 1.2,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (model.Card card in cardList) WordlingCard(card)
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/network_error.png', width: 90),
                      const Text(
                        'Oops! Network problem',
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                );
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
