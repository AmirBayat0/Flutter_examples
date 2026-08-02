// =============================================================================
// TASKFLOW — A Premium Task Management & Productivity Dashboard
// -----------------------------------------------------------------------------
// This single-file Flutter application demonstrates real-world usage of the
// `pro_dialog` package (https://pub.dev/packages/pro_dialog) as its primary
// dialog/feedback system.
//
// pro_dialog features used in this app:
//   • showProDialog()      -> fully custom dialogs (create/edit task form,
//                              delete confirmation, theme picker, notification
//                              settings, about screen)
//   • showSuccessDialog()  -> quick success feedback (task created/completed)
//   • DialogType           -> success, warning, question, info, custom
//   • DialogButton         -> primary / secondary action buttons
//   • ProDialogTheme       -> glassmorphism, gradients, border radius,
//                              animation style, icon animation style
//   • DialogAnimationStyle -> bounce, scale, slideUp, fade
//   • IconAnimationStyle   -> pulse, bounce, rotate, shake
//   • customContent        -> arbitrary widgets (forms, switches, pickers)
//     injected directly into the dialog body
//
// The rest of the app (task list, filters, search, stats) is built with
// pure Flutter/Material 3 to create a believable, production-style shell
// around the dialog package.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_dialog/pro_dialog.dart';

void main() {
  runApp(const TaskFlowApp());
}

// =============================================================================
// DOMAIN MODELS
// =============================================================================

/// Priority levels available for a task. Each carries its own color + label
/// so UI code never has to branch on raw strings.
enum TaskPriority { low, medium, high }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF22C55E);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.high:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward_rounded;
      case TaskPriority.medium:
        return Icons.remove_rounded;
      case TaskPriority.high:
        return Icons.arrow_upward_rounded;
    }
  }
}

/// A single task. Kept intentionally simple since this is an in-memory demo
/// (no backend / persistence is required for this showcase app).
class Task {
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  String title;
  String description;
  TaskPriority priority;
  bool isCompleted;
  final DateTime createdAt;
}

// =============================================================================
// APP ROOT — theme + light/dark mode support
// =============================================================================

class TaskFlowApp extends StatefulWidget {
  const TaskFlowApp({super.key});

  @override
  State<TaskFlowApp> createState() => _TaskFlowAppState();
}

class _TaskFlowAppState extends State<TaskFlowApp> {
  // Local, in-memory theme mode state. Changed from the Settings dialog.
  ThemeMode _themeMode = ThemeMode.light;

  static const Color _seed = Color(0xFF6366F1); // Indigo — premium accent

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: DashboardScreen(
        onThemeModeChanged: _updateThemeMode,
        themeMode: _themeMode,
      ),
    );
  }
}

