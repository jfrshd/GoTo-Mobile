import 'package:flutter/material.dart';
import 'package:gotomobile/widgets/drawer/drawerItem.dart';

import '../../routes.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          Opacity(
            opacity: 1,
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  "GoTo",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "ibdaa.leb@outlook.com",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DrawerItem("Categories", Icons.view_list, Routes.categoriesRoute),
          DrawerItem("Regions", Icons.explore, Routes.regionsRoute),
          DrawerItem("About us", Icons.info, Routes.aboutUs),
        ],
      ),
    );
  }
}
