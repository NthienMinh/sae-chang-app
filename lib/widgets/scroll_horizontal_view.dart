import 'package:flutter/Material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class HomeScrollHorizontalView extends StatelessWidget {
  final List<Widget> list;
  final double height;
  const HomeScrollHorizontalView(
      {required this.list, required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        physics: PagingScrollPhysics(
            itemDimension: (MediaQuery.of(context).size.width -
                2 * Resizable.padding(context, 40) -
                Resizable.padding(context, 10)) /
                2),
        children: <Widget>[
          SizedBox(width: Resizable.padding(context, 40)),
          ...list,
          SizedBox(width: Resizable.padding(context, 30)),
        ],
      ),
    );
  }
}

class PagingScrollPhysics extends ScrollPhysics {
  final double itemDimension;
  const PagingScrollPhysics(
      {required this.itemDimension, super.parent});

  @override
  PagingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PagingScrollPhysics(
        itemDimension: itemDimension, parent: buildParent(ancestor));
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / itemDimension;
  }

  double _getPixels(double page) {
    return page * itemDimension;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 1;
    } else if (velocity > tolerance.velocity) {
      page += 1;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}