import 'package:flutter/material.dart';
import 'package:wordling/ui/helper_dialog.dart';
import 'random_definition_display.dart';
import 'Search_result_display.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Front extends StatefulWidget {
  const Front({Key? key}) : super(key: key);

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  bool searchResultDisplayed = false;
  bool searchBarDisplayed = false;
  final Widget randDefDisplay = const RandomDefinitionDisplay();
  late Widget displayed;
  // the key below gives me a reference to the state object to call update() on it.
  final GlobalKey<SearchResultDisplayState> _key = GlobalKey();

  @override
  void initState() {
    displayed = randDefDisplay;
    super.initState();
  }

  void checkAndShowHelp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? frontHelp = prefs.getBool('frontHelp');
    if (frontHelp == null || frontHelp) {
      showDialog(
        context: context,
        builder: (context) => HelperDialog.buildFrontPageHelpDialog(context),
      );
      prefs.setBool('frontHelp', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // show the help dialog if the flag is on
    checkAndShowHelp(context);
    return WillPopScope(
      onWillPop: () {
        if (searchResultDisplayed) {
          setState(() {
            displayed = randDefDisplay;
            searchResultDisplayed = false;
            searchBarDisplayed = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Get.isDarkMode
                  ? const Icon(Icons.wb_sunny_rounded)
                  : const Icon(Icons.nightlight_rounded),
              onPressed: () {
                Get.isDarkMode
                    ? Get.changeThemeMode(ThemeMode.light)
                    : Get.changeThemeMode(ThemeMode.dark);
                setState(() {});
              }),
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
                    displayed = randDefDisplay;
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Expanded(child: SizedBox()),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.message_rounded,
                  size: 20,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildAboutDialog(context),
                ).then((value) {
                  print('about to write to prefs. received: $value');
                  if (value == true) {
                    SharedPreferences prefs;
                    SharedPreferences.getInstance().then((value) {
                      prefs = value;
                      prefs.setBool('myCardsHelp', true);
                      prefs.setBool('studyHelp', true);
                    });

                    showDialog(
                      context: context,
                      builder: (context) =>
                          HelperDialog.buildFrontPageHelpDialog(context),
                    );
                  }
                });
              },
            ),
            const Expanded(flex: 3, child: SizedBox()),
            FloatingActionButton(
              // backgroundColor: Get.isDarkMode ? darkHeroColor : lightHeroColor,
              heroTag: 'playButton',
              onPressed: () => Navigator.pushNamed(context, '/study'),
              child: const Icon(Icons.play_lesson_outlined),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              // backgroundColor: Get.isDarkMode ? darkHeroColor : lightHeroColor,
              heroTag: 'myCardsButton',
              onPressed: () => Navigator.pushNamed(context, '/saved'),
              child: const Icon(Icons.card_membership),
            ),
          ],
        ),
      ),
    );
  }

  _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Text('Wordling'),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.question_mark_rounded),
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('By sami-bre'),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.telegram,
                color: Colors.grey,
              ),
              SizedBox(width: 5),
              Text('@sami_bre'),
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.mail_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  'samuelbirhanu121@gmail.com',
                  maxLines: 3,
                ),
              )
            ],
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/website.png',
                width: 22,
              ),
              const SizedBox(width: 5),
              const Flexible(
                  child: Text(
                'www.samibre.com',
              ))
            ],
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/github.png',
                width: 26,
              ),
              const SizedBox(width: 5),
              const Flexible(
                  child: Text(
                'github.com/sami-bre',
              ))
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Hit the question mark on this dialog to get help on how to use Wordling.',
          ),
          const SizedBox(height: 20),
          const Text(
              'For bug reports, comments or proposals for future projects, '
              'write to me via telegram or email.'),
        ],
      ),
    );
  }
}
