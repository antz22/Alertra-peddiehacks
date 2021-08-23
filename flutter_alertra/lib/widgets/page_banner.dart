import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';

class PageBanner extends StatelessWidget {
  const PageBanner({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor,
            Color(0xFF567EFF),
          ],
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 0.12 * MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
