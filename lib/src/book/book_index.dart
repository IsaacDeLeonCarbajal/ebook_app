import 'package:ebook_app/app/components/simple_index.dart';
import 'package:ebook_app/app/components/list_item.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:ebook_app/src/book/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ebook_app/src/book/book_service.dart';

/// Displays a list of Books
class BookIndex extends StatelessWidget {
  const BookIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, value, child) {
        return SimpleIndex<Book>(
            service: value,
            itemBuilder: (BuildContext context, int index, Book book) {
              return ListItem(
                title: 'Book ${book.title}',
                primaryInfo: Helper.limitString(book.subtitle, limit: 50),
                onTap: () => context.goNamed('books.details', pathParameters: {'bookId': book.id ?? ''}),
              );
            },
            syncedButton: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.goNamed('books.create'),
            ));
      },
    );
  }
}
