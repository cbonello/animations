import 'dart:async';

import 'package:rive_flare/input_helper.dart';
import 'package:flutter/material.dart';

typedef CaretMoved = void Function(Offset? globalCaretPosition);
typedef TextChanged = void Function(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  final CaretMoved onCaretMoved;
  final TextChanged? onTextChanged;
  final String hint;
  final String label;
  final bool isObscured;

  const TrackingTextInput({
    super.key,
    required this.onCaretMoved,
    this.onTextChanged,
    required this.hint,
    required this.label,
    this.isObscured = false,
  });

  @override
  TrackingTextInputState createState() => TrackingTextInputState();
}

class TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  Timer? _debounceTimer;

  @override
  initState() {
    super.initState();

    _textController.addListener(
      () {
        // We debounce the listener as sometimes the caret position is updated after the listener
        // this assures us we get an accurate caret position.
        if (_debounceTimer?.isActive ?? false) {
          _debounceTimer!.cancel();
        }

        _debounceTimer = Timer(
          const Duration(milliseconds: 100),
          () {
            if (_fieldKey.currentContext != null) {
              // Find the render editable in the field.
              final RenderObject fieldBox = _fieldKey.currentContext!.findRenderObject()!;
              final caretPosition = getCaretPosition(fieldBox as RenderBox);

              widget.onCaretMoved(caretPosition);
            }
          },
        );

        widget.onTextChanged?.call(_textController.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
        ),
        key: _fieldKey,
        controller: _textController,
        obscureText: widget.isObscured,
        validator: (_) => null,
      ),
    );
  }
}
