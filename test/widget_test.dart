// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotomobile/main.dart';
import 'package:gotomobile/redux/actions/actions.dart';
import 'package:gotomobile/redux/reducers/reducers.dart';
import 'package:redux/redux.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(Store<CategoriesState>(
      categoriesReducer,
      initialState: CategoriesInitial(),
      middleware: [
        // The following middleware both achieve the same goal: Load search
        // results from github in response to SearchActions.
        //
        // One is implemented as a normal middleware, the other is implemented as
        // an epic for demonstration purposes.

//        SearchMiddleware(GithubClient()),
//      EpicMiddleware<SearchState>(SearchEpic(GithubClient())),
      ],
    )));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
