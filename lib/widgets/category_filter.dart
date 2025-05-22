import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String?) onChanged;

  const CategoryFilter({
    Key? key,
    required this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.categoryLabel,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            onChanged: onChanged,
            items: AppConstants.categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}