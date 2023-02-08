import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class RuCheckSectionData {
  final String title;

  final Iterable<Widget> menus;

  const RuCheckSectionData({
    required this.title,
    required this.menus,
  });
}

class RuCheckDrawer extends StatelessWidget {
  final String userName;
  final int selectedMenu;
  final ValueChanged<int>? onMenuChange;
  final List<RuCheckSectionData> sections;

  const RuCheckDrawer({
    Key? key,
    required this.userName,
    required this.selectedMenu,
    this.onMenuChange,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedMenu,
      onDestinationSelected: onMenuChange,
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: context.scaffoldColor),
                child: const Icon(MdiIcons.account, size: 48),
              ),
              Text('Bem vindo, $userName'),
            ],
          ),
        ),
        ...sections.expand(
          (data) => [_drawerSectionTitle(context, data.title), ...data.menus],
        ),
      ],
    );
  }

  Padding _drawerSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
