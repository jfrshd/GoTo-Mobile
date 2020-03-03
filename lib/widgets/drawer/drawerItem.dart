import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final String route;

  DrawerItem(this.text, this.icon, this.route);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListTile(
          leading: Icon(icon),
          title: Text(text),
          onTap: () {
            Navigator.of(context).pop();
            /*  Navigator.push(
                          context, SlideRoute(page: ChooseCategoriesPage()));*/
            Navigator.pushNamed(context, route);
          },
        ));
  }
}
