// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers
import 'package:ecosecha/components/items/bottombar_item.dart';
import 'package:ecosecha/styles/app_colors.dart';
import 'package:ecosecha/vista/home_view_campesino.dart';
import 'package:ecosecha/vista/product_register.dart';
import 'package:ecosecha/vista/profile_page_farmer.dart';
import 'package:flutter/material.dart';

class NavBarCampesino extends StatefulWidget {
  const NavBarCampesino({super.key});

  @override
  _NavBarOwnerState createState() => _NavBarOwnerState();
}

class _NavBarOwnerState extends State<NavBarCampesino> {
  int _activeTab = 0;

  final List<IconData> _tapIcons = [
    Icons.home_rounded,
    Icons.add_box_outlined,
    Icons.person_rounded
  ];

  final List<Widget> _pages = [
    const HomeScreenFarmer(),
    const RegisterProduct(),
    const ProfilePageCampesino(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.whiteshade,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: .5,
            spreadRadius: .5,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _tapIcons.length,
          (index) => BottomBarItem(
            _tapIcons[index],
            isActive: _activeTab == index,
            activeColor: AppColors.primary,
            onTap: () {
              setState(() {
                _activeTab = index;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => _pages[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
