import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/models/branch.dart';
import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';
import 'package:gotomobile/widgets/post/PostBodyImages.dart';
import 'package:gotomobile/widgets/post/PostFooter.dart';
import 'package:gotomobile/widgets/post/PostHeader.dart';

class PostItem extends StatelessWidget {
	final int index;
  final Post post;
  final void Function(int, Shop, BuildContext) selectShop;

  PostItem(this.index, this.post, this.selectShop);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        color: Color(0xEEFFFFFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
				padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
				child: PostHeader(index, post, selectShop),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: post.description),
                    new TextSpan(
                        text: " ~Available at ",
                        style: TextStyle(color: Colors.grey[600])),
                    ...displayBranches(post.targetBranches, context),
                  ],
                ),
              ),
            ),
            post.images.length == 0
                ? Container()
                : PostBodyImages(
                    post.shop.name,
                    post.description,
                    post.images,
                  ),
            PostFooter(post.dateStart, post.dateEnd)
          ],
        ));
  }

  void showSimpleCustomDialog(BuildContext context, Branch branch) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                branch.name,
                style: TextStyle(color: Colors.red, fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      GlobalMethods.openMap(branch.cdx, branch.cdy);
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      GlobalMethods.call(branch.phone);
                    },
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  displayBranches(List<Branch> targetBranches, context) {
    final style = TextStyle(color: Colors.grey[600]);
    if (targetBranches.length == 1) {
      return [
        TextSpan(
            text: targetBranches[0].name + ".",
            style: style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showSimpleCustomDialog(context, targetBranches[0]);
              })
      ];
    } else if (targetBranches.length == 2) {
      return [
        TextSpan(
            text: targetBranches[0].name + " and ",
            style: style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showSimpleCustomDialog(context, targetBranches[0]);
              }),
        TextSpan(
            text: targetBranches[1].name + ".",
            style: style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showSimpleCustomDialog(context, targetBranches[1]);
              })
      ];
    } else {
      return post.targetBranches.asMap().entries // in-order to have index
          .map((entry) {
        int index = entry.key;
        Branch branch = entry.value;
        return TextSpan(
            text:
                index == post.targetBranches.length - 1 // last item put . not ,
                    ? "and " + branch.name + "."
                    : branch.name + ", ",
            style: TextStyle(color: Colors.grey[600]),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showSimpleCustomDialog(context, branch);
              });
      }).toList();
    }
  }
}
