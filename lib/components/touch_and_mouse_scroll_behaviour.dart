import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Por padrão o scroll lateral não funciona corretamente via mouse.
/// Essa classe tem como finalidade garantir scroll tanto para touch (padrão)
/// quanto para mouses.
///
/// Implementação nspirada [nessa solução](https://stackoverflow.com/a/69202112).
class TouchAndMouseScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}