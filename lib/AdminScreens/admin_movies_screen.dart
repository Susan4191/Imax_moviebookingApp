import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/movie_model.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class AdminMoviesScreen extends StatefulWidget {
  const AdminMoviesScreen({super.key});

  @override
  State<AdminMoviesScreen> createState() => _AdminMoviesScreenState();
}

class _AdminMoviesScreenState extends State<AdminMoviesScreen> {
  String _selectedCategoryFilter = 'All';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    final List<Map<String, dynamic>> allMoviesList = [
      ...movieProvider.nowShowingMovies.map(
        (m) => {'movie': m, 'categoryIndex': 0, 'categoryName': 'Now Showing'},
      ),
      ...movieProvider.nextReleaseMovies.map(
        (m) => {'movie': m, 'categoryIndex': 1, 'categoryName': 'Next Release'},
      ),
      ...movieProvider.comingSoonMovies.map(
        (m) => {'movie': m, 'categoryIndex': 2, 'categoryName': 'Coming Soon'},
      ),
    ];

    final filteredMovies = allMoviesList.where((item) {
      final MovieModel movie = item['movie'] as MovieModel;
      final String categoryName = item['categoryName'] as String;

      final matchesCategory =
          _selectedCategoryFilter == 'All' ||
          categoryName == _selectedCategoryFilter;

      final matchesSearch =
          _searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          movie.information.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title & Add Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Movie Management',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage Now Showing, Next Release & Coming Soon movies',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditMovieDialog(context),
                    icon: const Icon(
                      Icons.add_rounded,
                      color: AppColor.white,
                      size: 18,
                    ),
                    label: Text(
                      'Add Movie',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Search Bar & Filter Badges
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search movie by title or genre...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColor.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.themeColor),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                        'All',
                        'Now Showing',
                        'Next Release',
                        'Coming Soon',
                      ].map((category) {
                        final isSelected = _selectedCategoryFilter == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategoryFilter = category;
                                });
                              }
                            },
                            selectedColor: AppColor.themeColor,
                            backgroundColor: AppColor.cardColor,
                            labelStyle: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppColor.white
                                  : AppColor.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColor.themeColor
                                  : AppColor.borderColor,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              /// Movies Grid / Empty State
              Expanded(
                child: filteredMovies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.movie_filter_outlined,
                              size: 60,
                              color: AppColor.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No movies found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try adjusting your search or category filter.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final item = filteredMovies[index];
                          final MovieModel movie = item['movie'] as MovieModel;
                          final int categoryIndex =
                              item['categoryIndex'] as int;
                          final String categoryName =
                              item['categoryName'] as String;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _buildMoviePoster(
                                          movie.poster,
                                          width: 70,
                                          height: 95,
                                        ),
                                      ),
                                      const SizedBox(width: 14),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            _getCategoryColor(
                                                              categoryIndex,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              _getCategoryColor(
                                                                categoryIndex,
                                                              ),
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        categoryName,
                                                        style: AppTextStyles
                                                            .labelSmall
                                                            .copyWith(
                                                              color:
                                                                  _getCategoryColor(
                                                                    categoryIndex,
                                                                  ),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),

                                                    /// Movie Format Tag (2D / 3D / IMAX)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.red
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                        border: Border.all(
                                                          color: AppColor.red,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        movie.format ??
                                                            'IMAX 3D',
                                                        style: AppTextStyles
                                                            .labelSmall
                                                            .copyWith(
                                                              color:
                                                                  AppColor.red,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                if (movie.rating != null &&
                                                    movie.rating!.isNotEmpty)
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        movie.rating!,
                                                        style: AppTextStyles
                                                            .bodySmall
                                                            .copyWith(
                                                              color: AppColor
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),

                                            Text(
                                              movie.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.titleMedium
                                                  .copyWith(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),

                                            Text(
                                              movie.information,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    color: AppColor.grey,
                                                  ),
                                            ),
                                            if (movie.durations != null &&
                                                movie
                                                    .durations!
                                                    .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                'Duration: ${movie.durations}',
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      color: AppColor.textMuted,
                                                      fontSize: 11,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(
                                  color: AppColor.borderColor,
                                  height: 1,
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () =>
                                            _showAddEditMovieDialog(
                                              context,
                                              movieToEdit: movie,
                                              existingCategoryIndex:
                                                  categoryIndex,
                                            ),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: AppColor.blue,
                                        ),
                                        label: Text(
                                          'Edit',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(color: AppColor.blue),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        onPressed: () => _confirmDeleteMovie(
                                          context,
                                          movie,
                                          categoryIndex,
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: AppColor.red,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(color: AppColor.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return AppColor.green;
      case 1:
        return AppColor.orange;
      case 2:
        return AppColor.purple;
      default:
        return AppColor.themeColor;
    }
  }

  Widget _buildMoviePoster(
    String posterPath, {
    double width = 90,
    double height = double.infinity,
  }) {
    if (posterPath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.themeColor, size: 28),
      );
    }

    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return Image.network(
        posterPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColor.surfaceColor,
          child: const Icon(Icons.movie, color: AppColor.themeColor, size: 28),
        ),
      );
    }

    return Image.asset(
      posterPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.themeColor, size: 28),
      ),
    );
  }

  void _confirmDeleteMovie(
    BuildContext context,
    MovieModel movie,
    int categoryIndex,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Movie',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${movie.title}"? This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MovieProvider>().deleteMovie(movie, categoryIndex);
              Navigator.pop(ctx);
              AppToast.showSuccess('Movie deleted successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Delete',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditMovieDialog(
    BuildContext context, {
    MovieModel? movieToEdit,
    int existingCategoryIndex = 0,
  }) {
    final formKey = GlobalKey<FormState>();
    final isEditing = movieToEdit != null;

    final titleController = TextEditingController(
      text: isEditing ? movieToEdit.title : '',
    );
    final infoController = TextEditingController(
      text: isEditing ? movieToEdit.information : '',
    );
    final ratingController = TextEditingController(
      text: isEditing ? (movieToEdit.rating ?? '') : '8.0',
    );
    final durationController = TextEditingController(
      text: isEditing ? (movieToEdit.durations ?? '') : '2.0 hr',
    );
    final posterController = TextEditingController(
      text: isEditing ? movieToEdit.poster : '',
    );

    int selectedCategoryIdx = existingCategoryIndex;
    String selectedFormat = isEditing
        ? (movieToEdit.format ?? 'IMAX 3D')
        : 'IMAX 3D';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColor.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isEditing ? Icons.edit_outlined : Icons.movie_creation_outlined,
                color: AppColor.themeColor,
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Edit Movie' : 'Add New Movie',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Category Selection Dropdown
                    Text(
                      'Movie Category / Status',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      initialValue: selectedCategoryIdx,
                      dropdownColor: AppColor.cardColor,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.themeColor,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Now Showing')),
                        DropdownMenuItem(value: 1, child: Text('Next Release')),
                        DropdownMenuItem(value: 2, child: Text('Coming Soon')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedCategoryIdx = val;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Movie Format / Type Dropdown (2D, 3D, IMAX)
                    Text(
                      'Movie Format / Type',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedFormat,
                      dropdownColor: AppColor.cardColor,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.themeColor,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '2D', child: Text('2D')),
                        DropdownMenuItem(value: '3D', child: Text('3D')),
                        DropdownMenuItem(
                          value: 'IMAX 2D',
                          child: Text('IMAX 2D'),
                        ),
                        DropdownMenuItem(
                          value: 'IMAX 3D',
                          child: Text('IMAX 3D'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedFormat = val;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Title Field
                    _buildFormField(
                      controller: titleController,
                      label: 'Movie Title',
                      hint: 'e.g. Spider-Man: Beyond',
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Movie title is required'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    /// Information / Genre Field
                    _buildFormField(
                      controller: infoController,
                      label: 'Genre / Information',
                      hint: 'e.g. Action / Sci-Fi',
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Information is required'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    /// Poster URL Field
                    _buildFormField(
                      controller: posterController,
                      label: 'Poster Image URL',
                      hint: 'https://image-link.com/poster.jpg',
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Poster URL is required'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    /// Rating & Duration Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            controller: ratingController,
                            label: 'Rating (0 - 10)',
                            hint: '8.5',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildFormField(
                            controller: durationController,
                            label: 'Duration',
                            hint: '2.5 hr',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Cancel',
                style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newMovie = MovieModel(
                    title: titleController.text.trim(),
                    information: infoController.text.trim(),
                    poster: posterController.text.trim(),
                    rating: ratingController.text.trim().isEmpty
                        ? 'N/A'
                        : ratingController.text.trim(),
                    durations: durationController.text.trim().isEmpty
                        ? 'N/A'
                        : durationController.text.trim(),
                    format: selectedFormat,
                  );

                  final provider = context.read<MovieProvider>();

                  if (isEditing) {
                    provider.updateMovie(
                      movieToEdit,
                      newMovie,
                      selectedCategoryIdx,
                    );
                    AppToast.showSuccess('Movie updated successfully!');
                  } else {
                    provider.addMovie(newMovie, selectedCategoryIdx);
                    AppToast.showSuccess('New movie added successfully!');
                  }

                  Navigator.pop(dialogCtx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Add Movie',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColor.white),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            filled: true,
            fillColor: AppColor.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.themeColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.red),
            ),
          ),
        ),
      ],
    );
  }
}
