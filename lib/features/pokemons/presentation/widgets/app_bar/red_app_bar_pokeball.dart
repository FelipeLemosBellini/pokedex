import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/assets/app_assets.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class RedAppBarPokeball extends StatelessWidget {
  const RedAppBarPokeball({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 612,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Container(
              height: 148,
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pokédex",
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.1125,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  SvgPicture.asset(AppAssets.pokeball),
                ],
              ),
            ),
          ),
          Image.asset(
            AppAssets.koraidon,
            alignment: Alignment.centerLeft,
            height: 584,
            width: 584,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore o incrível \nmundo dos Pokémon. ",
                    style: TextStyle(fontSize: 32, height: 1.1125),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Descubra informações detalhadas sobre seus personagens favoritos.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                      letterSpacing: 0.32,
                    ),
                  ),
                  SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '+1000k ',
                          style: TextStyle(
                            height: 1.1,
                            fontSize: 40,
                            color: AppColors.red,
                          ),
                        ),
                        TextSpan(
                          text: 'Pokemons',
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
