import 'package:flutter/material.dart';
import 'package:instantcube/form_builder/form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add Product Inventory',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade900),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange.shade900,
          ),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.deepOrange),
      ),
      home: const ProductInventoryAddPage(),
    );
  }
}

class ProductInventoryAddPage extends StatelessWidget {
  const ProductInventoryAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Inventory'),
        leading: const Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          inputFields: const [
            InputText(name: 'name', label: 'Name'),
            InputForm(
              name: 'detailProduct',
              label: 'Detail Product',
              inputFields: [
                InputNumber(name: 'quantity', label: 'Quantity'),
                InputText(name: 'unit', label: 'Unit'),
                InputNumber(
                    name: 'purchasePrice',
                    label: 'Purchase Price',
                    isCurrency: true),
                InputNumber(
                    name: 'sellingPrice',
                    label: 'Selling Price',
                    isCurrency: true),
              ],
            ),
            InputForm(
              name: 'unitConversion',
              label: 'Unit Conversion',
              isMultiInputForm: true,
              isOptional: true,
              inputFields: [
                InputNumber(name: 'quantity', label: 'Quantity'),
                InputText(name: 'unit', label: 'Unit'),
              ],
            ),
            InputForm(
              name: 'priceConversion',
              label: 'Price Conversion',
              isMultiInputForm: true,
              isOptional: true,
              isItemCanAddedOeRemoved: false,
              inputFields: [
                InputText(name: 'unit', label: 'Unit', isEditable: false),
                InputNumber(
                    name: 'purchasePricePerUnit',
                    label: 'Purchase Price Per Unit',
                    isCurrency: true),
                InputNumber(
                    name: 'sellingPricePerUnit',
                    label: 'Selling Price Per Unit',
                    isCurrency: true),
              ],
            ),
            InputText(
                name: 'notes',
                label: 'Notes',
                isMultilines: true,
                isOptional: true),
          ],
          onValueChanged:
              (context, input, previousValue, currentValue, inputValues) {
            if ((input.name == 'detailProduct' ||
                    input.name == 'unitConversion') &&
                inputValues['detailProduct']!.getFormValues().isNotEmpty) {
              var mainQuantity = inputValues['detailProduct']!
                  .getFormValues()
                  .first['quantity'];
              var mainUnit =
                  inputValues['detailProduct']!.getFormValues().first['unit'];
              var mainPurchasePrice = inputValues['detailProduct']!
                  .getFormValues()
                  .first['purchasePrice'];
              var mainSellingPrice = inputValues['detailProduct']!
                  .getFormValues()
                  .first['sellingPrice'];
              var unitConversionValues =
                  inputValues['unitConversion']!.getFormValues();
              if (unitConversionValues.isEmpty) {
                unitConversionValues = [
                  {
                    'quantity': mainQuantity,
                    'unit': mainUnit,
                  },
                ];
              } else {
                if (unitConversionValues
                    .where((element) => element['unit'] == mainUnit)
                    .isNotEmpty) {
                  unitConversionValues = unitConversionValues
                      .map((e) => e['unit'] == mainUnit
                          ? {
                              'quantity': mainQuantity,
                              'unit': mainUnit,
                            }
                          : e)
                      .toList();
                } else {
                  unitConversionValues.add({
                    'quantity': mainQuantity,
                    'unit': mainUnit,
                  });
                }
              }
              inputValues['unitConversion']!
                  .setFormValues(unitConversionValues);

              List<Map<String, dynamic>> value = [];
              for (var element
                  in inputValues['unitConversion']!.getFormValues()) {
                var unitConversion = element['quantity'];
                var unit = element['unit'];
                value.add({
                  'unit': unit,
                  'purchasePricePerUnit': mainPurchasePrice / unitConversion,
                  'sellingPricePerUnit': mainSellingPrice / unitConversion,
                });
              }
              inputValues['priceConversion']!.setFormValues(value);
            }
          },
          onSubmit: (context, inputValues) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          },
          submitButtonSettings: const SubmitButtonSettings(
            label: 'Add',
            icon: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
