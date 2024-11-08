import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/profile/presentation/providers/profile_state_provider.dart';
import 'package:flutter_project/features/profile/presentation/providers/state/profile_state.dart';
import 'package:flutter_project/features/profile/presentation/widgets/profile_drawer.dart';
import 'package:flutter_project/routes/app_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = 'ProfileScreen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  bool isSearchActive = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void scrollControllerListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      final notifier = ref.read(profileNotifierProvider.notifier);
      if (isSearchActive) {
        notifier.searchProducts(searchController.text);
      } else {
        notifier.fetchProducts();
      }
    }
  }

  void refreshScrollControllerListener() {
    scrollController.removeListener(scrollControllerListener);
    scrollController.addListener(scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);

    ref.listen(
      profileNotifierProvider.select((value) => value),
      ((ProfileState? previous, ProfileState next) {
        //show Snackbar on failure
        if (next.state == ProfileConcreteState.fetchedAllProducts) {
          if (next.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(next.message.toString())));
          }
        }
      }),
    );
    return Scaffold(
      appBar: AppBar(
        title: isSearchActive
            ? TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                controller: searchController,
                onChanged: _onSearchChanged,
              )
            : const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {
                isSearchActive = !isSearchActive;
              });

              ref.read(profileNotifierProvider.notifier).resetState();
              if (!isSearchActive) {
                ref.read(profileNotifierProvider.notifier).fetchProducts();
              }
              refreshScrollControllerListener();
            },
            icon: Icon(
              isSearchActive ? Icons.clear : Icons.search,
            ),
          ),
        ],
      ),
      drawer: const ProfileDrawer(),
      body: state.state == ProfileConcreteState.loading
          ? const Center(child: CircularProgressIndicator())
          : state.hasData
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.productList.length,
                          itemBuilder: (context, index) {
                            final product = state.productList[index];
                            return ListTile(
                              title: const Text('Product'),
                              subtitle: Text(product.description),
                              onTap: () {
                                AutoRouter.of(context).push(
                                  ProfileRoute(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.state == ProfileConcreteState.fetchingMore)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(profileNotifierProvider.notifier).searchProducts(query);
    });
  }
}
