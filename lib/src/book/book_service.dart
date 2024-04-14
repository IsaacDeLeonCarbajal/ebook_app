import 'package:ebook_app/app/services/model_service.dart';
import 'package:ebook_app/src/book/book.dart';

class BookService extends ModelService<Book> {
  BookService()
      : super(
          identifier: Book.modelName,
          fromEntries: (data) {
            return Book.fromEntries(data);
          },
          selectRecords: () {
            return Book.all();
          },
        );
}
