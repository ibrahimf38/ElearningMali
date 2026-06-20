class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final String backgroundColor;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'Apprenez À\nVotre Rythme',
    description:
        'Accédez à des cours, livres et tutoriels vidéo où que vous soyez.',
    imagePath: 'assets/images/image-3.png',
    backgroundColor: '#FFFFFF',
  ),
  OnboardingData(
    title: 'Progressez\nEfficacement',
    description:
        'Pratiquez avec des exercices corrigés et suivez votre évolution.',
    imagePath: 'assets/images/image-4.png',
    backgroundColor: '#FFFFFF',
  ),
  OnboardingData(
    title: 'Choisissez\nVotre Forfait',
    description:
        'Abonnez-vous selon vos besoins et apprenez sans limite.',
    imagePath: 'assets/images/image-5.png',
    backgroundColor: '#FFFFFF',
  ),
];