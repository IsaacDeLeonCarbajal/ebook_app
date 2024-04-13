import 'package:ebook_app/app/components/pop_button.dart';
import 'package:ebook_app/app/services/model_service.dart';
import 'package:flutter/material.dart';

class ServiceState extends StatelessWidget {
  final ModelService service;
  final Widget? syncedButton;

  const ServiceState({super.key, required this.service, required this.syncedButton});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (service.status == ModelService.statusLocal)
                const PopButton(
                  icon: Icon(Icons.info),
                  message: 'Showing only local data, try syncing',
                ),
              if (service.status == ModelService.statusSynced && syncedButton != null) syncedButton as Widget,
              IconButton(
                onPressed: () {
                  service.syncRemote();
                },
                icon: const Icon(Icons.cloud_sync),
              ),
            ],
          ),
          if (service.status == ModelService.statusProcessing)
            const CircularProgressIndicator()
          else if (service.status == ModelService.statusError)
            const Text(
              'Error while loading data from cloud.\nPlease try again later',
              textAlign: TextAlign.center,
            )
          else if (service.isEmpty)
            const Text('There are no records'),
        ],
      ),
    );
  }
}
