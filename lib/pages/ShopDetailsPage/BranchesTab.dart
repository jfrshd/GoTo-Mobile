import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/branch.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/redux/actions/shop_branch_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/BranchItem.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:redux/redux.dart';

import '../ErrorPage.dart';

class BranchesTab extends StatelessWidget {
  final int shopID;

  BranchesTab(this.shopID);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ViewModel vm) {
        if (vm.failLoad || vm.errorLoad)
          return ErrorPage(
            vm.failLoad ? Constants.branchesFail : Constants.branchesError,
            vm.fetchBranches,
            extraParams: shopID,
          );

        return Container(
          color: Colors.grey[100],
          child: vm.loading
              ? Center(
                  child: ColorLoader4(
                      color1: Colors.blue,
                      color2: Colors.blue[300],
                      color3: Colors.blue[100]))
              : vm.branches.isEmpty
                  ? Center(
                      child: Text("No branches found"),
                    )
                  : GridView.builder(
                      itemCount: vm.branches.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 2 : 3),
                      itemBuilder: (BuildContext context, int index) {
                        return BranchItem(index, vm.branches[index]);
                      },
                    ),
        );
      },
    );
  }
}

class _ViewModel {
  final bool loading, failLoad, errorLoad;
  final List<Branch> branches;
  final Function(int) fetchBranches;

  _ViewModel({
    @required this.loading,
    @required this.failLoad,
    @required this.errorLoad,
    @required this.branches,
    @required this.fetchBranches,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final shopID = store.state.shopState.selectedShopId;
    return _ViewModel(
      loading: store.state.shopBranchState.loading,
      failLoad: store.state.shopBranchState.failLoad,
      errorLoad: store.state.shopBranchState.errorLoad,
      branches: store.state.shopBranchState.shopBranches[shopID] ?? [],
      fetchBranches: (int shopID) =>
          store.dispatch(fetchShopBranchesAction(shopID: shopID)),
    );
  }
}
