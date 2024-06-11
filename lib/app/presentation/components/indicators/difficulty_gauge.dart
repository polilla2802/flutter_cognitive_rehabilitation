import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class DifficultyGauge extends StatefulWidget {
  const DifficultyGauge({super.key, this.onChanged, this.value = 0});
  final Function(double)? onChanged;
  final double value;

  @override
  State<DifficultyGauge> createState() =>
      _DifficultyGaugeState(onChanged, value);
}

class _DifficultyGaugeState extends State<DifficultyGauge> {
  double widgetPointerValue = 0;
  late Function(double)? _onChanged;

  _DifficultyGaugeState(Function(double)? onChanged, double value) {
    _onChanged = onChanged;
    widgetPointerValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
        minimum: 0,
        maximum: 10,
        animateAxis: true,
        animateRange: true,
        minorTicksPerInterval: 0,
        useRangeColorForAxis: true,
        maximumLabels: 4,
        tickPosition: LinearElementPosition.cross,
        labelPosition: LinearLabelPosition.outside,
        axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
        markerPointers: [
          LinearShapePointer(
              width: 20,
              height: 20,
              value: widgetPointerValue,
              shapeType: LinearShapePointerType.triangle,
              position: LinearElementPosition.inside,
              onChanged:
                  _onChanged != null ? (value) => _onChanged!(value) : null,
              color: widgetPointerValue < 3
                  ? ConstValues.myGreenColor
                  : widgetPointerValue < 8
                      ? ConstValues.myOrangeColor
                      : Colors.red),
        ],
        ranges: [
          LinearGaugeRange(
              rangeShapeType: LinearRangeShapeType.curve,
              edgeStyle: LinearEdgeStyle.bothCurve,
              endValue: widgetPointerValue,
              color: widgetPointerValue < 3
                  ? ConstValues.myGreenColor
                  : widgetPointerValue < 8
                      ? ConstValues.myOrangeColor
                      : Colors.red,
              position: LinearElementPosition.cross)
        ]);
  }
}
