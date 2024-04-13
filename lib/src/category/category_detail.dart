import 'package:ebook_app/app/components/custom_decoration.dart';
import 'package:ebook_app/app/components/form_padding.dart';
import 'package:ebook_app/app/services/model_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:ebook_app/src/category/category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ebook_app/src/category/category_service.dart';

class CategoryDetail extends StatefulWidget {
  final String? categoryId;
  const CategoryDetail({super.key, required this.categoryId});

  @override
  State<CategoryDetail> createState() => CategoryDetailState();
}

class CategoryDetailState extends State<CategoryDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Category _category = Category();

  bool _processing = false;

  @override
  void initState() {
    super.initState();

    _category = Provider.of<CategoryService>(context, listen: false).find(widget.categoryId) ?? Category();

    _nameController.value = TextEditingValue(text: _category.name);
    _descriptionController.value = TextEditingValue(text: _category.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryId == null ? 'Add New Category' : 'Details Category ${_category.name}'),
        leading: IconButton(
          onPressed: _processing
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const FormPadding(),
        child: PopScope(
          canPop: !_processing,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _nameController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Name'),
              ),
              TextFormField(
                readOnly: _processing,
                controller: _descriptionController,
                maxLength: 255,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: CustomDecoration('Description'),
              ),
              const SizedBox(
                height: 30,
              ),
              if (Provider.of<CategoryService>(context).status == ModelService.statusSynced)
                Container(
                  child: _processing
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_category.exists)
                              ElevatedButton(
                                onPressed: () {
                                  Helper.confirmationDialog(
                                    context,
                                    'Delete category ${_category.name}',
                                    'Do you really want to delete the category \'${_category.name}\'?\nThis action can not be undone',
                                  ).then((value) {
                                    if (value == true) {
                                      // Action confirmed
                                      processing = true; // Lock buttons

                                      _category.delete().then((value) {
                                        if (value) {
                                          Provider.of<CategoryService>(context, listen: false).remove(_category.id ?? '');

                                          Fluttertoast.showToast(msg: 'Category deleted successfully', backgroundColor: Colors.green);

                                          context.pop(); // Return to index
                                        }
                                      }).whenComplete(() {
                                        processing = false; // Release buttons
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ElevatedButton(
                              onPressed: () {
                                processing = true; // Lock buttons

                                _category
                                    .update({
                                      'name': _nameController.value.text,
                                      'description': _descriptionController.value.text,
                                    })
                                    .timeout(
                                      const Duration(seconds: 15),
                                      onTimeout: () => false,
                                    )
                                    .then((value) {
                                      if (value) {
                                        Provider.of<CategoryService>(context, listen: false).add(_category);

                                        Fluttertoast.showToast(msg: 'Category saved successfully', backgroundColor: Colors.green);

                                        context.pop(); // Return to index
                                      }
                                    })
                                    .whenComplete(() {
                                      processing = false; // Release buttons
                                    });
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                ),
              if (Provider.of<CategoryService>(context).status != ModelService.statusSynced)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),
                    ),
                    const Text('Can not perform any actions when data is not synced'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  set processing(bool processing) {
    if (mounted) {
      setState(() {
        _processing = processing;
      });
    }
  }
}
