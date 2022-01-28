import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DraggableLightBulb extends StatefulWidget {
  final Offset initialOffset;
  final VoidCallback onPressed;
  final bool isLitUp;

  DraggableLightBulb({
    Key key,
    @required this.initialOffset,
    @required this.onPressed,
    @required this.isLitUp,
  }) : super(key: key);

  @override
  _DraggableLightBulbState createState() => _DraggableLightBulbState();
}

class _DraggableLightBulbState extends State<DraggableLightBulb> {
  bool _isDragging = false;
  Offset _offset;

  Duration pointerDownTime;

  Rect visibleBounds;

  VisibilityDetectorController _visibilityDetectorController =
      VisibilityDetectorController();

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double xChange = pointerMoveEvent.delta.dx;
    double yChange = pointerMoveEvent.delta.dy;

    double newOffsetX = _offset.dx + xChange;
    double newOffsetY = _offset.dy + yChange;

    if (checkMovable(xChange, yChange)) {
      {
        setState(() {
          _offset = Offset(newOffsetX, newOffsetY);
        });
      }
    }
  }

  bool checkMovable(double xChange, double yChange) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.width * 0.12;

    _visibilityDetectorController.notifyNow();

    if (visibleBounds.left > 0 && xChange < 0) {
      return false;
    } else if (visibleBounds.top > 0 && yChange < 0) {
      return false;
    } else if (visibleBounds.right < iconSize - 0.1 && xChange > 0) {
      return false;
    } else if (visibleBounds.bottom < iconSize - 0.1 && yChange > 0) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Listener(
        onPointerDown: (PointerDownEvent pointerDownEvent) {
          pointerDownTime = pointerDownEvent.timeStamp;
        },
        onPointerMove: (PointerMoveEvent pointerMoveEvent) {
          if (pointerMoveEvent.timeStamp.inMilliseconds >
              pointerDownTime.inMilliseconds + 100) {
            {
              setState(() {
                _isDragging = true;
              });
              _updatePosition(pointerMoveEvent);
            }
          }
        },
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          if (_isDragging) {
            setState(() {
              _isDragging = false;
            });
          } else {
            widget.onPressed();
          }
        },
        child: VisibilityDetector(
          key: Key('visibility'),
          onVisibilityChanged: (visibilityInfo) {
            visibleBounds = visibilityInfo.visibleBounds;
          },
          child: Icon(
            widget.isLitUp
                ? FontAwesomeIcons.solidLightbulb
                : FontAwesomeIcons.lightbulb,
            color: Colors.white,
            size: _isDragging ? size.width * 0.12 : size.width * 0.1,
          ),
        ),
      ),
    );
  }
}
