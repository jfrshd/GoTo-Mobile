import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/category_state.dart';
import 'package:gotomobile/utils/Constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ViewModel vm) {
        if (vm.categoryState.failLoad || vm.categoryState.errorLoad)
          return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: createAppBar(),
              body: ErrorPage(
                  vm.categoryState.failLoad
                      ? Constants.categoriesFail
                      : Constants.categoriesError,
                  vm.fetchCategories));

        if (vm.categoryState.failUpdate || vm.categoryState.errorUpdate)
          showError(vm.categoryState.failUpdate ? 'Fail' : 'Error');

        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: createAppBar(),
            body: vm.categoryState.loading
                ? Center(
                    child: ColorLoader4(
                        color1: Colors.blue,
                        color2: Colors.blue[300],
                        color3: Colors.blue[100]))
                : ListView.builder(
                    padding: EdgeInsets.all(1),
                    itemCount: vm.categoryState.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: index == vm.categoryState.categories.length - 1
                            ? EdgeInsets.only(bottom: 70)
                            : null,
                        child: InkWell(
                            onTap: () {
                              vm.categoryState.categories[index].selected =
                                  !vm.categoryState.categories[index].selected;
                              setState(() {});
                            },
                            child: Container(
                                decoration: !vm.categoryState.categories[index]
                                        .selected
                                    ? BoxDecoration(color: Colors.white)
                                    : BoxDecoration(
                                        color:
                                            Color.fromRGBO(64, 128, 255, 0.2)),
                                child: ListTile(
                                  title: Text(
                                      vm.categoryState.categories[index].name),
                                  trailing: Container(
                                    /* decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),*/
                                    height: 30,
                                    width: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: vm.categoryState.categories[index]
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
                                  leading: vm.categoryState.categories[index]
                                              .thumbnail ==
                                          null
                                      ? SizedBox.fromSize(
                                          size: Size(40, 40),
                                          child: Container(),
                                        )
                                      : SizedBox.fromSize(
                                          size: Size(40, 40),
                                          child: SvgPicture(
                                            AdvancedNetworkSvg(
                                                API.serverAddress +
                                                    "/" +
                                                    vm
                                                        .categoryState
                                                        .categories[index]
                                                        .thumbnail,
                                                SvgPicture.svgByteDecoder,
                                                useDiskCache: true),
                                            placeholderBuilder: (context) =>
                                                CircularProgressIndicator(),
                                          ),
                                        ),
                                ))),
                      );
                    }),
            floatingActionButton: vm.categoryState.categories.isEmpty
                ? null
                : FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
//                              checkConnectivity();
                      if (vm.categoryState.categories
                              .where((c) => c.selected)
                              .toList()
                              .length >=
                          3) {
                        vm.saveCategories(vm.categoryState.categories, context);
                      } else {
                        showChooseAtLeastThree();
                      }
                    },
                    child: vm.categoryState.updating
                        ? SizedBox.fromSize(
                            size: Size(20, 20),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Icon(vm.isFirstLaunch
                            ? Icons.arrow_forward
                            : Icons.check),
                  ));
      },
    );
  }

  AppBar createAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      // TODO: "Favorites" aw "Categories" 🤔 since the regions page title is "Regions"
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
}

class _ViewModel {
	final bool isFirstLaunch;
	final CategoryState categoryState;
	final void Function() fetchCategories;
	final void Function(List<Category>, BuildContext) saveCategories;

	_ViewModel({
		@required this.isFirstLaunch,
		@required this.categoryState,
		@required this.fetchCategories,
		@required this.saveCategories,
	});

	static _ViewModel fromStore(Store<AppState> store) {
		return _ViewModel(
			isFirstLaunch: store.state.account.isFirstLaunch,
			categoryState: store.state.categoryState,
			fetchCategories: () => store.dispatch(fetchCategoriesAction()),
			saveCategories: (List<Category> categories, BuildContext context) =>
				store.dispatch(saveCategoriesAction(categories, context)),
		);
	}
}
