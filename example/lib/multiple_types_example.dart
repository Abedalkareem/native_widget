import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_widget/simple_widget.dart';

import 'off_topic/app_button.dart';

class MultipleTypesExample extends StatefulWidget {
  const MultipleTypesExample({super.key});

  @override
  State<MultipleTypesExample> createState() => _MultipleTypesExampleState();
}

class _MultipleTypesExampleState extends State<MultipleTypesExample> {
  final _simpleWidgetPlugin = SimpleWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple types example'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: () async {
                _updateWidgets();
              },
              text: "Add Widgets",
            ),
            AppButton(
              onPressed: () async {
                _refreshWidgets();
              },
              text: "Refresh Widgets",
            ),
          ],
        )),
      ),
    );
  }

  void _refreshWidgets() async {
    await _simpleWidgetPlugin.refresh();
  }

  Future<void> _updateWidgets() async {
    const firstTimelineID = "1";
    const secondTimelineID = "2";

    final allTimelines = await _simpleWidgetPlugin.getTimelinesData();

    final firstTimeline = await _getFirstTimeline(firstTimelineID);
    final secondTimeline = await _getSecondTimeline(secondTimelineID);

    allTimelines.addAll([
      TimeLine(type: "Images", id: firstTimelineID, data: firstTimeline),
      TimeLine(type: "Color", id: secondTimelineID, data: secondTimeline),
    ]);
    await _simpleWidgetPlugin.updateWidgets(allTimelines);
    await _simpleWidgetPlugin.refresh();
  }

  Future<List<AppWidgetData>> _getFirstTimeline(String id) async {
    final background1 = await imageBackground("assets/images/cat.png");
    final foreground1 = await forground("Simple Widget");
    final background2 = await imageBackground("assets/images/city.png");
    final foreground2 = await forground("Hello Flutter");
    final background3 = await imageBackground("assets/images/green.png");
    final foreground3 = await forground("Hello World");
    final date = DateTime.now();
    return [
      AppWidgetData(
        date
            .add(const Duration(hours: 0))
            .millisecondsSinceEpoch, //  at least one widget should be created with the current time.
        id,
        background1,
        foreground1,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        id,
        background2,
        foreground2,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 3)).millisecondsSinceEpoch,
        id,
        background3,
        foreground3,
      )
    ];
  }

  Future<List<AppWidgetData>> _getSecondTimeline(String id) async {
    final background1 = await colorBackground(Colors.red);
    final foreground1 = await forground("Simple Widget");
    final background2 = await colorBackground(Colors.blue);
    final foreground2 = await forground("Hello Flutter");
    final background3 = await colorBackground(Colors.green);
    final foreground3 = await forground("Hello World");
    final date = DateTime.now();
    return [
      AppWidgetData(
        date
            .add(const Duration(minutes: 0))
            .millisecondsSinceEpoch, //  at least one widget should be created with the current time.
        id,
        background1,
        foreground1,
      ),
      AppWidgetData(
        date.add(const Duration(minutes: 35)).millisecondsSinceEpoch,
        id,
        background2,
        foreground2,
      ),
      AppWidgetData(
        date.add(const Duration(minutes: 70)).millisecondsSinceEpoch,
        id,
        background3,
        foreground3,
      )
    ];
  }

  Future<String> imageBackground(String image) async {
    final background = await WidgetToImage.dataFromWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 500,
          height: 250,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              )
            ],
          ),
        ),
      ),
      context: context,
      size: const Size(500, 250),
      wait: const Duration(seconds: 1),
    );
    String base64Image = base64Encode(background!);

    return base64Image;
  }

  Future<String> colorBackground(Color color) async {
    final background = await WidgetToImage.dataFromWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 500,
          height: 250,
          child: Container(
            color: color,
            width: 500,
            height: 250,
          ),
        ),
      ),
      context: context,
      size: const Size(500, 250),
    );
    String base64Image = base64Encode(background!);

    return base64Image;
  }

  Future<String> forground(String text) async {
    final background = await WidgetToImage.dataFromWidget(
      SizedBox(
        width: 500,
        height: 250,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: "Michelia",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      size: const Size(500, 250),
    );
    String base64Image = base64Encode(background!);
    return base64Image;
  }
}
