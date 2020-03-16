import 'package:flutter/material.dart';
import 'package:gotomobile/widgets/Filter/CategoriesCard.dart';
import 'package:gotomobile/widgets/Filter/PostTypeCard.dart';
import 'package:gotomobile/widgets/Filter/SortCard.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: PostTypeCard()),
          SliverToBoxAdapter(child: SortCard()),
          SliverToBoxAdapter(child: CategoriesCard()),
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
  }
}
