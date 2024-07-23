import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/providers&state/categories_provider.dart';
import 'package:scarpetta/services/cookbook_service.dart';
import 'package:scarpetta/util/breakpoint.dart';

class CategoriesPage extends StatefulWidget {
  final Function(Category)? onCategoryTap;
  final bool push;

  const CategoriesPage({super.key, this.onCategoryTap, this.push = false});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final int _pageSize = 10;

  final PagingController<String?, Category> _pagingController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }


  Future<void> _fetchPage(String? pageKey) async {
    try {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      final newItems = await provider.fetchCategories(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems.last.id;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context){
    //final state = ref.watch(categoriesProvider);

    double width = MediaQuery.of(context).size.width;
    double topPadding = 30.0;
    double xPadding = 30.0;
    int gridColumns = 3;
    bool isDesktop = false;
    if (width > Breakpoint.lg) {
      if (widget.push) {
        gridColumns = 2;
      }
      xPadding = 10.0;
      isDesktop = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Categories"),
        centerTitle: true,
        actions: [
          if (!isDesktop || !widget.push)
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsRegular.x),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return RefreshIndicator(
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: PagedGridView(
              pagingController: _pagingController,
              clipBehavior: Clip.none,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1.0,
              ),
              padding: EdgeInsets.only(top: topPadding, left: xPadding, right: xPadding),
              builderDelegate: PagedChildBuilderDelegate<Category>(
                itemBuilder: (context, category, index) {
                  return CategoryIndicator(
                    category: category,
                    onTap: widget.onCategoryTap,
                    push: widget.push,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}