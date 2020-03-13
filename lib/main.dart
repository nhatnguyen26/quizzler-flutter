import 'package:flutter/material.dart';
import 'quiz_box.dart';
import 'sound_box.dart';
import 'score_keeper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() {
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  static QuizBox quizBox;
  static SoundBox soundBox;
  static ScoreKeeper scoreKeeper;
  _QuizPageState() {
    quizBox = QuizBox();
    soundBox = SoundBox();
    scoreKeeper = ScoreKeeper();
  }

  void answerPick(bool answer) {
    bool state = answer == quizBox.getAnswer();
    if (state) {
      soundBox.playSuccess();
    } else {
      soundBox.playFailure();
    }
    setState(() {
      if (state) {
        scoreKeeper.countCorrect();
      } else {
        scoreKeeper.countWrong();
      }

      if (quizBox.isLast()) {
        Alert(
            style: AlertStyle(isOverlayTapDismiss: false, isCloseButton: false),
            context: context,
            title: 'Finished!',
            content: getFinishContent(),
            closeFunction: resetQuiz,
            buttons: [getFinishButton()]).show();
      }
      quizBox.nextQuestion();
    });
  }

  Widget getFinishContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'You\'ve reached the end of the quiz.',
          style: AlertStyle().descStyle,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, color: Colors.green),
            Text(scoreKeeper.getCorrect().toString()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.close, color: Colors.red),
            Text(scoreKeeper.getWrong().toString()),
          ],
        )
      ],
    );
  }

  DialogButton getFinishButton() {
    return DialogButton(
      child: Text(
        "CANCEL",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: cancelButtonPress,
    );
  }

  void cancelButtonPress() {
    resetQuiz();
    Navigator.pop(context);
  }

  void resetQuiz() {
    setState(() {
      scoreKeeper.resetScore();
      quizBox.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBox.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                answerPick(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                answerPick(false);
              },
            ),
          ),
        ),
        Row(
          children: buildScore(scoreKeeper.getScores()),
        )
      ],
    );
  }

  List<Icon> buildScore(List<bool> scores) {
    List<Icon> icons = [];
    for (bool score in scores) {
      if (score) {
        icons.add(Icon(Icons.check, color: Colors.green));
      } else {
        icons.add(Icon(Icons.close, color: Colors.red));
      }
    }
    return icons;
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
