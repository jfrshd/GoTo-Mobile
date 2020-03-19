import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/models/region.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/redux/actions/region_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/region_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:redux/redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../api.dart';
import 'ErrorPage.dart';

class ChooseRegionsPage extends StatefulWidget {
  @override
  _ChooseRegionsPageState createState() => _ChooseRegionsPageState();
}

class _ChooseRegionsPageState extends State<ChooseRegionsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(converter: (store) {
      return _ViewModel.fromStore(store);
    }, builder: (BuildContext context, _ViewModel vm) {
      if (vm.regionState.failLoad || vm.regionState.errorLoad)
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: createAppBar(),
            body: ErrorPage(
                vm.regionState.failLoad
                    ? Constants.regionsFail
                    : Constants.regionsError,
                vm.fetchRegions));

      if (vm.regionState.failUpdate || vm.regionState.errorUpdate)
        showError(vm.regionState.failUpdate ? 'Fail' : 'Error');

      List<Widget> regionsImgWidgets = new List<Widget>();

      vm.regionState.regions.forEach((region) {
        return regionsImgWidgets.add(SvgPicture(
          AdvancedNetworkSvg(
            API.serverAddress +
                "/" +
                (region.selected
                    ? region.svg.replaceFirst('.svg', '_selected.svg')
                    : region.svg),
            SvgPicture.svgByteDecoder,
            useDiskCache: true,
          ),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 2.5,
        ));
      });

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: createAppBar(),
        body: vm.regionState.loading
            ? Center(
                child: ColorLoader4(
                    color1: Colors.blue,
                    color2: Colors.blue[300],
                    color3: Colors.blue[100]))
            : Container(
                height: double.infinity,
                child: Builder(
                    builder: (context) => Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Stack(
                                    children: regionsImgWidgets,
                                  )),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: vm.regionState.regions.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: index ==
                                                vm.regionState.regions.length -
                                                    1
                                            ? EdgeInsets.only(bottom: 70)
                                            : null,
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                vm.regionState.regions[index]
                                                        .selected =
                                                    !vm
                                                        .regionState
                                                        .regions[index]
                                                        .selected;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child: ListTile(
                                                  title: Text(vm.regionState
                                                      .regions[index].name),
                                                  trailing: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    height: 30,
                                                    width: 30,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: vm
                                                              .regionState
                                                              .regions[index]
                                                              .selected
                                                          ? Icon(
                                                              Icons.star,
                                                              size: 30.0,
                                                              color:
                                                                  Colors.blue,
                                                            )
                                                          : Icon(
                                                              Icons.star_border,
                                                              size: 30.0,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    ),
                                                  ),
                                                ))),
                                      );
                                    }))
                          ],
                        ))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            if (vm.regionState.regions
                    .where((r) => r.selected)
                    .toList()
                    .length >=
                1) {
              vm.saveRegions(vm.regionState.regions, context);
            } else {
              showChooseAtLeastOne();
            }
          },
          child: vm.regionState.updating
              ? SizedBox.fromSize(
                  size: Size(20, 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  ),
                )
              : Icon(Icons.check),
        ),
      );
    });
  }

  AppBar createAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: Text('Regions'),
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
                    desc: Constants.regionsPageDesc)
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

  void showNoInternet() {
    final snackBar = SnackBar(
      content: Text(Constants.noInternet),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showChooseAtLeastOne() {
    final snackBar = SnackBar(
      content: Text(Constants.atLeastOne),
        duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  setFirstTimeFalse() async {
      await SharedPreferencesHelper.setBool(Constants.firstTimeCode, false);
  }
}

class _ViewModel {
    final bool isFirstLaunch;
    final RegionState regionState;
    final void Function() fetchRegions;
    final void Function(List<Region>, BuildContext) saveRegions;
    final void Function() toggleFirstTime;

    _ViewModel({
        @required this.isFirstLaunch,
        @required this.regionState,
        @required this.fetchRegions,
        @required this.saveRegions,
        @required this.toggleFirstTime,
    });

    static _ViewModel fromStore(Store<AppState> store) {
        return _ViewModel(
            isFirstLaunch: store.state.account.isFirstLaunch,
            regionState: store.state.regionState,
            fetchRegions: () => store.dispatch(fetchRegionsAction()),
            saveRegions: (List<Region> regions, BuildContext context) =>
                store.dispatch(saveRegionsAction(regions, context)),
            toggleFirstTime: () =>
                store.dispatch(ToggleFirstLaunchAction(false)),
        );
    }
}