// =============================================================================
// DASHBOARD SCREEN — main scaffold: search, filters, task list, stats, FAB
// =============================================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.onThemeModeChanged,
    required this.themeMode,
  });

  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ThemeMode themeMode;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ---------------------------------------------------------------------
  // In-memory state
  // ---------------------------------------------------------------------
  final List<Task> _tasks = [
    Task(
      id: 't1',
      title: 'Design onboarding flow',
      description: 'Create wireframes for the new user onboarding experience.',
      priority: TaskPriority.high,
    ),
    Task(
      id: 't2',
      title: 'Fix login bug on iOS',
      description: 'Users report the app crashes after biometric auth fails.',
      priority: TaskPriority.high,
    ),
    Task(
      id: 't3',
      title: 'Write weekly report',
      description: 'Summarize sprint progress for stakeholders.',
      priority: TaskPriority.medium,
    ),
    Task(
      id: 't4',
      title: 'Review pull requests',
      description: 'Check open PRs from the mobile team.',
      priority: TaskPriority.low,
      isCompleted: true,
    ),
  ];

  String _searchQuery = '';
  TaskPriority? _priorityFilter; // null = show all
  bool _isLoading = true; // simulated initial loading state
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Simulate a short initial data load so we can showcase a loading state.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  // ---------------------------------------------------------------------
  // Derived data
  // ---------------------------------------------------------------------
  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      final matchesQuery =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPriority =
          _priorityFilter == null || task.priority == _priorityFilter;
      return matchesQuery && matchesPriority;
    }).toList()..sort(
      (a, b) => a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1),
    );
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _tasks.length - _completedCount;

  // =========================================================================
  // DIALOG #1 — CREATE / EDIT TASK  (pro_dialog: DialogType.custom)
  // =========================================================================
  //
  // We build a fully custom form (title, description, priority selector)
  // and inject it via `customContent`. Controllers are created here (in the
  // calling scope) so the `DialogButton` callbacks — which live outside the
  // form widget — can still read the entered values when "Save" is tapped.
  void _showTaskFormDialog({Task? existingTask}) {
    final bool isEditing = existingTask != null;
    final titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final descController = TextEditingController(
      text: existingTask?.description ?? '',
    );
    final priorityNotifier = ValueNotifier<TaskPriority>(
      existingTask?.priority ?? TaskPriority.medium,
    );

    showProDialog(
      context,
      type: DialogType.custom,
      title: isEditing ? 'Edit Task' : 'Create New Task',
      barrierDismissible: true,
      theme: const ProDialogTheme(
        useGradientBackground: true,
        borderRadius: 28,
        animationStyle: DialogAnimationStyle.slideUp,
        iconAnimationStyle: IconAnimationStyle.bounce,
      ),
      customContent: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DialogTextField(
                controller: titleController,
                label: 'Task title',
                icon: Icons.title_rounded,
                autofocus: true,
              ),
              const SizedBox(height: 14),
              _DialogTextField(
                controller: descController,
                label: 'Description',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: 18),
              const Text(
                'Priority',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<TaskPriority>(
                valueListenable: priorityNotifier,
                builder: (context, selected, _) {
                  return Row(
                    children: TaskPriority.values.map((p) {
                      final bool isSelected = p == selected;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            priorityNotifier.value = p;
                            HapticFeedback.selectionClick();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? p.color.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? p.color
                                    : Colors.grey.withValues(alpha: 0.3),
                                width: isSelected ? 1.6 : 1,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  p.icon,
                                  size: 16,
                                  color: isSelected ? p.color : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? p.color : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
      buttons: [
        DialogButton(
          text: 'Cancel',
          style: DialogButtonStyle.outlined,
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: isEditing ? 'Save Changes' : 'Create Task',
          isPrimary: true,
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isEmpty) return; // simple inline validation guard

            setState(() {
              if (isEditing) {
                existingTask.title = title;
                existingTask.description = descController.text.trim();
                existingTask.priority = priorityNotifier.value;
              } else {
                _tasks.insert(
                  0,
                  Task(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    title: title,
                    description: descController.text.trim(),
                    priority: priorityNotifier.value,
                  ),
                );
              }
            });

            Navigator.pop(context); // close the form dialog
            _showTaskSavedSuccessDialog(isEditing: isEditing);
          },
        ),
      ],
    );
  }

  // =========================================================================
  // DIALOG #2 — SUCCESS FEEDBACK AFTER SAVE (pro_dialog: showSuccessDialog)
  // =========================================================================
  void _showTaskSavedSuccessDialog({required bool isEditing}) {
    showSuccessDialog(
      context,
      title: isEditing ? 'Task Updated' : 'Task Created',
      description: isEditing
          ? 'Your changes have been saved successfully.'
          : 'Your new task has been added to the board.',
    );
  }

  // =========================================================================
  // DIALOG #3 — DELETE CONFIRMATION (pro_dialog: DialogType.warning)
  // =========================================================================
  void _showDeleteConfirmationDialog(Task task) {
    showProDialog(
      context,
      type: DialogType.warning,
      title: 'Delete Task?',
      description:
          'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
      theme: const ProDialogTheme(
        borderRadius: 26,
        animationStyle: DialogAnimationStyle.bounce,
        iconAnimationStyle: IconAnimationStyle.shake,
      ),
      buttons: [
        DialogButton(
          text: 'Cancel',
          style: DialogButtonStyle.text,
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: 'Delete',
          isPrimary: true,
          onPressed: () {
            setState(() => _tasks.removeWhere((t) => t.id == task.id));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // =========================================================================
  // DIALOG #4 — TASK COMPLETED CELEBRATION (pro_dialog: DialogType.success)
  // =========================================================================
  void _showTaskCompletedDialog(Task task) {
    showProDialog(
      context,
      type: DialogType.success,
      title: 'Great job! 🎉',
      description: '"${task.title}" is complete. Keep up the momentum!',
      autoDismissAfter: const Duration(seconds: 2),
      theme: const ProDialogTheme(
        useGlassmorphism: true,
        borderRadius: 30,
        animationStyle: DialogAnimationStyle.bounce,
        iconAnimationStyle: IconAnimationStyle.pulse,
      ),
      buttons: [
        DialogButton(
          text: 'Nice!',
          isPrimary: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _toggleTaskCompletion(Task task) {
    setState(() => task.isCompleted = !task.isCompleted);
    if (task.isCompleted) _showTaskCompletedDialog(task);
  }

  // =========================================================================
  // DIALOG #5 — SETTINGS: THEME SELECTION (pro_dialog: DialogType.custom)
  // =========================================================================
  void _showThemeSelectionDialog() {
    final modeNotifier = ValueNotifier<ThemeMode>(widget.themeMode);

    showProDialog(
      context,
      type: DialogType.custom,
      title: 'Choose Appearance',
      theme: const ProDialogTheme(
        borderRadius: 26,
        animationStyle: DialogAnimationStyle.scale,
      ),
      customContent: ValueListenableBuilder<ThemeMode>(
        valueListenable: modeNotifier,
        builder: (context, mode, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOptionTile(
                label: 'Light Mode',
                icon: Icons.light_mode_rounded,
                selected: mode == ThemeMode.light,
                onTap: () => modeNotifier.value = ThemeMode.light,
              ),
              const SizedBox(height: 10),
              _ThemeOptionTile(
                label: 'Dark Mode',
                icon: Icons.dark_mode_rounded,
                selected: mode == ThemeMode.dark,
                onTap: () => modeNotifier.value = ThemeMode.dark,
              ),
              const SizedBox(height: 10),
              _ThemeOptionTile(
                label: 'System Default',
                icon: Icons.settings_suggest_rounded,
                selected: mode == ThemeMode.system,
                onTap: () => modeNotifier.value = ThemeMode.system,
              ),
            ],
          );
        },
      ),
      buttons: [
        DialogButton(
          text: 'Cancel',
          style: DialogButtonStyle.text,
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: 'Apply',
          isPrimary: true,
          onPressed: () {
            widget.onThemeModeChanged(modeNotifier.value);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // =========================================================================
  // DIALOG #6 — SETTINGS: NOTIFICATION PREFERENCES (pro_dialog: custom)
  // =========================================================================
  void _showNotificationSettingsDialog() {
    final enabledNotifier = ValueNotifier<bool>(_notificationsEnabled);
    final remindersNotifier = ValueNotifier<bool>(true);
    final soundsNotifier = ValueNotifier<bool>(false);

    showProDialog(
      context,
      type: DialogType.custom,
      title: 'Notification Settings',
      theme: const ProDialogTheme(
        borderRadius: 26,
        useGradientBackground: true,
        animationStyle: DialogAnimationStyle.slideUp,
      ),
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SwitchRow(
            label: 'Push Notifications',
            valueListenable: enabledNotifier,
          ),
          _SwitchRow(
            label: 'Daily Reminders',
            valueListenable: remindersNotifier,
          ),
          _SwitchRow(label: 'Sound Effects', valueListenable: soundsNotifier),
        ],
      ),
      buttons: [
        DialogButton(
          text: 'Close',
          style: DialogButtonStyle.outlined,
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: 'Save',
          isPrimary: true,
          onPressed: () {
            setState(() => _notificationsEnabled = enabledNotifier.value);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // =========================================================================
  // DIALOG #7 — SETTINGS: ABOUT (pro_dialog: DialogType.info)
  // =========================================================================
  void _showAboutDialog() {
    showProDialog(
      context,
      type: DialogType.info,
      title: 'About TaskFlow',
      description:
          'TaskFlow v1.0.0 — a productivity dashboard built with Flutter '
          'and powered by the pro_dialog package for beautiful, animated dialogs.',
      theme: const ProDialogTheme(
        borderRadius: 26,
        animationStyle: DialogAnimationStyle.fade,
        iconAnimationStyle: IconAnimationStyle.rotate,
      ),
      buttons: [
        DialogButton(
          text: 'Got it',
          isPrimary: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // =========================================================================
  // DIALOG #8 — SETTINGS MENU ENTRY POINT (pro_dialog: DialogType.custom)
  // =========================================================================
  void _showSettingsDialog() {
    showProDialog(
      context,
      type: DialogType.custom,
      title: 'Settings',
      theme: const ProDialogTheme(
        borderRadius: 28,
        animationStyle: DialogAnimationStyle.scale,
      ),
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SettingsMenuTile(
            icon: Icons.palette_rounded,
            label: 'Appearance',
            onTap: () {
              Navigator.pop(context);
              _showThemeSelectionDialog();
            },
          ),
          _SettingsMenuTile(
            icon: Icons.notifications_active_rounded,
            label: 'Notifications',
            onTap: () {
              Navigator.pop(context);
              _showNotificationSettingsDialog();
            },
          ),
          _SettingsMenuTile(
            icon: Icons.info_outline_rounded,
            label: 'About',
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
        ],
      ),
      buttons: [
        DialogButton(
          text: 'Close',
          style: DialogButtonStyle.text,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // =========================================================================
  // BUILD
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(colorScheme),
            SliverToBoxAdapter(child: _buildStatsRow(colorScheme)),
            SliverToBoxAdapter(child: _buildSearchAndFilters(colorScheme)),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredTasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(colorScheme),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = _filteredTasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _TaskCard(
                        task: task,
                        onToggleComplete: () => _toggleTaskCompletion(task),
                        onEdit: () => _showTaskFormDialog(existingTask: task),
                        onDelete: () => _showDeleteConfirmationDialog(task),
                      ),
                    );
                  }, childCount: _filteredTasks.length),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(colorScheme),
    );
  }

  // ---------------------------------------------------------------------
  // UI sections
  // ---------------------------------------------------------------------
  Widget _buildHeader(ColorScheme colorScheme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.checklist_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TaskFlow',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Stay productive, stay organized',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _showSettingsDialog,
              icon: const Icon(Icons.settings_rounded),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total',
              value: _tasks.length.toString(),
              icon: Icons.dashboard_rounded,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Pending',
              value: _pendingCount.toString(),
              icon: Icons.pending_actions_rounded,
              color: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Done',
              value: _completedCount.toString(),
              icon: Icons.task_alt_rounded,
              color: const Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _priorityFilter == null,
                  onTap: () => setState(() => _priorityFilter = null),
                ),
                ...TaskPriority.values.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FilterChip(
                      label: p.label,
                      color: p.color,
                      selected: _priorityFilter == p,
                      onTap: () => setState(() => _priorityFilter = p),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    final bool isFiltering = _searchQuery.isNotEmpty || _priorityFilter != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltering
                    ? Icons.search_off_rounded
                    : Icons.checklist_rtl_rounded,
                size: 42,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isFiltering ? 'No matching tasks' : 'No tasks yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltering
                  ? 'Try a different search term or filter.'
                  : 'Tap the + button to create your first task.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showTaskFormDialog(),
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// =============================================================================
// REUSABLE PRESENTATIONAL WIDGETS
// =============================================================================

/// A single stat summary card shown at the top of the dashboard.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

/// Selectable filter chip used for the priority filter row.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? activeColor
              : Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Card representing a single task row in the list.
class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onToggleComplete,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? const Color(0xFF22C55E)
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? const Color(0xFF22C55E)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: task.priority.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            task.priority.icon,
                            size: 12,
                            color: task.priority.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.priority.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: task.priority.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: Colors.grey.shade400,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A text field styled for use inside pro_dialog custom content.
class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// A tappable row used inside the theme-selection dialog.
class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.12)
              : Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? primary : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? primary : null,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 20, color: primary),
          ],
        ),
      ),
    );
  }
}

/// A labeled switch row used inside the notification-settings dialog.
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.label, required this.valueListenable});

  final String label;
  final ValueNotifier<bool> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Switch(value: value, onChanged: (v) => valueListenable.value = v),
            ],
          ),
        );
      },
    );
  }
}

/// A menu row used inside the top-level Settings dialog.
class _SettingsMenuTile extends StatelessWidget {
  const _SettingsMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
