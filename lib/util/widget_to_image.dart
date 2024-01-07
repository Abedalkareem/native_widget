import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class WidgetToImage {
  ///
  /// Convert the given widget to an image.
  ///
  /// More info:
  /// https://github.com/flutter/flutter/issues/40064
  ///
  static Future<Uint8List?> dataFromWidget(
    Widget widget, {
    required BuildContext context,
    Alignment alignment = Alignment.center,
    Duration? wait,
    Size size = const Size(double.maxFinite, double.maxFinite),
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0,
  }) async {
    final repaintBoundary = RenderRepaintBoundary();

    final renderView = RenderView(
      view: View.of(context),
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: devicePixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        )).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }
}
