import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/models/filter.dart';
import 'package:gotomobile/redux/actions/filter_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/filter_state.dart';
import 'package:gotomobile/widgets/filter/CategoriesCard.dart';
import 'package:gotomobile/widgets/filter/PostTypeCard.dart';
import 'package:gotomobile/widgets/filter/SortCard.dart';
import 'package:redux/redux.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Filter"),
            centerTitle: true,
          ),
          backgroundColor: Colors.grey[300],
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: SizedBox(height: 5, child: Container())),
              SliverToBoxAdapter(
                  child:
                      PostTypeCard(vm.filterState.postTypes, vm.savePostTypes)),
              SliverToBoxAdapter(
                  child: SortCard(vm.filterState.sortTypes, vm.saveSortType)),
              SliverToBoxAdapter(
                  child: CategoriesCard(
                      vm.filterState.categories, vm.saveFilterCategories)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              // TODO: apply filter
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final FilterState filterState;
  final void Function(List<Filter>, int index) savePostTypes, saveSortType;
  final void Function(List<Category>, int index) saveFilterCategories;

  _ViewModel({
    @required this.filterState,
    @required this.savePostTypes,
    @required this.saveSortType,
    @required this.saveFilterCategories,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      filterState: store.state.filterState,
      savePostTypes: (List<Filter> postTypes, int index) =>
          store.dispatch(SaveFilterPostTypesAction(postTypes, index)),
      saveSortType: (List<Filter> sortTypes, int index) =>
          store.dispatch(SaveFilterSortTypeAction(sortTypes, index)),
      saveFilterCategories: (List<Category> categories, int index) =>
          store.dispatch(SaveFilterCategoriesAction(categories, index)),
    );
  }
}
