import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:must/View/LearningView/MeaningQuizView.dart';
import 'package:must/style.dart' as myStyle;

import '../data/MeaningQuizParsing.dart';
import 'mock_apitest.dart';

void main() {
  testWidgets('MeaningQuizView Test', (WidgetTester tester) async {
    // Create a mock MeanQuiz object
    final mockQuiz = MeanQuiz(
      word: 'Test Question',
      answers: ['Correct Answer'],
      choices: ['Correct Answer', 'Wrong Answer 1', 'Wrong Answer 2', 'Wrong Answer 3'],
    );

    // Create a mock API service to return the mock quiz
    final mockApiService = MockApiService();
    when(mockApiService.getMeanQuizSet(any, any)).thenAnswer((_) async => [mockQuiz]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: MeaningQuizView(songId: 1, setNum: 1),
      ),
    );

    // Verify that the quiz is loaded
    expect(find.text('Test Question'), findsOneWidget);
    expect(find.text('Correct Answer'), findsOneWidget);
    expect(find.text('Wrong Answer 1'), findsOneWidget);
    expect(find.text('Wrong Answer 2'), findsOneWidget);
    expect(find.text('Wrong Answer 3'), findsOneWidget);

    // Tap on the correct answer
    await tester.tap(find.text('Correct Answer'));
    await tester.pump();

    // Verify the answer submission
    await tester.tap(find.text('제출하기'));
    await tester.pump();

    // Verify the result message
    expect(find.text('정답입니다!'), findsOneWidget);

    // Tap on the next button
    await tester.tap(find.text('다음으로'));
    await tester.pump();

    // Verify that the next question is displayed
    // In this case, since there's only one question, it should end the quiz
    expect(find.text('퀴즈 끝'), findsOneWidget);
  });
}
