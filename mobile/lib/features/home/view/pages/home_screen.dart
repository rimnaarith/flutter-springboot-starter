import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/features/auth/auth_provider.dart';
import 'package:fsp_starter/features/home/view/widgets/home_banner.dart';

class HomePage extends ConsumerWidget  {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20,),
              const HomeBanner(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                        color: Colors.black87,
                        fontWeight: .w600
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                        color: Colors.black45,
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: .horizontal,
                
                child: Row(
                  spacing: 16,
                  children: [
                    InkWell(child: Text('TEST'), onTap: () {
                      ref.read(authRepositoryProvider).test();
                    },),
                    Text('Text 2'),
                    Text('Text 3'),
                    Text('Text 4'),
                    Text('Text 5'),
                    Text('Text 6'),
                    Text('Text 7'),
                    Text('Text 8'),
                    Text('Text 9'),
                    Text('Text 10'),
                    Text('Text 11'),
                    Text('Text 12'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 40),

          Row(
            spacing: 16,
            children: [
              Stack(
                clipBehavior: .none,
                children: [
                  const Icon(Icons.favorite_outline, size: 28),
                  Positioned(
                    top: -5,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: .circle,
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                clipBehavior: .none,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 28),
                  Positioned(
                    top: -5,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: .circle,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Icon(Icons.search_outlined, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}