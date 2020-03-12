import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/services/shopsService.dart';
import 'package:gotomobile/utils/Constants.dart';

import 'ShopItem.dart';
import 'colorLoader/ColorLoader4.dart';

class ShopsList extends StatefulWidget {
  final String searchText;

  ShopsList(this.searchText);

  @override
  _ShopsListState createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  bool _error = false;
  bool _loadingShops = false;

  List<Shop> _shops = List();

  @override
  void didUpdateWidget(ShopsList oldWidget) {
    if (oldWidget.searchText != widget.searchText) loadShops();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ErrorPage(Constants.shopsSearchError, loadShops);
    }

    if (!_loadingShops && widget.searchText == '') {
      return Center(child: Text('Start typing to search our shops'));
    }
    if (_shops.length > 0 && widget.searchText != '') {
      if (_loadingShops) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Center(
                child: Text('Searching...'),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _shops.length,
                itemBuilder: (context, index) {
                  return ShopItem(index, _shops[index]);
                },
              ),
            ),
          ],
        );
      } else {
        return ListView.builder(
          itemCount: _shops.length,
          itemBuilder: (context, index) {
            return ShopItem(index, _shops[index]);
          },
        );
      }
    }
    if (widget.searchText != '' && _shops.length == 0) {
      if (_loadingShops) {
        return Center(
          child: ColorLoader4(
              color1: Colors.blue,
              color2: Colors.blue[300],
              color3: Colors.blue[100]),
        );
      } else {
        return Center(child: Text('No results found'));
      }
    }
  }

  loadShops({bool error}) {
    if (widget.searchText == '') {
      setState(() {
        _error = false;
        _loadingShops = false;
        _shops.clear();
      });
      return;
    }
    setState(() {
      _error = false;
      _loadingShops = true;
    });
    searchShops(widget.searchText).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final shops =
            parsed['shops'].map<Shop>((json) => Shop.fromJson(json)).toList();
        setState(() {
          _error = false;
          _loadingShops = false;
          _shops = shops;
        });
      }
    }).catchError((e) {
      print("searchShops error: ");
      print(e);
      setState(() {
        _error = true;
        _loadingShops = false;
      });
    });
  }
}
