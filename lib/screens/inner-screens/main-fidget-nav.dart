import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:fidget_tool/models/settings-model.dart';

import 'package:fidget_tool/screens/fidget-widgets/all-fidget-widgets.dart';
import 'package:fidget_tool/widgets/widgets.dart';

class FidgetNav extends StatefulWidget {
  FidgetNav({Key key}) : super(key: key);

  @override
  State<FidgetNav> createState() => _FidgetNavState();
}

class _FidgetNavState extends State<FidgetNav> with TickerProviderStateMixin {
  TabController _tabController;

  bool _isCoverVisible;

  int widgetCount = FidgetWidget.values.length;

  List<Widget> _children() {
    return FidgetWidget.values.map((e) => e.getWidget()).toList();
  }

  List<IconData> _fidgetIcons() {
    return FidgetWidget.values.map((e) => e.getIcon()).toList();
  }

  @override
  void initState() {
    super.initState();
    _isCoverVisible = false;

    _tabController = TabController(length: widgetCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsModel = context.read<SettingsModel>();
    return SafeArea(
      child: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: List.generate(widgetCount, (i) => _children()[i]),
          ),
          Align(
            alignment: Alignment(0, -0.7),
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                //labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 6),
                indicator: BoxDecoration(
                  //color: Colors.red,
                  color: Colors.grey[350].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                enableFeedback: true,
                tabs: List.generate(
                  widgetCount,
                  (i) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: Tab(
                      child: Icon(_fidgetIcons()[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlackCover(
            isCoverVisible: _isCoverVisible,
          ),
          Visibility(
            visible: settingsModel.hasBulb,
            child: DraggableLightBulb(
              initialOffset: Offset(10, 10),
              onPressed: () {
                setState(() {
                  _isCoverVisible = !_isCoverVisible;
                });
              },
              isLitUp: !_isCoverVisible,
            ),
          ),
        ],
      ),
    );
  }
}

enum FidgetWidget { scroller, drag, button }

extension Info on FidgetWidget {
  Widget getWidget() {
    switch (this) {
      case FidgetWidget.scroller:
        return FidgetScroller();
      case FidgetWidget.drag:
        return FidgetDrag();
      case FidgetWidget.button:
        return FidgetButton();

      default:
        throw ('Invalid Widget');
    }
  }

  IconData getIcon() {
    switch (this) {
      case FidgetWidget.scroller:
        return FontAwesomeIcons.bars;
      case FidgetWidget.drag:
        return Icons.add;
      case FidgetWidget.button:
        return Icons.radio_button_on;

      default:
        throw ('Invalid Widget');
    }
  }
}
