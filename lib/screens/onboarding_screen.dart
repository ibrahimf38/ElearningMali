import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/onboarding_model.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/connexion');
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isLastPage = provider.currentPage == onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── "Sauter" en haut à gauche, en vert ────────────────
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 16),
              child: AnimatedOpacity(
                opacity: isLastPage ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: isLastPage ? null : () => _navigateToLogin(context),
                  child: const Text(
                    'Sauter',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ── PageView ───────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: provider.pageController,
                itemCount: onboardingPages.length,
                onPageChanged: provider.setPage,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: onboardingPages[index]);
                },
              ),
            ),

            // ── Bottom bar : dots gauche | bouton droite ───────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dots alignés à gauche
                  DotsIndicator(
                    currentIndex: provider.currentPage,
                    count: onboardingPages.length,
                  ),

                  // Bouton Suivant / Commencez à droite
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLastPage
                          ? () => _navigateToLogin(context)
                          : () => context.read<OnboardingProvider>().nextPage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isLastPage ? 'Commencez' : 'Suivant',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}