import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [TextInputFormField]
///
/// Componente que encapsula um [TextFormField] e adiciona algumas funcionalidades
/// extras.
class TextInputFormField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? labelText;
  final String? hintText;

  /// adiciona um asterisco vermelho no fim do [labelText].
  final bool required;
  final bool readOnly;
  final bool? enabled;
  final bool expands;
  final bool isDense;
  final String obscuringCharacter;

  /// precisa ser `true` para que o botão de mostrar/ocultar senha seja habilitado.
  final bool obscureText;
  final bool autocorrect;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  //final ToolbarOptions? toolbarOptions;
  final TextAlign textAlign;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  /// precisa ser [TextInputType.visiblePassword] para que o botão de mostrar/ocultar
  /// senha seja habilitado.
  final TextInputType keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final InputDecoration decoration;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final String? counterText;
  final TextCapitalization? textCapitalization;

  const TextInputFormField(
      {Key? key,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.labelText,
      this.hintText,
      this.required = false,
      this.readOnly = false,
      this.enabled,
      this.expands = false,
      this.isDense = true,
      this.obscuringCharacter = '•',
      this.obscureText = false,
      this.autocorrect = true,
      this.style,
      this.strutStyle,
      //this.toolbarOptions,
      this.textAlign = TextAlign.start,
      this.maxLength,
      this.maxLines = 1,
      this.minLines,
      TextInputType? keyboardType,
      this.textAlignVertical,
      this.enableInteractiveSelection = true,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.decoration = const InputDecoration(),
      this.validator,
      this.inputFormatters,
      AutovalidateMode? autovalidateMode,
      this.autofillHints,
      this.textInputAction,
      this.initialValue,
      this.counterText = '',
      this.textCapitalization})
      : keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
        super(key: key);

  @override
  State<TextInputFormField> createState() => _TextInputFormFieldState();
}

class _TextInputFormFieldState extends State<TextInputFormField> {
  late final bool isPasswordInputType;
  bool isHidden = true;

  @override
  void initState() {
    isPasswordInputType = widget.obscureText &&
        widget.keyboardType == TextInputType.visiblePassword;
    super.initState();
  }

  void toggleVisibility() => setState(() {
        isHidden = !isHidden;
      });

  Text createRequiredLabel(String labelText) => Text.rich(
        TextSpan(
          text: labelText,
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget? buildLabel() {
    final required = widget.required;
    final labelText = widget.labelText;

    if (labelText == null) return null;
    if (required) return createRequiredLabel(labelText);
    return Text(labelText);
  }

  Widget? buildSuffixIcon() => isPasswordInputType
      ? IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            isHidden ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          ),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration.copyWith(
        border: const OutlineInputBorder(),
        isDense: widget.isDense,
        hintText: widget.hintText,
        label: buildLabel(),
        suffixIcon: buildSuffixIcon(),
        counterText: widget.counterText,
      ),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      expands: widget.expands,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: isPasswordInputType ? isHidden : widget.obscureText,
      autocorrect: widget.autocorrect,
      style: widget.style,
      strutStyle: widget.strutStyle,
      //toolbarOptions: widget.toolbarOptions,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textAlignVertical: widget.textAlignVertical,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      initialValue: widget.initialValue,
    );
  }
}
