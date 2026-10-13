import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/show_time_model.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/show_time_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class AdminShowtimesScreen extends StatefulWidget {
  const AdminShowtimesScreen({super.key});

  @override
  State<AdminShowtimesScreen> createState() => _AdminShowtimesScreenState();
}

class _AdminShowtimesScreenState extends State<AdminShowtimesScreen> {
  String _selectedScreenFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final showTimeProvider = context.watch<ShowTimeProvider>();
    final movieProvider = context.watch<MovieProvider>();

    final showTimes = showTimeProvider.selectDateTime;

    final filteredShowTimes = showTimes.where((st) {
      if (_selectedScreenFilter == 'All') return true;
      return st.screen == _selectedScreenFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Showtime Management',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Schedule cinema showtimes, assign screens, prices and formats',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditShowtimeDialog(context),
                    icon: const Icon(
                      Icons.add_alarm_rounded,
                      color: AppColor.white,
                      size: 18,
                    ),
                    label: Text(
                      'Add Showtime',
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

              /// Filter Chips by Screen
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Audi 1', 'Audi 2', 'Audi 3'].map((screen) {
                    final isSelected = _selectedScreenFilter == screen;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(screen),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedScreenFilter = screen;
                            });
                          }
                        },
                        selectedColor: AppColor.themeColor,
                        backgroundColor: AppColor.cardColor,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: isSelected ? AppColor.white : AppColor.grey,
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

              /// Showtimes List / Cards
              Expanded(
                child: filteredShowTimes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 56,
                              color: AppColor.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No showtimes scheduled',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Click "Add Showtime" above to schedule new show slots.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredShowTimes.length,
                        itemBuilder: (context, index) {
                          final showTime = filteredShowTimes[index];
                          final originalIndex = showTimes.indexOf(showTime);

                          final defaultMovieName =
                              movieProvider.nowShowingMovies.isNotEmpty
                              ? movieProvider
                                    .nowShowingMovies[index %
                                        movieProvider.nowShowingMovies.length]
                                    .title
                              : 'Featured Movie';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Top Badges Row (Screen & Format)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.themeColor
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: AppColor.themeColor,
                                            ),
                                          ),
                                          child: Text(
                                            showTime.screen,
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                                  color: AppColor.themeColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.blue.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: AppColor.blue,
                                            ),
                                          ),
                                          child: Text(
                                            showTime.format,
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                                  color: AppColor.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      'NPR ${showTime.price}',
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColor.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                /// Showtime & Movie Title
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled,
                                      color: AppColor.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      showTime.time,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        'Movie: $defaultMovieName',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColor.textSecondary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                const Divider(
                                  color: AppColor.borderColor,
                                  height: 1,
                                ),

                                /// Actions Row (Edit / Delete)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () =>
                                          _showAddEditShowtimeDialog(
                                            context,
                                            showTimeToEdit: showTime,
                                            editIndex: originalIndex,
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
                                      onPressed: () => _confirmDeleteShowtime(
                                        context,
                                        originalIndex,
                                        showTime.time,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 16,
                                        color: AppColor.red,
                                      ),
                                      label: Text(
                                        'Remove',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(color: AppColor.red),
                                      ),
                                    ),
                                  ],
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

  void _confirmDeleteShowtime(BuildContext context, int index, String time) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Showtime',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the showtime at $time? Passengers/tickets for this slot will be affected.',
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
              context.read<ShowTimeProvider>().deleteShowTime(index);
              Navigator.pop(ctx);
              AppToast.showSuccess('Showtime deleted');
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

  void _showAddEditShowtimeDialog(
    BuildContext context, {
    ShowTimeModel? showTimeToEdit,
    int? editIndex,
  }) {
    final formKey = GlobalKey<FormState>();
    final isEditing = showTimeToEdit != null;

    final timeController = TextEditingController(
      text: isEditing ? showTimeToEdit.time : '10:30 AM',
    );
    final priceController = TextEditingController(
      text: isEditing ? showTimeToEdit.price : '700',
    );

    String selectedScreen = isEditing ? showTimeToEdit.screen : 'Audi 1';
    String selectedFormat = isEditing ? showTimeToEdit.format : 'IMAX 3D';

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
                isEditing ? Icons.edit_calendar : Icons.add_alarm_rounded,
                color: AppColor.themeColor,
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Edit Showtime' : 'Add Showtime',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Time Field
                    _buildFormField(
                      controller: timeController,
                      label: 'Show Time',
                      hint: 'e.g. 10:30 AM, 02:15 PM',
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Time is required'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    /// Screen Dropdown
                    Text(
                      'Auditorium / Screen',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedScreen,
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
                        DropdownMenuItem(
                          value: 'Audi 1',
                          child: Text('Audi 1 (Standard)'),
                        ),
                        DropdownMenuItem(
                          value: 'Audi 2',
                          child: Text('Audi 2 (VIP 3D)'),
                        ),
                        DropdownMenuItem(
                          value: 'Audi 3',
                          child: Text('Audi 3 (IMAX Grand)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedScreen = val;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Format Dropdown
                    Text(
                      'Projection Format',
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

                    /// Price Field
                    _buildFormField(
                      controller: priceController,
                      label: 'Ticket Price (NPR)',
                      hint: '700',
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Ticket price is required'
                          : null,
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
                  final model = ShowTimeModel(
                    time: timeController.text.trim(),
                    price: priceController.text.trim(),
                    screen: selectedScreen,
                    format: selectedFormat,
                    isAvailable: true,
                  );

                  final provider = context.read<ShowTimeProvider>();

                  if (isEditing && editIndex != null) {
                    provider.updateShowTime(editIndex, model);
                    AppToast.showSuccess('Showtime updated');
                  } else {
                    provider.addShowTime(model);
                    AppToast.showSuccess('Showtime scheduled');
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
                isEditing ? 'Save Changes' : 'Schedule Show',
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
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
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
