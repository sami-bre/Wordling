import 'package:flutter/material.dart';
import '../models/word.dart';
import '../util/dbhelper.dart';
import '../util/httpHelper.dart';
import 'word_card.dart';

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
        width: 280,
        child: FutureBuilder(
          future: HttpHelper.search(searchTerm),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Word> wordList = snapshot.data! as List<Word>;
                // when the search result is empty.
                if (wordList.isEmpty) {
                  return const Center(
                    child: Text('Nothing found.'),
                  );
                }
                return ListView.builder(
                  itemCount: wordList.length,
                  itemBuilder: (context, index) {
                    return WordCard(word: wordList[index]);
                  },
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
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
