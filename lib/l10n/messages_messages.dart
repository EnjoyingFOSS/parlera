// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  static m0(count) => "${count} items";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "categoryItemQuestionsCount" : m0,
    "emptyFavorites" : MessageLookupByLibrary.simpleMessage("Add favorite categories to find them quicker"),
    "gameCancelApprove" : MessageLookupByLibrary.simpleMessage("OK"),
    "gameCancelConfirmation" : MessageLookupByLibrary.simpleMessage("Do you want to cancel the current game?"),
    "gameCancelDeny" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "gameTime" : MessageLookupByLibrary.simpleMessage("Game time"),
    "lastQuestion" : MessageLookupByLibrary.simpleMessage("Last Question"),
    "preparationOrientationDescription" : MessageLookupByLibrary.simpleMessage("Place the phone on forehead"),
    "preparationPlay" : MessageLookupByLibrary.simpleMessage("Play"),
    "settingsAccelerometer" : MessageLookupByLibrary.simpleMessage("Accelerometer"),
    "settingsAccelerometerHint" : MessageLookupByLibrary.simpleMessage("Tilt the phone down if you guess the word correctly"),
    "settingsAudio" : MessageLookupByLibrary.simpleMessage("Audio"),
    "settingsCamera" : MessageLookupByLibrary.simpleMessage("Camera"),
    "settingsCameraHint" : MessageLookupByLibrary.simpleMessage("Take temporary photos during game"),
    "settingsHeader" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsLanguage" : MessageLookupByLibrary.simpleMessage("Language"),
    "settingsPrivacyPolicy" : MessageLookupByLibrary.simpleMessage("Privacy policy"),
    "settingsSpeech" : MessageLookupByLibrary.simpleMessage("Microphone"),
    "settingsSpeechHint" : MessageLookupByLibrary.simpleMessage("Recognize answers automatically during game"),
    "settingsStartTutorial" : MessageLookupByLibrary.simpleMessage("How to play?"),
    "summaryBack" : MessageLookupByLibrary.simpleMessage("Play again"),
    "summaryHeader" : MessageLookupByLibrary.simpleMessage("Your score"),
    "tutorialFirstSectionDescription" : MessageLookupByLibrary.simpleMessage("Gather a groups of friends and sit together. Youngest player starts."),
    "tutorialFirstSectionHeader" : MessageLookupByLibrary.simpleMessage("Friends"),
    "tutorialFourthSectionDescription" : MessageLookupByLibrary.simpleMessage("Tap the screen for next question. Good luck!"),
    "tutorialFourthSectionHeader" : MessageLookupByLibrary.simpleMessage("Fun!"),
    "tutorialSecondSectionDescription" : MessageLookupByLibrary.simpleMessage("Select the category and place the phone on forehead. Guess the word with friends help."),
    "tutorialSecondSectionHeader" : MessageLookupByLibrary.simpleMessage("Category"),
    "tutorialSkip" : MessageLookupByLibrary.simpleMessage("Play"),
    "tutorialThirdSectionDescription" : MessageLookupByLibrary.simpleMessage("Decide on what kind of tips would you use during the round - speak, show, draw or even hum."),
    "tutorialThirdSectionHeader" : MessageLookupByLibrary.simpleMessage("Tips")
  };
}
