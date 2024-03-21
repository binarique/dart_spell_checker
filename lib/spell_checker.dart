import 'dart:io';

class SpellChecker {
  var corpus, words, wordsIndex;
  late int wordCounts;
  late String letters;
  ////////////////////
  SpellChecker(String corpus_file_path) {
    File file = File(corpus_file_path);
    this.corpus = file.readAsStringSync();
    this.words = findAllWords(corpus);
    this.wordsIndex = Counter(this.words);
    this.wordCounts = sumList(this.wordsIndex.values.toList());
    this.letters = "abcdefghijklmnopqrstuvwxyz";
  }

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

  List<String> known(List<String> words) {
    Set<String> wordSet = {};
    for (var w in words) {
      if (this.wordsIndex.containsKey(w)) {
        wordSet.add(w);
      }
    }
    return wordSet.toList();
  }

  double P(String word) {
    int N = sumList(this.wordsIndex.values.toList());
    return ((this.wordsIndex[word] ?? 0) / N);
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
    List<String> results = [];
    for (int k = 0; k < this.letters.length; k++) {
      String c = this.letters[k];
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
    List<String> results = [];
    for (int k = 0; k < this.letters.length; k++) {
      String c = this.letters[k];
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
    List<Map<String, String>> splits = this.wSplits(word);
    List<String> deletes = this.wDeletes(splits);
    List<String> transposes = this.wTransposes(splits);
    List<String> replaces = this.wReplaces(splits);
    List<String> inserts = this.wInserts(splits);
    // merge edits in a set to avaoid duplicates
    return {...deletes, ...transposes, ...replaces, ...inserts}.toList();
  }

  List<String> edits2(word) {
    List<String> results = [];
    for (String e1 in this.edits1(word)) {
      for (String e2 in this.edits1(e1)) {
        results.add(e2);
      }
    }
    return results;
  }

  List<String> candidates(String word) {
    List<String> candidates1 = this.known([word]);
    List<String> candidates2 = this.known(this.edits1(word));
    List<String> candidates3 = this.known(this.edits2(word));
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
    if (this.isCapitalized(originalword)) {
      return this.capitalize(word);
    } else if (this.isupper(originalword)) {
      return word.toUpperCase();
    } else if (this.islower(originalword)) {
      return word.toLowerCase();
    } else {
      return word;
    }
  }

  List<Map> getSuggestions(String word) {
    List<Map> suggestions = [];
    String oword = word;
    String lword = word.toLowerCase();
    List<String> _candidates = candidates(word);
    Map word_probas = {};
    for (String word in this.wordsIndex.keys.toList()) {
      word_probas[word] = (this.wordsIndex[word]! / this.wordCounts);
    }
    for (String c in _candidates) {
      suggestions.add({
        "word": copycase(oword, c),
        "probability": word_probas[c],
        "out_of_vocab": false,
        "no_sp": false,
      });
    }
    if (suggestions.length > 0) {
      // sort by probability
      suggestions.sort(
        (a, b) => b["probability"].compareTo(a["probability"]),
      );
    }
    return suggestions;
  }

  List<Map> correction(String word, {bool suggested = true}) {
    String oword = word;
    String lword = word.toLowerCase();
    List<String> validCandidates = this.candidates(lword);
    List<Map> results = [];

    return results;
  }
}
