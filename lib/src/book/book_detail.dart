import 'package:ebook_app/app/components/custom_decoration.dart';
import 'package:ebook_app/app/components/form_padding.dart';
import 'package:ebook_app/app/services/model_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:ebook_app/src/book/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ebook_app/src/book/book_service.dart';

class BookDetail extends StatefulWidget {
  final String? bookId;
  const BookDetail({super.key, required this.bookId});

  @override
  State<BookDetail> createState() => BookDetailState();
}

class BookDetailState extends State<BookDetail> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();

  Book _book = Book();

  bool _processing = false;

  @override
  void initState() {
    super.initState();

    _book = Provider.of<BookService>(context, listen: false).find(widget.bookId) ?? Book();

    _titleController.value = TextEditingValue(text: _book.title);
    _titleController.value = TextEditingValue(text: _book.title);
    _subtitleController.value = TextEditingValue(text: _book.subtitle);
    _descriptionController.value = TextEditingValue(text: _book.description);
    _priceController.value = TextEditingValue(text: _book.price.toString());
    _stockController.value = TextEditingValue(text: _book.stock.toString());
    _yearController.value = TextEditingValue(text: _book.year.toString());
    _pagesController.value = TextEditingValue(text: _book.pages.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == null ? 'Add New Book' : 'Details Book ${_book.title}'),
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
                controller: _titleController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Title'),
              ),
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _subtitleController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Subtitle'),
              ),
              TextFormField(
                readOnly: _processing,
                controller: _descriptionController,
                maxLength: 255,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Description'),
              ),
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _priceController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Price'),
              ),
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _stockController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Stock'),
              ),
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _yearController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: CustomDecoration('Year'),
              ),
              TextFormField(
                autofocus: true,
                readOnly: _processing,
                controller: _pagesController,
                maxLength: 255,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: CustomDecoration('Pages'),
              ),
              const SizedBox(
                height: 30,
              ),
              if (Provider.of<BookService>(context).status == ModelService.statusSynced)
                Container(
                  child: _processing
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_book.exists)
                              ElevatedButton(
                                onPressed: () {
                                  Helper.confirmationDialog(
                                    context,
                                    'Delete book ${_book.title}',
                                    'Do you really want to delete the book \'${_book.title}\'?\nThis action can not be undone',
                                  ).then((value) {
                                    if (value == true) {
                                      // Action confirmed
                                      processing = true; // Lock buttons

                                      _book.delete().then((value) {
                                        if (value) {
                                          Provider.of<BookService>(context, listen: false).remove(_book.id ?? '');

                                          Fluttertoast.showToast(msg: 'Book deleted successfully', backgroundColor: Colors.green);

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

                                _book
                                    .update({
                                      'title': _titleController.value.text,
                                      'subtitle': _subtitleController.value.text,
                                      'description': _descriptionController.value.text,
                                      'price': _priceController.value.text,
                                      'stock': _stockController.value.text,
                                      'year': _yearController.value.text,
                                      'pages': _pagesController.value.text,
                                    })
                                    .timeout(
                                      const Duration(seconds: 15),
                                      onTimeout: () => false,
                                    )
                                    .then((value) {
                                      if (value) {
                                        Provider.of<BookService>(context, listen: false).add(_book);

                                        Fluttertoast.showToast(msg: 'Book saved successfully', backgroundColor: Colors.green);

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
              if (Provider.of<BookService>(context).status != ModelService.statusSynced)
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
