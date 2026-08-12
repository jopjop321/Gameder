// category_card_item.dart
import 'package:flutter/material.dart';
import '../app/data/models/category_model.dart';

class CategoryCardItem extends StatelessWidget {
  final GameCategory category;
  final VoidCallback onTap;

  const CategoryCardItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: Stack(
            children: [
              Positioned.fill(child: _buildCardVisual()),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: category.textColor == Colors.white
                        ? Colors.black.withOpacity(0.45)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    category.displayTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: category.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardVisual() {
    final imagePath = category.imagePath;
    if (imagePath != null) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }

    return Container(
      color: const Color(0xFF1C4E63),
      alignment: Alignment.center,
      child: Icon(category.icon, color: Colors.white, size: 76),
    );
  }
}
