// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:ecosecha/components/animation/ScaleRoute.dart';
import 'package:ecosecha/components/widget/favorite_box_widget.dart';
import 'package:ecosecha/logica/producto.dart';
import 'package:ecosecha/styles/app_colors.dart';
import 'package:ecosecha/vista/producto_item_page.dart';
import 'package:flutter/material.dart';


class PopularItem extends StatelessWidget {
  const PopularItem({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, ScaleRoute(page: ItemPage(product.id)));
        },
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          height: 170,
          width: 220,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                child: _buildItemImage(),
              ),
              const Positioned(
                top: 0,
                right: 5,
                child: FavoriteBox(
                  isFavorited: false,
                ),
              ),
              Positioned(
                top: 140,
                child: _buildItemInfo(),
              )
            ],
          ),
        ));
  }

  _buildItemImage() {
    return Container(
      height: 120,
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(product.productImage),
        ),
      ),
    );
  }

  _buildItemInfo() {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.product,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                product.price.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
