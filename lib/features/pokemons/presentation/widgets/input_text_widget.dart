import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class InputTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets? padding;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function() clearInput;
  final IconData? suffixIcon;

  const InputTextWidget({
    super.key,
    required this.controller,
    this.padding,
    required this.focusNode,
    required this.onChanged,
    this.suffixIcon,
    required this.clearInput,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFocus = widget.focusNode.hasFocus;
    return Padding(
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLines: 1,
        onTapOutside: (_) {
          widget.focusNode.unfocus();
        },
        onChanged: (String? value) {
          if (value != null) {
            widget.onChanged(value);
          }
        },
        decoration: InputDecoration(
          hintText: "Nome ou código do pokemon",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: () {
                if (hasFocus) {
                  widget.focusNode.unfocus();
                }
              },
              child: Icon(
                hasFocus ? Icons.arrow_back_ios : Icons.search,
                size: 24,
              ),
            ),
          ),
          suffixIcon: Visibility(
            visible: widget.controller.text.isNotEmpty,
            child: GestureDetector(
              onTap: widget.clearInput,
              child: Transform.rotate(
                angle: pi / 4,
                child: Icon(
                  Icons.add_circle,
                  size: 24,
                  color: AppColors.textHighlight.withOpacity(0.6),
                ),
              ),
            ),
          ),
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
