import 'package:flutter/cupertino.dart';

import '../../widgets/gradient_scaffold.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
