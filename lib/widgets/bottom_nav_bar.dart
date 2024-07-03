import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import '../pages/account/account_page.dart';
import '../pages/catalog/catalog_page.dart';
import '../pages/home/home_page.dart';
import '../pages/store/store_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<NavigatorState>> navigatorKeys = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
        if (state is HomePageState) {
          return _buildNavigator(0, const HomePage(), navigatorKeys[0]);
        } else if (state is CatalogPageState) {
          return _buildNavigator(1, const CatalogPage(), navigatorKeys[1]);
        } else if (state is StorePageState) {
          return _buildNavigator(2, const StorePage(), navigatorKeys[2]);
        } else if (state is AccountPageState) {
          return _buildNavigator(3, const AccountPage(), navigatorKeys[3]);
        } else {
          return const SizedBox();
        }
      }),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE76E24).withOpacity(0.15),
                    spreadRadius: 120,
                    blurRadius: 140,
                    offset: const Offset(0, 5),
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF0B0B0B),
                currentIndex: _getCurrentIndex(state),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToHome());
                      break;
                    case 1:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToCatalog());
                      break;
                    case 2:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToStore());
                      break;
                    case 3:
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(NavigateToAccount());
                      break;
                  }
                },
                items: [
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/home_icon.svg',
                    label: 'Главная',
                    isSelected: state is HomePageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/book_icon.svg',
                    label: 'Каталог',
                    isSelected: state is CatalogPageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/store_icon.svg',
                    label: 'Магазин',
                    isSelected: state is StorePageState,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/images/account_icon.svg',
                    label: 'Аккаунт',
                    isSelected: state is AccountPageState,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(icon,
              width: 18,
              height: 18,
              color: isSelected ? Colors.white : const Color(0xFFB7B7B7)),
          Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFB7B7B7)),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFFF8C82C),
                  Color(0xFFEF7F31),
                  Color(0xFFDD66A9),
                ],
              )),
              height: 3,
              width: 24,
            ),
          if (isSelected == false)
            const SizedBox(
              height: 7,
            )
        ],
      ),
      label: '',
    );
  }

  int _getCurrentIndex(BottomNavigationState state) {
    if (state is HomePageState) {
      return 0;
    } else if (state is CatalogPageState) {
      return 1;
    } else if (state is StorePageState) {
      return 2;
    } else if (state is AccountPageState) {
      return 3;
    } else {
      return 0;
    }
  }

  Widget _buildNavigator(
      int index, Widget child, GlobalKey<NavigatorState> key) {
    return Navigator(
      key: key,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
