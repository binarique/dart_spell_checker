import 'dart:io';

List<String> findAllWords(String textString) {
  List<String> words = [];
  final regexp = RegExp(r'\w+');
  final matches = regexp.allMatches(textString);
  for (var match in matches) {
    words.add(match.group(0).toString());
  }
  return words;
}

Map<String, int> Counter(List<String> items) {
  final counter = <String, int>{};
  for (final item in items) {
    counter[item] = (counter[item] ?? 0) + 1;
  }
  return counter;
}

int sumList(List<int> values) {
  int sum = 0;
  for (int value in values) {
    sum += value;
  }
  return sum;
}

List<String> known(List<String> words, Map<String, int> wordsIndex) {
  Set<String> wordSet = {};
  for (var w in words) {
    if (wordsIndex.containsKey(w)) {
      wordSet.add(w);
    }
  }
  return wordSet.toList();
}

double P(String word, Map<String, int> wordsIndex) {
  int N = sumList(wordsIndex.values.toList());
  return ((wordsIndex[word] ?? 0) / N);
}

List<Map<String, String>> wSplits(String word) {
  List<Map<String, String>> results = [];
  for (int i = 0; i < (word.length + 1); i++) {
    results.add({word.substring(0, i): word.substring(i)});
  }
  return results;
}

////////////////////////////////////////////////////////////
List<String> wDeletes(List<Map<String, String>> splits) {
  List<String> results = [];
  for (Map<String, String> split in splits) {
    List<String> lList = split.keys.toList(); // left
    List<String> rList = split.values.toList(); // right
    if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
      if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
        String rl = (lList[0] + rList[0].substring(1));
        results.add(rl);
      } else {
        String rl = rList[0].substring(1);
        results.add(rl);
      }
    }
  }
  return results;
}

////////////////////////////////////////////////////////////
List<String> wTransposes(List<Map<String, String>> splits) {
  List<String> results = [];
  for (Map<String, String> split in splits) {
    List<String> lList = split.keys.toList(); // left
    List<String> rList = split.values.toList(); // right
    if (rList.isNotEmpty &&
        rList[0].trim().isNotEmpty &&
        rList[0].trim().length > 1) {
      if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
        String rl =
            (lList[0] + rList[0][1] + rList[0][0] + rList[0].substring(2));
        results.add(rl);
      } else {
        String rl = rList[0][1] + rList[0][0] + rList[0].substring(2);
        results.add(rl);
      }
    }
  }
  return results;
}

List<String> wReplaces(List<Map<String, String>> splits) {
  String letters = "abcdefghijklmnopqrstuvwxyz";
  List<String> results = [];
  for (int k = 0; k < letters.length; k++) {
    String c = letters[k];
    for (Map<String, String> split in splits) {
      List<String> lList = split.keys.toList(); // left
      List<String> rList = split.values.toList(); // right
      if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
        if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
          String rl = (lList[0] + c + rList[0].substring(1));
          results.add(rl);
        } else {
          String rl = c + rList[0].substring(1);
          results.add(rl);
        }
      }
    }
  }
  return results;
}

List<String> wInserts(List<Map<String, String>> splits) {
  String letters = "abcdefghijklmnopqrstuvwxyz";
  List<String> results = [];
  for (int k = 0; k < letters.length; k++) {
    String c = letters[k];
    for (Map<String, String> split in splits) {
      List<String> lList = split.keys.toList(); // left
      List<String> rList = split.values.toList(); // right
      if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
        if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
          String rl = (lList[0] + c + rList[0]);
          results.add(rl);
        } else {
          String rl = c + rList[0];
          results.add(rl);
        }
      }
    }
  }
  return results;
}

List<String> edits1(word) {
  List<Map<String, String>> splits = wSplits(word);
  List<String> deletes = wDeletes(splits);
  List<String> transposes = wTransposes(splits);
  List<String> replaces = wReplaces(splits);
  List<String> inserts = wInserts(splits);
  // merge edits in a set to avaoid duplicates
  return {...deletes, ...transposes, ...replaces, ...inserts}.toList();
}

List<String> edits2(word) {
  List<String> results = [];
  for (String e1 in edits1(word)) {
    for (String e2 in edits1(e1)) {
      results.add(e2);
    }
  }
  return results;
}

List<String> candidates(String word, Map<String, int> wordsIndex) {
  List<String> candidates1 = known([word], wordsIndex);
  List<String> candidates2 = known(edits1(word), wordsIndex);
  List<String> candidates3 = known(edits2(word), wordsIndex);
  if (candidates1.length > 0) {
    return candidates1;
  } else if (candidates2.length > 0) {
    return candidates2;
  } else if (candidates3.length > 0) {
    return candidates3;
  } else {
    return [word];
  }
}

bool isCapitalized(String str) {
  final regExp = RegExp(r'^[A-Z]');
  return regExp.hasMatch(str);
}

bool isupper(word) {
  final regExp = RegExp('[A-Z]');
  return regExp.hasMatch(word);
}

bool islower(word) {
  final regExp = RegExp('[a-z]');
  return regExp.hasMatch(word);
}

String capitalize(String str) {
  return str.isNotEmpty ? str[0].toUpperCase() + str.substring(1) : str;
}

String copycase(String originalword, String word) {
  if (isCapitalized(originalword)) {
    return capitalize(word);
  } else if (isupper(originalword)) {
    return word.toUpperCase();
  } else if (islower(originalword)) {
    return word.toLowerCase();
  } else {
    return word;
  }
}

List<Map> correction(String word, Map<String, int> wordsIndex,
    {bool suggested = true}) {
  String oword = word;
  String lword = word.toLowerCase();
  List<String> valid_candidates = candidates(lword, wordsIndex);

  List<Map> results = [];

  return results;
}

Future<void> main(List<String> args) async {
  var filePath = "corpus/corpus.txt";
  File file = File(filePath);
  var corpus = file.readAsStringSync();
  var cwords = findAllWords(corpus);
  var words_index = Counter(cwords);
  var oword = "omunyo";
  int word_counts = sumList(words_index.values.toList());
  List<String> _candidates = candidates(oword, words_index);
  Map word_probas = {};
  for (String word in words_index.keys.toList()) {
    word_probas[word] = (words_index[word]! / word_counts);
  }

  List<Map> suggestions = [];
  for (String c in _candidates) {
    suggestions.add({
      "word": copycase(oword, c),
      "probability": word_probas[c],
      "out_of_vocab": false,
      "no_sp": false,
    });
  }
  // sort out the most probable
  suggestions.sort(
    (a, b) => b["probability"].compareTo(a["probability"]),
  );
  print(suggestions);
}
