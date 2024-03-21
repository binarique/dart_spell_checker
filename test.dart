// import 'dart:ffi';

// void main(List<String> args) async {
//   var word = "Hello";
//   //////////////////////////////////////////////
//   List<Map<String, String>> wSplits(String word) {
//     List<Map<String, String>> results = [];
//     for (int i = 0; i < (word.length + 1); i++) {
//       results.add({word.substring(0, i): word.substring(i)});
//     }
//     return results;
//   }

//   ////////////////////////////////////////////////////////////
//   List<String> wDeletes(List<Map<String, String>> splits) {
//     List<String> results = [];
//     for (Map<String, String> split in splits) {
//       List<String> lList = split.keys.toList(); // left
//       List<String> rList = split.values.toList(); // right
//       if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
//         if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
//           String rl = (lList[0] + rList[0].substring(1));
//           results.add(rl);
//         } else {
//           String rl = rList[0].substring(1);
//           results.add(rl);
//         }
//       }
//     }
//     return results;
//   }

//   ////////////////////////////////////////////////////////////
//   List<String> wTransposes(List<Map<String, String>> splits) {
//     List<String> results = [];
//     for (Map<String, String> split in splits) {
//       List<String> lList = split.keys.toList(); // left
//       List<String> rList = split.values.toList(); // right
//       if (rList.isNotEmpty &&
//           rList[0].trim().isNotEmpty &&
//           rList[0].trim().length > 1) {
//         if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
//           String rl =
//               (lList[0] + rList[0][1] + rList[0][0] + rList[0].substring(2));
//           results.add(rl);
//         } else {
//           String rl = rList[0][1] + rList[0][0] + rList[0].substring(2);
//           results.add(rl);
//         }
//       }
//     }
//     return results;
//   }

//   List<String> wReplaces(List<Map<String, String>> splits) {
//     String letters = "abcdefghijklmnopqrstuvwxyz";
//     List<String> results = [];
//     for (int k = 0; k < letters.length; k++) {
//       String c = letters[k];
//       for (Map<String, String> split in splits) {
//         List<String> lList = split.keys.toList(); // left
//         List<String> rList = split.values.toList(); // right
//         if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
//           if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
//             String rl = (lList[0] + c + rList[0].substring(1));
//             results.add(rl);
//           } else {
//             String rl = c + rList[0].substring(1);
//             results.add(rl);
//           }
//         }
//       }
//     }
//     return results;
//   }

//   List<String> wInserts(List<Map<String, String>> splits) {
//     String letters = "abcdefghijklmnopqrstuvwxyz";
//     List<String> results = [];
//     for (int k = 0; k < letters.length; k++) {
//       String c = letters[k];
//       for (Map<String, String> split in splits) {
//         List<String> lList = split.keys.toList(); // left
//         List<String> rList = split.values.toList(); // right
//         if (rList.isNotEmpty && rList[0].trim().isNotEmpty) {
//           if (lList.isNotEmpty && lList[0].trim().isNotEmpty) {
//             String rl = (lList[0] + c + rList[0]);
//             results.add(rl);
//           } else {
//             String rl = c + rList[0];
//             results.add(rl);
//           }
//         }
//       }
//     }
//     return results;
//   }

//   List<Map<String, String>> splits = wSplits(word);
//   //print(splits);
//   List<String> deletes = wDeletes(splits);
//   List<String> transposes = wTransposes(splits);
//   List<String> replaces = wReplaces(splits);
//   List<String> inserts = wInserts(splits);

//   List<String> edits1(word) {
//     List<Map<String, String>> splits = wSplits(word);
//     List<String> deletes = wDeletes(splits);
//     List<String> transposes = wTransposes(splits);
//     List<String> replaces = wReplaces(splits);
//     List<String> inserts = wInserts(splits);
//     // merge edits in a set to avaoid duplicates
//     return {...deletes, ...transposes, ...replaces, ...inserts}.toList();
//   }

//   List<String> edits2(word) {
//     List<String> results = [];
//     for (String e1 in edits1(word)) {
//       for (String e2 in edits1(e1)) {
//         results.add(e2);
//       }
//     }
//     return results;
//   }
//   print(edits2(word));
// }

//  def copycase(self, originalword, word):
//       if self.isCapitalized(originalword):
//           return word.capitalize()
//       elif originalword.isupper():
//           return word.upper()
//       else:
//           return word.lower()

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

  def correction(self, word, suggested=True):
    originalword = word
    word = word.lower()
    "Most probable spelling correction for word."
    if word not in self.corpus:  # no need to check spellings its already exist
            word_probas = {
                word: self.words[word] / self.word_counts for word in self.words.keys()
            }
    valid_candidates = self.candidates(word)
    if word not in self.corpus:  # no need to check spellings its already exist
        word_probas = {
            word: self.words[word] / self.word_counts for word in self.words.keys()
        }
        if word_probas:
            try:
                suggestions = [
                    {
                        "word": self.copycase(originalword, c),
                        "probability": word_probas[c],
                        "out_of_vocab": False,
                        "no_sp": False,
                    }
                    for c in valid_candidates
                ]
            except:
                suggestions = []

            if suggested:
                sorted_suggestions = sorted(
                    suggestions, key=lambda tup: tup["word"], reverse=True
                )
                return sorted_suggestions
            else:
                return self.BestCandidate(suggestions)
        else:
            return [
                {
                    "word": word,
                    "probability": 0,
                    "out_of_vocab": True,
                    "no_sp": True,
                }
            ]
    else:
        return [{"word": word, "probability": 1, "out_of_vocab": False, "no_sp": False}]