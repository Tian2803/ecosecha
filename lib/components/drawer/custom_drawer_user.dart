import 'package:ecosecha/components/custom/custom_list_tile.dart';
import 'package:ecosecha/components/drawer/bottom_user_info.dart';
import 'package:ecosecha/components/drawer/header.dart';
import 'package:ecosecha/vista/home_view_usuario.dart';
import 'package:ecosecha/vista/order_view.dart';
import 'package:ecosecha/vista/vista_pedido.dart';
import 'package:flutter/material.dart';

class CustomDrawerUser extends StatefulWidget {
  const CustomDrawerUser({super.key});

  @override
  State<CustomDrawerUser> createState() => _CustomDrawerUserState();
}

class _CustomDrawerUserState extends State<CustomDrawerUser> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreenUser()));
                },
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.shopping_cart_rounded,
                title: 'Orders',
                infoCount: 0,
                onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderView()));},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.pin_drop,
                title: 'Destinations',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                onTap: () {},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.message_rounded,
                title: 'Messages',
                infoCount: 8,
                onTap: () {},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.cloud,
                title: 'Weather',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                onTap: () {},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.history_sharp,
                title: 'Historial',
                infoCount: 0,
                //doHaveMoreOptions: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Historial()));
                },
              ),
              const Divider(color: Colors.grey),
              const Spacer(),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                infoCount: 2,
                onTap: () {},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.settings,
                title: 'Settings',
                infoCount: 0,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              BottomUserInfo(
                isCollapsed: _isCollapsed,
              ),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
