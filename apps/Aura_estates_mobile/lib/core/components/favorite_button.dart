import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/features/properties/data/controllers/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteButton extends ConsumerWidget {
  final String id;
  final double iconSize;

  const FavoriteButton({super.key, required this.id, this.iconSize = 19});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(id));

    return ElevatedButton(
      onPressed: () =>
          ref.read(userDataControllerProvider.notifier).toggleFavorite(id),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.noir,
        shape: CircleBorder(side: BorderSide(color: AppColors.surfaceElevee)),
      ),
      child: Icon(
        size: iconSize,
        isFav ? Icons.favorite : Icons.favorite_border,
        color: AppColors.orAttenu,
      ),
    );
  }
}
