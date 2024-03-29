import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String _errorText;
  final Function _loadData;

  ErrorPage(this._errorText, this._loadData);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Text(
          _errorText,
        )),
        SizedBox(height: 20),
        IconButton(
          iconSize: 50,
          icon: Icon(Icons.refresh),
          onPressed: () => _loadData(),
        ),
      ],
    ));
  }
}
