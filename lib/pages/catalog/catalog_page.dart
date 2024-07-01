import 'package:flutter/cupertino.dart';

import '../../widgets/gradient_scaffold.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientScaffold(
        body: SafeArea(
      child: SizedBox(
        height: 1,
      ),
    ));
  }
}
