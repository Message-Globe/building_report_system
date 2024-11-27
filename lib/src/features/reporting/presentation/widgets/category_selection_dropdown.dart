import '../../../../common_widgets/async_value_widget.dart';
import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/category_selection_controller.dart';

class CategorySelectionDropdown extends ConsumerWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelectionDropdown({
    required this.onCategorySelected,
    this.selectedCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categorySelectionControllerProvider);

    return AsyncValueWidget(
      value: categories,
      data: (categories) {
        return DropdownButton<String>(
          value: selectedCategory, // Sincronizzazione
          hint: Text(context.loc.selectCategory.capitalizeFirst()),
          onChanged: (newValue) {
            if (newValue != null) {
              onCategorySelected(newValue); // Aggiorna lo stato
            }
          },
          items: categories
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
