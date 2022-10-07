import 'package:flutter/material.dart';

class HelperDialog {
  static AlertDialog buildFrontPageHelpDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Search'),
      content: Column(
        children: const [
          Text('Wordling is a flashcard app with an embeded dictionary '
              'to search, save, create, edit and study flashcards with spaced repitition.'),
          SizedBox(height: 20),
          Text(
              'This is the front page where you can search for silly slang definitions :). '
              'You also see a randomly selected one from your saved cards.'),
          SizedBox(height: 20),
          Text(
              'You can double tap on a card anywhere in the app to save or delete it. '
              'Saved cards have bright colors wheras unsaved ones are cold.')
        ],
      ),
    );
  }

  static AlertDialog buildStudyPageHelpDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Study'),
      content: Column(
        children: const [
          Text(
              'This is where you study your flashcards and strengthen your memory. '
              'The frequency at which a card appears is appropriately spaced to aid retention.'),
          SizedBox(height: 20),
          Text(
              'A single tap on the card flips it to reveal what\'s behind. Use the slider on the left '
              'to tell Wordling how difficult it is to recall the definition. Pay attention to the stages '
              'on the slider. The upper two stages mean failure to recall.'),
          SizedBox(height: 20),
          Text(
              'You can also use the arrow buttons to pass cards but only the slider '
              'registers your performance.')
        ],
      ),
    );
  }

  static AlertDialog buildMyCardsPageHelpDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('My cards'),
      content: Column(
        children: const [
          Text(
              'This is where you get all your saved cards. You can use the search '
              'feature to quickly find saved cards. '),
          SizedBox(height: 20),
          Text(
              'To save a card (or delete), double tap on it anywhere in the app. '
              'Here, you can also slide on an item to delete it.'),
          SizedBox(height: 20),
          Text(
              'Use the edit buttons and the add button to edit saved cards and add new ones.')
        ],
      ),
    );
  }
}
