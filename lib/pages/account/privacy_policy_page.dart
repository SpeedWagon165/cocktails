import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_arrowback.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Политика конфиденциальности',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Tempus sagittis dapibus ut amet. In facilisis eget ornare vulputate turpis consequat donec consequat. Sed imperdiet rhoncus sed eget pharetra ullamcorper tempus. In scelerisque arcu ultrices tortor eget dolor netus in risus.Lorem ipsum dolor sit amet consectetur. Tempus sagittis dapibus ut amet. In facilisis eget ornare vulputate turpis consequat donec consequat. Sed imperdiet rhoncus sed eget pharetra ullamcorper tempus. In scelerisque arcu ultrices tortor eget dolor netus in risus.',
              style: context.text.bodyText16White
                  .copyWith(color: Colors.white.withOpacity(0.85)),
            )
          ]),
        ),
      ),
    );
  }
}
