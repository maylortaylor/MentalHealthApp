import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PlatformAwareAssetImage extends StatelessWidget {
  const PlatformAwareAssetImage(
  {
    required this.asset,
    this.package,
    required this.width,
    required this.height,
    this.fit
  }) : super();

  final String asset;
  final String? package;
  final double width;
  final double height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    // if (kIsWeb) {
    //   return Image.network(
    //     'assets/${package == null ? '' : 'packages/$package/'}$asset',
    //     width: width,
    //     height: height,
    //   );
    // }

    // return Image.asset(
    return Image.network(
      // asset,
      // 'assets/$asset',
      'assets/assets/$asset',
      // package: package,
      width: width,
      height: height,
      fit: fit,
    );
  }
}