import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PlatformAwareAssetImage extends StatelessWidget {
  const PlatformAwareAssetImage(
  {
    required this.asset,
    this.package,
    required this.width,
    required this.height,
  }) : super();

  final String asset;
  final String? package;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        'assets/${package == null ? '' : 'packages/$package/'}$asset',
        width: width,
        height: height,
      );
    }

    return Image.asset(
      asset,
      package: package,
      width: width,
      height: height,
    );
  }
}