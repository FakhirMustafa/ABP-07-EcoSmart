import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinearArrowsActionLogout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 17.3,
          height: 26.7,
          child: SvgPicture.asset(
            'assets/vectors/vector_2_x2.svg',
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 3.3, 0, 3.3),
          child: SizedBox(
            width: 6.7,
            height: 20,
            child: SvgPicture.asset(
              'assets/vectors/container_x2.svg',
            ),
          ),
        ),
      ],
    );
  }
}