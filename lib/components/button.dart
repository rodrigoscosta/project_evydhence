import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

/// [ButtonFlavor]
///
/// Enum utilizado para definir as variedades de um botão
enum ButtonFlavor { elevated, outlined, text, dotted }

/// [Button]
///
/// Componente de botão que encapsula os estilos apropriados de acordo com o
/// parâmetro [flavor].
///
/// O construtor espera os mesmos parâmetros que os das classes [ElevatedButton],
/// [TextButton] e [OutlinedButton], a única diferença é que o parâmetro [child]
/// é obrigatório.
///
/// Lança um [UnimplementedError] caso o valor de [flavor] não faça parte do
/// enum [ButtonFalvor]
class Button extends StatelessWidget {
  final ButtonFlavor flavor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final Color? primaryColor;
  final bool autofocus;
  final Clip clipBehavior;
  final Widget child;

  final Color gray = const Color.fromRGBO(255, 255, 255, 1);
  final Color darkGray = const Color(0xFFA4A4AC);
  final Color transparent = const Color(0x00000000);

  final defaultPadding = const EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 15.0,
  );

  const Button({
    Key? key,
    required this.flavor,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.primaryColor = const Color.fromRGBO(250, 70, 22, 1),
    this.clipBehavior = Clip.none,
    required this.child,
  }) : super(key: key);

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  @override
  Widget build(BuildContext context) {
    switch (flavor) {
      case ButtonFlavor.elevated:
        return _buildElevatedButton();
      case ButtonFlavor.outlined:
        return _buildOutlinedButton();
      case ButtonFlavor.text:
        return _buildTextButton();
      case ButtonFlavor.dotted:
        return _buildDottedButton();
    }
  }

  Key _appendFlavorInKey(ButtonFlavor flavor) {
    final keyString = key == null ? 'button' : key.toString();
    return Key('$keyString:${flavor.name}');
  }

  Widget _buildElevatedButton() {
    final defaultStyle = ElevatedButton.styleFrom(
      foregroundColor: (primaryColor!.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white),
      backgroundColor: primaryColor,
      minimumSize: Size.zero,
      padding: defaultPadding,
    );

    return ElevatedButton(
      key: _appendFlavorInKey(ButtonFlavor.elevated),
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style ?? defaultStyle,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  Widget _buildOutlinedButton() {
    final defaultStyle = OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      backgroundColor: (primaryColor!.computeLuminance() > 0.5
          ? darken(primaryColor!, 0.4)
          : lighten(primaryColor!, 0.4)),
      minimumSize: Size.zero,
      padding: defaultPadding,
    );

    return OutlinedButton(
      key: _appendFlavorInKey(ButtonFlavor.outlined),
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style ?? defaultStyle,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  Widget _buildTextButton() {
    final defaultStyle = TextButton.styleFrom(
      foregroundColor: primaryColor,
      backgroundColor: gray,
      minimumSize: Size.zero,
      padding: defaultPadding,
    );

    return TextButton(
      key: _appendFlavorInKey(ButtonFlavor.text),
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style ?? defaultStyle,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  Widget _buildDottedButton() {
    final defaultStyle = TextButton.styleFrom(
        foregroundColor: darkGray,
        backgroundColor: transparent,
        shadowColor: transparent,
        padding: defaultPadding);

    return DottedBorder(
        padding: EdgeInsets.zero,
        color: darkGray,
        dashPattern: const [10],
        borderType: BorderType.RRect,
        radius: const Radius.circular(4.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextButton(
            key: _appendFlavorInKey(ButtonFlavor.dotted),
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ?? defaultStyle,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            child: child,
          )
        ]));
  }
}
