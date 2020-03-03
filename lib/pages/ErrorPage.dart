import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final AppBar _appBar;
  final String _errorText;
  final Function loadData;

  ErrorPage(this._appBar, this._errorText, this.loadData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Container(
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
            onPressed: loadData,
          ),
        ],
      )),
    );
  }
}
