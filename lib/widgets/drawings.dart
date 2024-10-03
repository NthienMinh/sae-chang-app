import 'package:flutter/material.dart';

/// Drawings canvas. Controller is required, other parameters are optional.
/// widget/canvas expands to maximum by default.
/// this behaviour can be overridden using width and/or height parameters.
class Drawings extends StatefulWidget {
  /// constructor
  const Drawings({
    required this.controller,
    Key? key,
    this.backgroundColor = Colors.grey,
    required this.width,
    required this.height,
  }) : super(key: key);

  /// Drawings widget controller
  final DrawingsController controller;

  /// Drawings widget width
  final double width;

  /// Drawings widget height
  final double height;

  /// Drawings widget background color
  final Color backgroundColor;

  @override
  State createState() => DrawingsState();
}

/// Drawings widget state
class DrawingsState extends State<Drawings> {
  /// Helper variable indicating that user has left the canvas so we can prevent linking next point
  /// with straight line.
  bool _isOutsideDrawField = false;

  /// Active pointer to prevent multitouch drawing
  int? activePointerId;

  @override
  Widget build(BuildContext context) {
    final double maxWidth = widget.width ;
    final double maxHeight = widget.height;
    final drawingCanvas = Container(
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: Listener(
          onPointerDown: (PointerDownEvent event) {
            if (activePointerId == null || activePointerId == event.pointer) {
              activePointerId = event.pointer;
              _addPoint(event, PointType.tap);
            }
          },
          onPointerUp: (PointerUpEvent event) {
            if (activePointerId == event.pointer) {
              _addPoint(event, PointType.tap);
              activePointerId = null;
            }
          },
          onPointerCancel: (PointerCancelEvent event) {
            if (activePointerId == event.pointer) {
              _addPoint(event, PointType.tap);
              activePointerId = null;
            }
          },
          onPointerMove: (PointerMoveEvent event) {
            if (activePointerId == event.pointer) {
              _addPoint(
                event,
                PointType.move,
              );
            }
          },
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _DrawingsPainter(
                controller: widget.controller,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: maxWidth,
                    minHeight: maxHeight,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight),
              ),
            ),
          )),
    );

    if (widget.width != null || widget.height != null) {
      //IF DOUNDARIES ARE DEFINED, USE LIMITED BOX
      return Center(
        child: LimitedBox(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          child: drawingCanvas,
        ),
      );
    } else {
      //IF NO BOUNDARIES ARE DEFINED, USE EXPANDED
      return Expanded(child: drawingCanvas);
    }
  }

  void _addPoint(PointerEvent event, PointType type) {
    final Offset o = event.localPosition;
    //SAVE POINT ONLY IF IT IS IN THE SPECIFIED BOUNDARIES
    if ((o.dx > 0 && o.dx < widget.width) &&
        (o.dy > 0 && o.dy < widget.height)) {
      // IF USER LEFT THE BOUNDARY AND AND ALSO RETURNED BACK
      // IN ONE MOVE, RETYPE IT AS TAP, AS WE DO NOT WANT TO
      // LINK IT WITH PREVIOUS POINT

      PointType t = type;
      if (_isOutsideDrawField) {
        t = PointType.tap;
      }
      setState(() {
        //IF USER WAS OUTSIDE OF CANVAS WE WILL RESET THE HELPER VARIABLE AS HE HAS RETURNED
        _isOutsideDrawField = false;
        widget.controller.addPoint(Point(o, t), event);
      });
    } else {
      //NOTE: USER LEFT THE CANVAS!!! WE WILL SET HELPER VARIABLE
      //WE ARE NOT UPDATING IN setState METHOD BECAUSE WE DO NOT NEED TO RUN BUILD METHOD
      _isOutsideDrawField = true;
    }
  }
}

/// type of user display finger movement
enum PointType {
  /// one touch on specific place - tap
  tap,

  /// finger touching the display and moving around
  move,
}

/// one point on canvas represented by offset and type
class Point {
  /// constructor
  Point(this.offset, this.type);

  /// x and y value on 2D canvas
  Offset offset;

  /// type of user display finger movement
  PointType type;
}

class _DrawingsPainter extends CustomPainter {
  _DrawingsPainter({required this.controller})
      :super(repaint: controller) {
    _penStyle
      ..color = controller.strokeColor
      //..isAntiAlias= true
      ..strokeCap = StrokeCap.round
       // ..strokeJoin = StrokeJoin.round
      ..strokeWidth = controller.strokeWidth;
  }

  final DrawingsController controller;
  Paint _penStyle =Paint();

  @override
  void paint(Canvas canvas, _) {
    final List<Point> points = controller.value;
    if (points.isEmpty) {
      return;
    }
    for (int i = 0; i < (points.length - 1); i++) {
      if (points[i + 1].type == PointType.move) {
        canvas.drawLine(
          points[i].offset,
          points[i + 1].offset,
          _penStyle,
        );
      } else {
        canvas.drawLine(
          points[i].offset,
          points[i].offset,
          _penStyle,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter other) => true;
}

/// class for interaction with drawings widget
/// manages points representing drawings on canvas
/// provides drawings manipulation functions (export, clear)
class DrawingsController extends ValueNotifier<List<Point>> {


  /// constructor
  DrawingsController({
     List<Point>? points,
    this.strokeWidth = 10,
    this.strokeColor = Colors.red
  }) : super(points ?? <Point>[]);

  final double strokeWidth;
  final Color strokeColor;

  /// getter for points representing drawings on 2D canvas
  List<Point> get points => value;

  /// setter for points representing drawings on 2D canvas
  set points(List<Point> points) {
    value = points;
  }

  void revert() {
    if (value.isEmpty) return;

    //bug -> chua fix
    //date 29/5/2020;
    // if(_strokeLength.isEmpty) {
    //   this.clear();
    //   return;
    // }
    try{
      value.removeRange(value.length - _strokeLength.last, value.length);
      _strokeLength.removeLast();
    }
    catch(ex){
      value= [];
    }


    notifyListeners();
  }

  List<int> _strokeLength = [];

  List<Point> tmp = [];

  /// add point to point collection
  void addPoint(Point point, PointerEvent event) {
    value.add(point);
    tmp.add(point);
    if (event is PointerUpEvent) {
      _strokeLength.add(tmp.length);
      tmp.clear();
    }

    notifyListeners();
  }

  /// check if canvas is empty (opposite of isNotEmpty method for convenience)
  bool get isEmpty {
    return value.isEmpty;
  }

  /// check if canvas is not empty (opposite of isEmpty method for convenience)
  bool get isNotEmpty {
    return value.isNotEmpty;
  }

  /// clear the canvas
  void clear() {
    value = <Point>[];
  }
}
