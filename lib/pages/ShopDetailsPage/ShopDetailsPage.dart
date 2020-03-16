import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';

import 'AboutTab.dart';
import 'BranchesTab.dart';
import 'PostsTab.dart';
import 'ShopDetailsHeader.dart';

class ShopDetailsPage extends StatefulWidget {
  final String heroTag;
  final Shop shop;

  ShopDetailsPage({this.heroTag, this.shop});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<ShopDetailsPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

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
    _tabController =
        new TabController(initialIndex: 2, vsync: this, length: tabList.length);

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  ShopDetailsHeader(widget.shop, widget.heroTag, _scaffoldKey)
                ]),
              )
            ];
          },
          body: DefaultTabController(
            initialIndex: 2,
            length: tabList.length,
            child: Column(
              children: <Widget>[
                Container(
                  child: TabBar(
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.black,
                      tabs: tabList),
                ),
                Expanded(
                  child: TabBarView(
//                    physics: NeverScrollableScrollPhysics(),
                    children: tabList.map((Tab tab) {
                      return _getPage(tab);
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case 'About':
        return AboutTab(widget.shop.about);
      case 'Branches':
        return BranchesTab(widget.shop.id);
      case 'Posts':
        return PostsTab(widget.shop);
    }
    return AboutTab(widget.shop.about);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      // TODO: load data for the PostsTab :/
//      if (!_loadingPosts) {
//        if (_moreToLoad) {
//          loadPosts();
//        }
//      }
    }

    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the top");
    }
  }
}
