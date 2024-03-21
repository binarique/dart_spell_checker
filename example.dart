import 'dart:io';
import 'lib/spell_checker.dart';

Future<void> main(List<String> args) async {
  var filePath = "corpus/corpus.txt";
  var oword = "Omunyo";
  var spell = SpellChecker(filePath);
  var suggestions = spell.getSuggestions(oword);
  print(suggestions);
}
