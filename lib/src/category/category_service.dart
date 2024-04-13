import 'package:ebook_app/app/services/model_service.dart';
import 'package:ebook_app/src/category/category.dart';

class CategoryService extends ModelService<Category> {
  CategoryService()
      : super(
          identifier: Category.modelName,
          fromEntries: (data) {
            return Category.fromEntries(data);
          },
          selectRecords: () {
            return Category.all();
          },
        );
}
