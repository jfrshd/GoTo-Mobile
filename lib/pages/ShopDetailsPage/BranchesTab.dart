import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/branch.dart';
import 'package:gotomobile/services/branchesService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/BranchItem.dart';

import '../ErrorPage.dart';

class BranchesTab extends StatefulWidget {
  final int shopID;

  BranchesTab(this.shopID);

  @override
  _BranchesTabState createState() => _BranchesTabState();
}

class _BranchesTabState extends State<BranchesTab> {
  bool _loadingBranches = false;
  bool _error = false;
  List<Branch> _branches = List<Branch>();

  void initState() {
    super.initState();
    if (_branches.length == 0) _loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (_error) {
      return ErrorPage(
          null, Constants.branchesError, _loadBranches);
    }
    return Container(
      color: Colors.grey[100],
      child: _branches.length == 0
          ? Text('no branches found')
          : GridView.builder(
              itemCount: _branches.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (BuildContext context, int index) {
                return BranchItem(index, _branches[index]);
              },
            ),
    );
  }

  void _loadBranches() {
    setState(() {
      _loadingBranches = true;
      _error = false;
    });
    getShopBranches(widget.shopID).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final branches = parsed['branches']
            .map<Branch>((json) => Branch.fromJson(json))
            .toList();

        setState(() {
          _error = false;
          _loadingBranches = false;
          _branches = branches;
        });
      }
    }).catchError((e) {
      print("getShopBranches error: ");
      print(e);
      setState(() {
        _error = true;
        _loadingBranches = false;
      });
    });
  }
}
