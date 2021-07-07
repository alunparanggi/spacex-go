import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom sliver app bar used in Sliver views.
/// It collapses when user scrolls down.
class SliverBar extends StatelessWidget {
  static const double heightRatio = 0.3;

  final String title;
  final Widget header;
  final num height;
  final List<Widget> actions;
  final PopupMenuItemBuilder<String> menuItemBuilder;
  final PopupMenuItemSelected<String> onMenuItemSelected;

  const SliverBar({
    this.title,
    this.header,
    this.height = heightRatio,
    this.actions,
    this.menuItemBuilder,
    this.onMenuItemSelected,
  });

  // ignore: missing_return
  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * height,
      leading: Navigator.of(context).canPop()
          ? useCloseButton
              ? IconButton(
                  icon: const IconShadow(Icons.close),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                )
              : IconButton(
                  icon: IconShadow(_getIconData(Theme.of(context).platform)),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                )
          : null,
      actions: [
        ...actions,
        if (menuItemBuilder != null && onMenuItemSelected != null)
          PopupMenuButton<String>(
            itemBuilder: menuItemBuilder,
            onSelected: onMenuItemSelected,
            child: IconShadow(
              Icons.more_vert,
              padding: const EdgeInsets.all(8.0),
            ),
          ),
      ],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Using title constraining, because Flutter doesn't do this automatically.
        // Open issue: [https://github.com/flutter/flutter/issues/14227]
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.55,
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        background: header,
      ),
    );
  }
}