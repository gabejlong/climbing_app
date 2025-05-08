abstract class BaseFilters {
  String selectedSort;
  Set<String> selectedTypeFilters;
  Set<String> selectedLocationFilters;

  BaseFilters({
    this.selectedSort = "Old to New",
    Set<String>? selectedTypeFilters,
    Set<String>? selectedLocationFilters,
  })  : selectedTypeFilters = selectedTypeFilters ?? {},
        selectedLocationFilters = selectedLocationFilters ?? {};

  List<String> toList();
}

class ClimbFilters extends BaseFilters {
  double lowGrade;
  double highGrade;
  Set<String> selectedAttemptsFilters;
  Set<String> selectedTagsFilters;

  ClimbFilters({
    this.lowGrade = 0,
    this.highGrade = 17,
    String selectedSort = "Old to New",
    Set<String>? selectedTypeFilters,
    Set<String>? selectedAttemptsFilters,
    Set<String>? selectedLocationFilters,
    Set<String>? selectedTagsFilters,
  })  : selectedAttemptsFilters = selectedAttemptsFilters ?? {},
        selectedTagsFilters = selectedTagsFilters ?? {},
        super(
          selectedSort: selectedSort,
          selectedTypeFilters: selectedTypeFilters,
          selectedLocationFilters: selectedLocationFilters,
        );

  List<String> toList() {
    List<String> filters = [];
    if (!(lowGrade == 0 && highGrade == 17)) {
      filters.add(("V" +
          lowGrade.toStringAsFixed(0) +
          " to V" +
          highGrade.toStringAsFixed(0)));
    }
    filters.addAll(
        selectedTypeFilters.length == 1 ? selectedTypeFilters.toList() : {});
    filters.addAll(selectedAttemptsFilters.toList());
    filters.addAll(selectedLocationFilters.toList());
    filters.addAll(selectedTagsFilters.toList());
    return filters;
  }
}

class SessionFilters extends BaseFilters {
  SessionFilters({
    String selectedSort = "default",
    Set<String>? selectedTypeFilters,
    Set<String>? selectedLocationFilters,
  }) : super(
          selectedSort: selectedSort,
          selectedTypeFilters: selectedTypeFilters,
          selectedLocationFilters: selectedLocationFilters,
        );

  List<String> toList() {
    List<String> filters = [];
    filters.addAll(selectedTypeFilters.length == 2
        ? selectedTypeFilters.toList()
        : {"Mixed"});
    filters.addAll(selectedLocationFilters.toList());
    return filters;
  }
}
