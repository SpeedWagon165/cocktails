import 'package:flutter/material.dart';

import '../navigator/filter_navigator.dart';

void openFilterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const SingleChildScrollView(
        child: FilterNavigator(),
      );
    },
  );
}
