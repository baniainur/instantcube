library instantcube;

import 'form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputFieldNumber extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final String? helperText;
  final InputNumberMode? inputFieldNumberMode;
  final String? Function(String? errorMessage)? onValidating;
  final bool? isEditable;
  final dynamic Function(
          BuildContext context, double? previousValue, double? currentValue)?
      onValueChanged;
  final InputNumber input;
  final bool isCurrency;

  const InputFieldNumber({
    super.key,
    required this.controller,
    required this.label,
    required this.isRequired,
    this.helperText,
    this.inputFieldNumberMode,
    this.onValidating,
    this.isEditable,
    this.onValueChanged,
    required this.input,
    required this.isCurrency,
  });

  @override
  State<InputFieldNumber> createState() => _InputFieldNumberState();
}

class _InputFieldNumberState extends State<InputFieldNumber> {
  late String? _currencyValue;

  @override
  void initState() {
    _currencyValue = widget.controller.text != ''
        ? NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2)
            .format(double.parse(widget.controller.text))
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var integerFormatter = [
      FilteringTextInputFormatter.allow(RegExp(r"[0-9-]")),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          try {
            final text = newValue.text;
            if (text.isNotEmpty) int.parse(text);
            return newValue;
          } catch (e) {
            final text = newValue.text;
            if (text == "-") {
              return newValue;
            }
          }
          return oldValue;
        },
      ),
    ];
    var decimalFormatter = [
      FilteringTextInputFormatter.allow(RegExp(r"[0-9.-]")),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          try {
            final text = newValue.text;
            if (text.isNotEmpty) double.parse(text);
            return newValue;
          } catch (e) {
            final text = newValue.text;
            if (text == "-") {
              return newValue;
            }
          }
          return oldValue;
        },
      ),
    ];

    double? prevValue = widget.controller.text == ''
        ? null
        : double.parse(widget.controller.text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currencyValue = widget.controller.text != ''
            ? NumberFormat.decimalPatternDigits(
                    locale: 'en_US', decimalDigits: 2)
                .format(double.parse(widget.controller.text))
            : '';
      });
    });

    return TextFormField(
      controller: widget.controller,
      readOnly: !(widget.isEditable ?? true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputFormatters:
          (widget.inputFieldNumberMode ?? InputNumberMode.integer) ==
                  InputNumberMode.integer
              ? integerFormatter
              : decimalFormatter,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        labelText: widget.label + (widget.isRequired ? '' : ' - Optional'),
        helperText: widget.isCurrency
            ? _currencyValue != ''
                ? '$_currencyValue ${widget.helperText ?? ''}'
                : widget.helperText
            : widget.helperText,
        helperMaxLines: 100,
        suffixIcon: const Icon(Icons.numbers),
      ),
      onChanged: (value) {
        setState(() {
          _currencyValue = value != ''
              ? NumberFormat.decimalPatternDigits(
                      locale: 'en_US', decimalDigits: 2)
                  .format(double.parse(value))
              : '';
        });
        double? currentValue = value == '' ? null : double.parse(value);
        if (widget.onValueChanged != null) {
          widget.onValueChanged!.call(context, prevValue, currentValue);
        }
        prevValue = currentValue;
      },
      validator: (value) {
        validation() {
          if (widget.isRequired && (value == null || value.isEmpty)) {
            return 'Required';
          }
          return null;
        }

        String? errorMessage = validation.call();
        if (widget.onValidating != null) {
          return widget.onValidating!.call(errorMessage);
        }
        return errorMessage;
      },
    );
  }
}

enum InputNumberMode { integer, decimal }
