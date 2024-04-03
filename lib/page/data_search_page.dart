library instantcube;

import '../form_builder/form_builder.dart';
import 'package:flutter/material.dart';

import 'data_list_page.dart';

class DataSearchPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Input> inputFields;
  final Future<MapEntry<List<KeyWord>, SearchWrapper>?> Function(
      Map<String, InputValue> inputValues) searchProcess;
  final Function(BuildContext context, Map<String, InputValue> inputValues)?
      onInitial;
  final dynamic Function(
      BuildContext context,
      Map<String, InputValue> inputValues,
      bool isValid,
      Map<String, String?> errorMessages)? onAfterValidation;
  final dynamic Function(
          BuildContext context, Map<String, InputValue> inputValues)?
      onBeforeValidation;
  final dynamic Function(
      BuildContext context,
      Input input,
      dynamic previousValue,
      dynamic currentValue,
      Map<String, InputValue> inputValues)? onValueChanged;
  final bool? isFormEditable;
  final List<AdditionalButton>? additionalButtons;

  const DataSearchPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.inputFields,
      required this.searchProcess,
      this.onInitial,
      this.onAfterValidation,
      this.onBeforeValidation,
      this.onValueChanged,
      this.isFormEditable,
      this.additionalButtons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: FormBuilder(
            inputFields: inputFields,
            onInitial: onInitial,
            onAfterValidation: onAfterValidation,
            onBeforeValidation: onBeforeValidation,
            onValueChanged: onValueChanged,
            isFormEditable: isFormEditable,
            additionalButtons: additionalButtons,
            resetToInitialAfterSubmit: true,
            onSubmit: (context, inputValues) async {
              var result = await searchProcess.call(inputValues);

              if (!context.mounted) return;

              Navigator.pop(context, result);
            },
            submitButtonSettings: const SubmitButtonSettings(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
