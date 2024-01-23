import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    this.height = Dimens.shimmerHeightMedium,
    this.radius = Dimens.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(radius))),
      ),
    );
  }
}