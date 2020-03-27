import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/pages/FiltersPage.dart';
import 'package:gotomobile/redux/actions/home_appbar_actions.dart';
import 'package:gotomobile/redux/actions/search_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/home_appbar_state.dart';
import 'package:redux/redux.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//  final FocusNode focusNode;
//  HomeAppBar(this.focusNode);

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool delayEnded = false;

  void toggleSearch(emptySearch, toggleSearch, toggleForceFocus) {
    emptySearch();
    toggleSearch(false);
    toggleForceFocus(false);
    _textEditingController.clear();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        onInitialBuild: (_ViewModel vm) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          vm.toggleSearch(true);
          if (!delayEnded) {
            vm.emptySearch();
            vm.toggleForceFocus(true);
            vm.endDelay();
          }
        }
      });
      Future.delayed(const Duration(milliseconds: 5000), () {
        vm.emptySearch();
        vm.endDelay();
      });
    }, onDidChange: (_ViewModel vm) {
      delayEnded = vm.homeState.delayEnded;
    }, onDispose: (Store<AppState> store) {
      focusNode.dispose();
    }, converter: (store) {
      return _ViewModel.fromStore(store);
    }, builder: (BuildContext context, _ViewModel vm) {
      if (_textEditingController.text == '' &&
          vm.searchTerm.isNotEmpty &&
          vm.searchTerm != 'GoTo') {
        // if shop is chosen then back is pressed
        _textEditingController.value =
            new TextEditingValue(text: vm.searchTerm);
      }
      return AppBar(
        automaticallyImplyLeading: !vm.homeState.isSearch,
        centerTitle: true,
        actions: <Widget>[
          vm.homeState.isFilter
              ? Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Stack(children: [
                                Center(
                                  child: Text(
                                    'Filters',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "ProductSans",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ])),
                        ),
                      ],
                    ),
                  ))
              : Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Stack(children: [
                                  vm.homeState.delayEnded
                                      ? SizedBox.fromSize(size: Size(0, 0))
                                      : Center(
                                          child: Text(
                                            vm.searchTerm,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "ProductSans",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 1000),
                                    opacity:
                                        vm.homeState.delayEnded ? 1.0 : 0.0,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[500],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          controller: _textEditingController,
                                          cursorColor: Colors.grey,
                                          focusNode: focusNode,
                                          autofocus: vm.homeState.forceFocus,
                                          textAlign: vm.homeState.isSearch
                                              ? TextAlign.center
                                              : TextAlign.center,
                                          decoration: !vm.homeState.isSearch &&
                                                  !vm.homeState.forceFocus
                                              ? InputDecoration(
                                                  hintText: "Search Shops",
                                                  hintStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0x88FFFFFF)),
                                                  labelStyle: new TextStyle(
                                                      color: Color(0xFF424242)),
                                                  border: InputBorder.none)
                                              : InputDecoration(
                                                  border: InputBorder.none),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                          onSubmitted: (text) {
                                            // TODO: onSubmit
                                          },
                                          onChanged: (text) {
                                            vm.search(text);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ])),
                          ),
                        ],
                      ))),
          vm.homeState.isSearch
              ? Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => toggleSearch(
                      vm.emptySearch,
                      vm.toggleSearch,
                      vm.toggleForceFocus,
                    ),
                  ),
                )
              : vm.homeState.isFilter
                  ? IconButton(
                      icon: Icon(
                        Icons.ac_unit,
                        color: Colors.white,
                      ),
                      onPressed: () => toggleSearch(
                        vm.emptySearch,
                        vm.toggleSearch,
                        vm.toggleForceFocus,
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => FiltersPage(),
                          ),
                        );
                      },
                    ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ViewModel {
  final String searchTerm;
  final HomeState homeState;
  final void Function(String) search;
  final void Function() toggleFilter;
  final void Function(bool) toggleSearch;
  final void Function(bool) toggleForceFocus;
  final void Function() emptySearch;
  final void Function() endDelay;

  _ViewModel({
    @required this.searchTerm,
    @required this.homeState,
    @required this.search,
    @required this.emptySearch,
    @required this.toggleSearch,
    @required this.toggleForceFocus,
    @required this.toggleFilter,
    @required this.endDelay,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      searchTerm: store.state.searchState.searchTerm,
      homeState: store.state.homeState,
      emptySearch: () => store.dispatch(EmptySearchAction()),
      toggleSearch: (isSearch) => store.dispatch(ToggleSearchAction(isSearch)),
      toggleForceFocus: (isForceFocus) =>
          store.dispatch(ToggleForceFocusAction(isForceFocus)),
      toggleFilter: () => store.dispatch(ToggleFilterAction()),
      endDelay: () => store.dispatch(EndDelayAction()),
      search: (searchTerm) {
        print("search " + searchTerm);
        store.dispatch(CancelSearchAction());
        store.dispatch(SearchingAction(searchTerm));
        store.dispatch(PerformSearchAction(searchTerm));
      },
    );
  }
}
