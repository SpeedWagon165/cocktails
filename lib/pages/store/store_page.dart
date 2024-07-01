import 'package:flutter/cupertino.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import '../../widgets/gradient_scaffold.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

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
