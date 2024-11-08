import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/services/user_cache_service/domain/providers/current_user_provider.dart';
import 'package:flutter_project/services/user_cache_service/domain/providers/user_cache_provider.dart';
import 'package:flutter_project/shared/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/app_route.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    return SafeArea(
      bottom: false,
      child: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              accountName: Text(
                '${currentUser?.id}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              accountEmail: Text(
                '${currentUser?.email}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://ui-avatars.com/api/?background=random&name=${currentUser?.email}'),
              ),
              otherAccountsPictures: [
                InkWell(
                  onTap: () async {
                    await ref.read(userLocalRepositoryProvider).deleteUser();
                    // ignore: use_build_context_synchronously
                    AutoRouter.of(context).pushAndPopUntil(
                      LoginRoute(),
                      predicate: (_) => false,
                    );
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.logout,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(appThemeProvider.notifier).toggleTheme();
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                )
              ],
            ),
            // Add a menu with links to the different pages
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                AutoRouter.of(context).pushAndPopUntil(
                  DashboardRoute(),
                  predicate: (_) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Profile'),
              onTap: () {
                AutoRouter.of(context).pushAndPopUntil(
                  ProfileRoute(),
                  predicate: (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
