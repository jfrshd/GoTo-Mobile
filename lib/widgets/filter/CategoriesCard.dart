import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/category_state.dart';
import 'package:gotomobile/widgets/Filter/CategoriesCardGridItem.dart';
import 'package:redux/redux.dart';

class CategoriesCard extends StatefulWidget {
  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
		final orientation = MediaQuery
			.of(context)
			.orientation;
		return StoreConnector<AppState, _ViewModel>(converter: (store) {
			return _ViewModel.fromStore(store);
		}, builder: (BuildContext context, _ViewModel vm) {
			return Container(
				margin: const EdgeInsets.only(top: 5),
				padding: const EdgeInsets.all(10),
				color: Colors.white,
				child: Center(
					child: Column(children: <Widget>[
						Container(
							margin: EdgeInsets.only(bottom: 10),
							child: Text(
								'Categories',
								style: TextStyle(fontSize: 20),
							),
						),
						Container(
							width: MediaQuery
								.of(context)
								.size
								.width,
							child: GridView.builder(
								shrinkWrap: true,
								physics: ScrollPhysics(),
								gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount:
									(orientation == Orientation.portrait)
										? 3
										: 4),
								itemCount: vm.categoryState.categories.length,
								itemBuilder: (BuildContext context, int index) {
									return GestureDetector(
										onTap: () {
											setState(() {
												vm.categoryState
													.categories[index]
													.selected =
												!vm.categoryState
													.categories[index].selected;
											});
										},
										child: CategoriesCardGridItem(
											vm.categoryState
												.categories[index]));
								},
							),
						),
					]),
				),
			);
		});
	}

	onTap(int index) {}
}

class _ViewModel {
	final CategoryState categoryState;
	final void Function() fetchCategories;

	_ViewModel({
		@required this.categoryState,
		@required this.fetchCategories,
	});

	static _ViewModel fromStore(Store<AppState> store) {
		return _ViewModel(
			categoryState: store.state.categoryState,
			fetchCategories: () => store.dispatch(fetchCategoriesAction()),
		);
	}
}
