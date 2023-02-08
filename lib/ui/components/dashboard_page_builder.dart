import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/ui/components/ru_check_drawer.dart';

class DashboardPageSectionData {
  final String title;
  final List<DashboardPageData> pages;
  final Iterable<Widget> menus;

  const DashboardPageSectionData({
    required this.title,
    required this.pages,
    required this.menus,
  });
}

class DashboardPageData {
  final String title;
  final DashboardActionData? action;
  final WidgetBuilder contentBuilder;
  final WidgetBuilder? sideBuilder;

  const DashboardPageData({
    required this.title,
    this.action,
    required this.contentBuilder,
    this.sideBuilder,
  });
}

class DashboardActionData {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;

  const DashboardActionData(this.icon, this.label, this.onTap);
}

class DashboardPageBuilder extends StatefulWidget {
  final String userName;
  final List<DashboardPageSectionData> pageSections;

  const DashboardPageBuilder({
    Key? key,
    required this.pageSections,
    required this.userName,
  }) : super(key: key);

  @override
  State<DashboardPageBuilder> createState() => _DashboardPageBuilderState();
}

class _DashboardPageBuilderState extends State<DashboardPageBuilder> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: RuCheckDrawer(
                  userName: widget.userName,
                  selectedMenu: pageIndex,
                  onMenuChange: (index) => setState(() {
                    pageIndex = index;
                  }),
                  sections: widget.pageSections
                      .map(
                        (section) => RuCheckSectionData(
                          title: section.title,
                          menus: section.menus,
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _pages[pageIndex].title,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                              _dashboardAction(pageIndex),
                            ].whereNotNull().toList(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.all(12),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child:
                                    _pages[pageIndex].contentBuilder(context),
                              ),
                            ),
                          ),
                          _dashboardSide(
                              context, _pages[pageIndex].sideBuilder),
                        ].whereNotNull().toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DashboardPageData> get _pages {
    return widget.pageSections.expand((section) => section.pages).toList();
  }

  Widget? _dashboardAction(int index) {
    final action = _pages[index].action;
    if (action == null) return null;
    final icon = action.icon;
    if (icon == null) {
      return FilledButton(
        onPressed: action.onTap,
        style: const ButtonStyle(),
        child: Text(action.label),
      );
    }
    return FilledButton.icon(
      onPressed: action.onTap,
      style: const ButtonStyle(),
      icon: Icon(icon),
      label: Text(action.label),
    );
  }

  Widget? _dashboardSide(BuildContext context, WidgetBuilder? builder) {
    if (builder == null) return null;
    return Container(
      width: 360,
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: builder.call(context),
        ),
      ),
    );
  }
}
