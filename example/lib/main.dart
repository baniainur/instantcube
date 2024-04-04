import 'package:flutter/material.dart';
import 'package:instantcube/form_builder/form_builder.dart';
import 'package:instantcube/form_builder/input_field_option.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<OptionData> _futureTrainingProgramOptionData;
  late Future<OptionData> _genderFamilyMembers;

  @override
  void initState() {
    super.initState();
    _futureTrainingProgramOptionData = Future<OptionData>(
      () {
        List<OptionItem> data = [];
        return OptionData(
            displayedListOfOptions: data, totalOption: data.length);
      },
    );

    _genderFamilyMembers = Future<OptionData>(
      () async {
        var data = [
          const OptionItem(hiddenValue: ['Male'], value: ['Male']),
          const OptionItem(hiddenValue: ['Female'], value: ['Female']),
        ];
        return OptionData(
            displayedListOfOptions: data, totalOption: data.length);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Member',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: FormBuilder(
            formName: 'Member',
            inputFields: [
              InputOption(
                name: 'productInventory',
                label: 'Product Inventory',
                isMultiSelection: true,
                optionData: Future<OptionData>(() async {
                  return const OptionData(
                    displayedListOfOptions: [
                      OptionItem(
                        hiddenValue: [100],
                        value: ['A Per Strip'],
                      ),
                      OptionItem(
                        hiddenValue: [200],
                        value: ['B Per Strip'],
                      ),
                    ],
                    totalOption: 2,
                  );
                }),
              ),
              InputForm(
                name: 'quantity',
                label: 'Quantity',
                isMultiInputForm: true,
                isEditable: true,
                isItemCanAddedOeRemoved: false,
                inputFields: [
                  const InputText(
                    name: 'productName',
                    label: 'ProductName',
                    isEditable: false,
                  ),
                  const InputNumber(
                    name: 'quantity',
                    label: 'Quantity',
                  ),
                  const InputNumber(
                    name: 'sellingPricePerUnit',
                    label: 'Selling Price Per Unit',
                    isEditable: false,
                    isCurrency: true,
                  ),
                  const InputNumber(
                    name: 'sellingPriceTotal',
                    label: 'Selling Price Total',
                    isEditable: false,
                    isCurrency: true,
                  ),
                ],
                onFormValueChanged:
                    (context, input, previousValue, currentValue, inputValues) {
                  if (input.name == 'quantity') {
                    double quantity = currentValue ?? 0;
                    double sellingPricePerUnit =
                        inputValues['sellingPricePerUnit']!.getNumber() ?? 0;
                    inputValues['sellingPriceTotal']!
                        .setNumber(quantity * sellingPricePerUnit);
                  }
                },
              ),
              const InputForm(
                name: 'payament',
                label: 'Payment',
                inputFields: [
                  InputNumber(
                    name: 'mustPay',
                    label: 'Must Pay',
                    isEditable: false,
                    isCurrency: true,
                  ),
                  InputNumber(
                    name: 'moneyReceived',
                    label: 'Money Received',
                    isCurrency: true,
                  ),
                  InputNumber(
                    name: 'changeMoney',
                    label: 'Change Money',
                    isEditable: false,
                    isCurrency: true,
                  ),
                ],
              ),
            ],
            onValueChanged:
                (context, input, previousValue, currentValue, inputValues) {
              if (input.name == 'productInventory') {
                var productInventoryValues = (currentValue as List<OptionItem>);
                List<Map<String, dynamic>> quantityValues = [];
                for (var productInventoryValue in productInventoryValues) {
                  quantityValues.add({
                    'productName': productInventoryValue.value.first,
                    'quantity': 0,
                    'sellingPricePerUnit':
                        productInventoryValue.hiddenValue.first,
                    'sellingPriceTotal':
                        productInventoryValue.hiddenValue.first * 0,
                  });
                }
                inputValues['quantity']!.setFormValues(quantityValues);
              }
            },
            onSubmit: (context, inputValues) {
              var result =
                  inputValues['familyMembers']!.getFormValues().first['name']!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Processing Data $result')),
              );
            },
            submitButtonSettings: const SubmitButtonSettings(
              label: 'Add Member',
              icon: Icon(Icons.add),
            ),
            additionalButtons: [
              AdditionalButton(
                onTap: (context, inputValues) async {
                  await Future.delayed(const Duration(seconds: 2));
                  inputValues['name']!.setString(null);
                },
                label: 'Reset',
                icon: const Icon(Icons.undo),
              ),
              AdditionalButton(
                onTap: (context, inputValues) async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                label: 'Cancel',
                icon: const Icon(Icons.cancel),
              ),
              AdditionalButton(
                onTap: (context, inputValues) async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                label: 'Back',
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
