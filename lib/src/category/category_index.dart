import 'package:ebook_app/app/components/simple_index.dart';
import 'package:ebook_app/app/components/list_item.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:ebook_app/src/category/category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ebook_app/src/category/category_service.dart';

/// Displays a list of Categorys
class CategoryIndex extends StatelessWidget {
  const CategoryIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, value, child) {
        return SimpleIndex<Category>(
            service: value,
            itemBuilder: (BuildContext context, int index, Category category) {
              return ListItem(
                title: 'Category ${category.name}',
                primaryInfo: Helper.limitString(category.description, limit: 50),
                onTap: () => context.goNamed('categories.details', pathParameters: {'categoryId': category.id ?? ''}),
              );
            },
            syncedButton: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.goNamed('categories.create'),
            ));
      },
    );
  }
}
