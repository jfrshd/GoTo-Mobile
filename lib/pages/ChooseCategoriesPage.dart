import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:redux/redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../api.dart';

class ChooseCategoriesPage extends StatefulWidget {
  @override
  _ChooseCategoriesPageState createState() => _ChooseCategoriesPageState();
}

class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isFirstLaunch = true;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
	  return StoreConnector<AppState, _ViewModel>(
		  converter: (store) {
			  return _ViewModel.fromStore(store);
		  },
		  builder: (BuildContext context, _ViewModel vm) {
			  if (_isFirstLaunch) {
				  checkFirstTime();
			  }
			  if (vm.fail || vm.error)
				  return Scaffold(
					  key: _scaffoldKey,
					  backgroundColor: Colors.white,
					  appBar: createAppBar(),
					  body: ErrorPage(
						  vm.fail
							  ? Constants.categoriesFail
							  : Constants.categoriesError,
						  vm.fetchCategories));

			  return Scaffold(
				  key: _scaffoldKey,
				  backgroundColor: Colors.white,
				  appBar: createAppBar(),
				  body: vm.loading
					  ? Center(
					  child: ColorLoader4(
						  color1: Colors.blue,
						  color2: Colors.blue[300],
						  color3: Colors.blue[100]))
					  : ListView.builder(
					  padding: EdgeInsets.all(1),
					  itemCount: vm.categories.length,
					  itemBuilder: (BuildContext context, int index) {
						  return Container(
							  margin: index == vm.categories.length - 1
								  ? EdgeInsets.only(bottom: 70)
								  : null,
							  child: InkWell(
								  onTap: () {
									  setState(() {
										  vm.categories[index].selected =
										  !vm.categories[index].selected;
									  });
								  },
								  child: Container(
									  decoration: !vm.categories[index].selected
										  ? BoxDecoration(color: Colors.white)
										  : BoxDecoration(
										  color:
										  Color.fromRGBO(64, 128, 255, 0.2)),
									  child: ListTile(
										  title: Text(vm.categories[index]
											  .name),
										  trailing: Container(
											  /* decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),*/
											  height: 30,
											  width: 30,
											  child: Padding(
												  padding: const EdgeInsets.all(
													  0.0),
												  child: vm.categories[index]
													  .selected
													  ? Icon(
													  Icons.star,
													  size: 30.0,
													  color: Colors.blue,
												  )
													  : Icon(
													  Icons.star_border,
													  size: 30.0,
													  color: Colors.blue,
												  ),
											  ),
										  ),
										  leading: vm.categories[index]
											  .thumbnail ==
											  null
											  ? SizedBox.fromSize(
											  size: Size(40, 40),
											  child: Container(),
										  )
											  : SizedBox.fromSize(
											  size: Size(40, 40),
											  child: SvgPicture.network(
												  API.serverAddress +
													  "/" +
													  vm.categories[index]
														  .thumbnail,
												  placeholderBuilder: (
													  context) =>
													  CircularProgressIndicator(),
											  ),
										  ),
									  ))),
						  );
					  }),
				  floatingActionButton: vm.categories.isEmpty
					  ? null
					  : FloatingActionButton(
					  backgroundColor: Colors.blue,
					  onPressed: () {
//                              checkConnectivity();
						  if (vm.categories
							  .where((c) => c.selected)
							  .toList()
							  .length >=
							  3) {
//                        saveCategories();
						  } else {
							  showChooseAtLeastThree();
						  }
					  },
					  child: Icon(
						  _isFirstLaunch ? Icons.arrow_forward : Icons.check)));
		  },
	  );
  }

  AppBar createAppBar() {
	  return AppBar(
		  automaticallyImplyLeading: false,
		  centerTitle: true,
		  title: Text('Favorites'),
		  actions: <Widget>[
			  IconButton(
				  onPressed: () {
					  Alert(
						  image: Image.asset('assets/images/info.png'),
						  title: "",
						  buttons: [],
						  context: context,
//                        type: AlertType.none,
						  style: AlertStyle(
							  animationType: AnimationType.grow,
							  titleStyle: TextStyle(fontSize: 0),
							  isCloseButton: false,
							  backgroundColor: Colors.blue,
							  descStyle: TextStyle(
								  color: Colors.white,
								  fontSize: 15,
								  fontStyle: FontStyle.italic,
							  )),
						  desc: Constants.categoriesPageDesc)
						  .show();
				  },
				  icon: Icon(Icons.info),
			  ),
		  ],
	  );
  }

//  void loadCategories() {
//    setState(() {
//      _loadingCategories = true;
//      _error = false;
//    });
//    getCategories().then((response) {
//      final parsed = Map<String, dynamic>.from(json.decode(response.body));
//      if (parsed["status"] == "success") {
//        final categories = parsed['categories']
//            .map<Category>((json) => Category.fromJson(json))
//            .toList();
//        setState(() {
//          _error = false;
//          _loadingCategories = false;
//          _categories = categories;
//        });
//      } else if (parsed["status"] == "fail") {
//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
//      } else if (parsed["status"] == "error") {
//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
//      }
//    }).catchError((e) {
//      print("getCategories error: ");
//      print(e);
//      setState(() {
//        _error = true;
//        _loadingCategories = false;
//      });
//    });
//  }

//  void saveCategories() {
//    updateSelectedCategories(_categories
//            .where((category) => category.selected)
//            .map<int>((category) => category.id)
//            .toList())
//        .then((response) {
//      final parsed = Map<String, dynamic>.from(json.decode(response.body));
//      if (parsed["status"] == "success") {
//        if (_isFirstLaunch) {
//          Navigator.pushReplacementNamed(context, Routes.regionsRoute);
//        } else {
//          Navigator.pop(context);
//        }
//      } else {
//        showError("Failed");
//      }
//    }).catchError((e) {
//      print("saveCategories error: ");
//      print(e);
//      showError("Failed");
//    });
//  }

	void showError(String e) {
		final snackBar = SnackBar(
			content: Text(e),
			duration: Duration(seconds: 2),
		);
		_scaffoldKey.currentState.showSnackBar(snackBar);
	}

	void showChooseAtLeastThree() {
    final snackBar = SnackBar(
      content: Text(Constants.atLeastThree),
      duration: Duration(seconds: 2),
	);
	_scaffoldKey.currentState.showSnackBar(snackBar);
	}

	void checkFirstTime() async {
		_isFirstLaunch =
		await SharedPreferencesHelper.getBool(Constants.firstTimeCode);
	}
}

class _ViewModel {
	final bool loading;
	final bool fail;
	final bool error;
	final List<Category> categories;
	final void Function() fetchCategories;

	_ViewModel({
		@required this.loading,
		@required this.fail,
		@required this.error,
		@required this.categories,
		@required this.fetchCategories,
	});

	static _ViewModel fromStore(Store<AppState> store) {
		return _ViewModel(
			loading: store.state.categoryState.loading,
			fail: store.state.categoryState.fail,
			error: store.state.categoryState.error,
			categories: store.state.categoryState.categories,
			fetchCategories: () => store.dispatch(fetchCategoriesAction()),
		);
	}
}
