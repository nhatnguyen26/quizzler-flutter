class ScoreKeeper {
  List<bool> _scores = [];
  int _correct = 0;
  int _wrong = 0;

  List<bool> getScores() {
    return _scores;
  }

  int getCorrect() {
    return _correct;
  }

  int getWrong() {
    return _wrong;
  }

  void countCorrect() {
    _scores.add(true);
    _correct++;
  }

  void countWrong() {
    _scores.add(false);
    _wrong++;
  }

  void resetScore() {
    _scores.clear();
    _correct = 0;
    _wrong = 0;
  }
}
