import 'package:flutter/material.dart';
import 'package:gotomobile/widgets/drawer/CustomDrawer.dart';

class ErrorPage extends StatelessWidget {
	final AppBar _appBar;
  final CustomDrawer drawer;
  final String _errorText;
  final Function _loadData;

  ErrorPage(this._appBar, this._errorText, this._loadData, {this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      drawer: drawer,
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
			  onPressed: () => _loadData(error: true),
          ),
        ],
      )),
    );
  }
}
