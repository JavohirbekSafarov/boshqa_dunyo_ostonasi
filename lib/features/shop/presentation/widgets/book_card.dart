import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Kitob rasmi (chap tomonda, 16:9 nisbatda)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 120,
                height: 120 * (16 / 9), // 16:9 nisbat
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    // Rasm yuklanmasa yoki xato bo'lsa zaxira rasm
                    onError:
                        (exception, stackTrace) => const AssetImage(
                          'assets/images/placeholder_book.jpg',
                        ),
                  ),
                ),
              ),
            ),
            // Kitob ma'lumotlari (o'ng tomonda)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Namuna uchun qanday ishlatish mumkin:
// class BookCardExample extends StatelessWidget {
//   const BookCardExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Kitob Kartasi')),
//       body: ListView(
//         children: const [
//           BookCard(
//             imageUrl: 'https://example.com/book_image.jpg',
//             title: 'O\'tkan Kunlar',
//             author: 'Abdulla Qodiriy',
//             onTap: null,
//           ),
//           BookCard(
//             imageUrl: 'https://example.com/book2_image.jpg',
//             title: 'Alpomish',
//             author: 'Xalq Eposi',
//           ),
//         ],
//       ),
//     );
//   }
// }
