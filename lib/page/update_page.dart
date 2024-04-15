library instantcube;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatelessWidget {
  final String storeUrl;

  const UpdatePage({super.key, required this.storeUrl});

  @override
  Widget build(BuildContext context) {
    var widgets = [
      const Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This app need to update.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: FilledButton(
            onPressed: () async {
              await launchUrl(Uri.parse(storeUrl),
                  mode: LaunchMode.externalNonBrowserApplication);
            },
            child: const Text('Update'),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Column(
                  children: widgets,
                );
              } else {
                return Row(
                  children: widgets,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
