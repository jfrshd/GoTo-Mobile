import 'package:flutter/material.dart';
import 'package:gotomobile/models/branch.dart';
import 'package:gotomobile/utils/ExternalApps.dart';

class BranchItem extends StatelessWidget {
  final int index;
  final Branch branch;

  BranchItem(this.index, this.branch);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      branch.name,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      branch.phone,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    ExternalApps.openMap(branch.cdx, branch.cdy);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    ExternalApps.call(branch.phone);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
