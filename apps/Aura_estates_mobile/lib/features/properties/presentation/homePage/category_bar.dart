import 'package:aura_estates/core/components/my_button.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBar extends ConsumerWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    final categories = ['TOUS', 'VILLA', 'PENTHOUSE', 'Île Privée', 'RIAD'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: categories.map((categorie) {
          final isSelected = selected.toUpperCase() == categorie.toUpperCase();
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: MyButton(
              textButton: categorie,
              backgroundColor: isSelected ? AppColors.or : AppColors.noir,
              textColor: isSelected ? AppColors.noir : AppColors.or,
              onPressed: () =>
                  ref // ← on notifie le provider
                      .read(selectedCategoryProvider.notifier)
                      .select(categorie),
            ),
          );
        }).toList(),
      ),
    );
  }
}
