import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/models/filter.dart';

class AddCategoriesToFilterStateAction {
  final List<Category> categoriesPayload;

  AddCategoriesToFilterStateAction(this.categoriesPayload);
}

class SaveFilterPostTypesAction {
  final List<Filter> postTypesPayload;
  final int index;

  SaveFilterPostTypesAction(this.postTypesPayload, this.index);
}

class SaveFilterSortTypeAction {
  final List<Filter> sortTypesPayload;
  final int index;

  SaveFilterSortTypeAction(this.sortTypesPayload, this.index);
}

class SaveFilterCategoriesAction {
  final List<Category> categoriesPayload;
  final int index;

  SaveFilterCategoriesAction(this.categoriesPayload, this.index);
}
