import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class InputTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets? padding;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const InputTextWidget({
    super.key,
    required this.controller,
    this.padding,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: widget.controller,
        maxLines: 1,
        onTapOutside: (_) {
          widget.focusNode.unfocus();
          print("onTapOutside");
        },
        onChanged: (String? value) {
          if (value != null) {
            widget.onChanged(value);
          }
        },
        decoration: InputDecoration(
          hintText: "Nome ou código do pokemon",
          prefixIcon: Icon(Icons.search),
          fillColor: AppColors.inputBackground,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(57),
            borderSide: BorderSide(color: AppColors.inputText),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(57),
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
