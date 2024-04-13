import 'package:ebook_app/app/components/service_state.dart';
import 'package:ebook_app/app/models/model.dart';
import 'package:ebook_app/app/services/model_service.dart';
import 'package:flutter/material.dart';

/// Displays a list of Items from a ModelService.
class SimpleIndex<M extends Model> extends StatelessWidget {
  final ModelService service;
  final Widget Function(BuildContext, int, M) itemBuilder;
  final Widget? syncedButton;

  const SimpleIndex({super.key, required this.service, required this.itemBuilder, required this.syncedButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ServiceState(
          service: service,
          syncedButton: syncedButton,
        ),
        if (service.isReady)
          Expanded(
            child: ListView.separated(
              itemCount: service.elements.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final element = service.elements.elementAt(index);

                return itemBuilder(context, index, element as M);
              },
            ),
          ),
      ],
    );
  }
}
