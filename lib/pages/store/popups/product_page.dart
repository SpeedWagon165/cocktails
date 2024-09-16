import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/auth/custom_registration_button.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/store/expandable_text.dart';

void productPagePopUp(BuildContext context, Map<String, dynamic> product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: product['name'] ?? 'Товар',
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: AspectRatio(
                aspectRatio: 1,
                child: product['photo'] != null
                    ? Image.network(
                        product['photo'],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 190,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ExpandableTextWidget(
              text: product['description'],
              titleText: 'Описание',
            ),
            const SizedBox(
              height: 24,
            ),
            // Создание кнопок для маркетплейсов
            if (product['links'] != null)
              ...product['links'].entries.map((entry) {
                String marketplaceName;
                switch (entry.key) {
                  case 'wildberries':
                    marketplaceName = 'Wildberries';
                    break;
                  case 'ozon':
                    marketplaceName = 'Ozon';
                    break;
                  case 'yandex':
                    marketplaceName = 'Яндекс Маркет';
                    break;
                  default:
                    marketplaceName = entry.key;
                }

                return Column(
                  children: [
                    RegistrationServicesButton(
                      text: 'Купить на $marketplaceName',
                      trailingText: '  ${entry.value['price']} ₽',
                      onPressed: () {
                        final url = entry.value['link'];
                        if (url != null) {
                          launchUrl(Uri.parse(url));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                );
              }).toList(),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
