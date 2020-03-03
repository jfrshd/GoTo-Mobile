import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/pages/CompanyDetailsPage/CompanyDetailsHeader.dart';
import 'package:gotomobile/services/shopsService.dart';

import 'AboutTab.dart';
import 'BranchesTab.dart';
import 'PostsTab.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String heroTag;
  final Shop shop;

  CompanyDetailsPage({this.heroTag, this.shop});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage>
    with TickerProviderStateMixin {
  List<Tab> tabList = List();

  TabController _tabController;

  @override
  void initState() {
    tabList.add(new Tab(
      text: 'About',
    ));
    tabList.add(new Tab(
      text: 'Branches',
    ));
    tabList.add(new Tab(
      text: 'Posts',
    ));
    _tabController = new TabController(vsync: this, length: tabList.length);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
//        padding: EdgeInsets.all(10),
            children: <Widget>[
              CompanyDetailsHeader(
                shop: widget.shop,
                heroTag: widget.heroTag,
              ),
//              _tabController == null
//                  ? null
//                  :
              Column(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
//                              color: Theme.of(context).primaryColor
                        color: Colors.white),
                    child: new TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.black,
                        tabs: tabList),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 250,
                    child: TabBarView(
                      controller: _tabController,
                      children: tabList.map((Tab tab) {
                        return _getPage(tab);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case 'About':
        return AboutTab();
      case 'Branches':
        return BranchesTab(widget.shop.id);
      case 'Posts':
        return PostsTab(widget.shop);
    }
    return AboutTab();
  }
}
