import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_widget_example/off_topic/app_button.dart';
import 'package:simple_widget/simple_widget.dart';

class GameWidgetExample extends StatefulWidget {
  const GameWidgetExample({super.key});

  @override
  State<GameWidgetExample> createState() => _GameWidgetExampleState();
}

class _GameWidgetExampleState extends State<GameWidgetExample> {
  final _simpleWidgetPlugin = SimpleWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game widget example'),
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
    const timelineID = "4";

    final allTimelines = await _simpleWidgetPlugin.getTimelinesData();

    final firstTimeline = await _getTimeline(timelineID);
    allTimelines.add(
        TimeLine(type: "Game Widget", id: timelineID, data: firstTimeline));
    await _simpleWidgetPlugin.updateWidgets(
      allTimelines,
    );
    await _simpleWidgetPlugin.refresh();
  }

  Future<List<AppWidgetData>> _getTimeline(String id) async {
    final background = await colorBackground();
    final foreground1 = await forground("0 Lives");
    final foreground2 = await forground("1 Lives");
    final foreground3 = await forground("2 Lives");
    final fullForeground = await fullLivesForground();
    final date = DateTime.now();
    return [
      AppWidgetData(
        date
            .add(const Duration(minutes: 0))
            .millisecondsSinceEpoch, //  at least one widget should be created with the current time.
        id,
        background,
        foreground1,
      ),
      AppWidgetData(
        date.add(const Duration(minutes: 30)).millisecondsSinceEpoch,
        id,
        background,
        foreground2,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 1)).millisecondsSinceEpoch,
        id,
        background,
        foreground3,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 1, minutes: 30)).millisecondsSinceEpoch,
        id,
        background,
        fullForeground,
      )
    ];
  }

  Future<String> colorBackground() async {
    final background = await WidgetToImage.dataFromWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 500,
          height: 250,
          child: Container(
            color: Colors.red,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: "04B03",
                  ),
                ),
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

  Future<String> fullLivesForground() async {
    final background = await WidgetToImage.dataFromWidget(
      const SizedBox(
        width: 700,
        height: 250,
        child: Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "You have full lives!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "04B03",
                    ),
                  ),
                ),
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      context: context,
      size: const Size(700, 250),
    );
    String base64Image = base64Encode(background!);
    return base64Image;
  }
}
