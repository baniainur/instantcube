library instantcube;

import 'package:flutter/material.dart';
import 'package:instantcube/form_builder/form_builder.dart';

class DataDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final dynamic id;
  final List<Input> inputFields;
  final Future<IsUpdated> Function(
          BuildContext context, dynamic id, Map<String, InputValue> inputValues)
      save;
  final Future<IsDeleted> Function(BuildContext context, dynamic id) delete;
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
  final bool? isSubmitButtonEnable;
  final bool? isAddtionalButtonButtonEnable;

  const DataDetailPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.id,
      required this.inputFields,
      required this.delete,
      required this.save,
      this.onInitial,
      this.onAfterValidation,
      this.onBeforeValidation,
      this.onValueChanged,
      this.isFormEditable = true,
      this.additionalButtons,
      this.isSubmitButtonEnable = true,
      this.isAddtionalButtonButtonEnable = true});

  @override
  State<DataDetailPage> createState() => _DataDetailPageState();
}

class _DataDetailPageState extends State<DataDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.subtitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: FormBuilder(
            inputFields: widget.inputFields,
            onInitial: widget.onInitial,
            onAfterValidation: widget.onAfterValidation,
            onBeforeValidation: widget.onBeforeValidation,
            onValueChanged: widget.onValueChanged,
            isFormEditable: widget.isFormEditable,
            isSubmitButtonEnable: widget.isSubmitButtonEnable,
            isAddtionalButtonButtonEnable: widget.isAddtionalButtonButtonEnable,
            additionalButtons: [
                  AdditionalButton(
                    label: 'Delete',
                    icon: const Icon(Icons.delete),
                    onTap: (context, inputValues) async {
                      var result = await showDialog<String>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning),
                            title:
                                const Text('Are you sure to delete this item?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop('No');
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop('Yes');
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (result == 'Yes') {
                        if (!context.mounted) return;

                        var isDeleted =
                            await widget.delete.call(context, widget.id);

                        if (!context.mounted) return;

                        if (isDeleted == IsDeleted.yes) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                  ),
                ] +
                (widget.additionalButtons ?? []),
            onSubmit: (context, inputValues) async {
              var isUpdated =
                  await widget.save.call(context, widget.id, inputValues);

              if (!context.mounted) return;

              if (isUpdated == IsUpdated.yes) {
                await showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.info),
                      title: const Text('Data successfully saved.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop('Ok');
                          },
                        ),
                      ],
                    );
                  },
                );

                if (!context.mounted) return;

                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, true);
              }
            },
            submitButtonSettings: const SubmitButtonSettings(
              label: 'Save',
              icon: Icon(Icons.save),
            ),
          ),
        ),
      ),
    );
  }
}

enum IsDeleted { yes, no }

enum IsUpdated { yes, no }
