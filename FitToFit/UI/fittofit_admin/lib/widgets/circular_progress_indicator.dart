import 'package:flutter/material.dart';
import 'package:image/image.dart';

class MyProgressIndicator extends StatefulWidget {
  final double? width;
  final double? height;
  final double? strokeWidth;

  const MyProgressIndicator({
    Key? key,
    this.height,
    this.width,
    this.strokeWidth,
  }) : super(key: key);

  @override
  State<MyProgressIndicator> createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth ?? 4,
          color: Colors.blue
        ),
      ),
    );
  }
}