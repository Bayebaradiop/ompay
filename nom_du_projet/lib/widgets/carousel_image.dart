import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({super.key});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/img4.jpeg',
      'title': "Transférer de l'argent",
      'description': "Envoyez rapidement et en toute sécurité de l'argent à un proche qui possède un compte Orange Money."
    },
    {
      'image': 'assets/images/img2.jpeg',
      'title': "Payer un marchand",
      'description': 'Payez plus simplement et rapidement vos courses en scannant le QR code chez tous les commerçants agréés Orange Money'
    },
    {
      'image': 'assets/images/img3.jpeg',
      'title': "Consulter votre solde",
      'description': 'Accédez au solde de votre compte Orange Money dès votre authentification. Affichez ou masquez-le à votre convenance'
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        int nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:270,
      child: Stack(
        children: [
          // PageView pour le défilement
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index]);
            },
          ),

          // Indicateurs de page
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => _buildIndicator(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Construction d'un slide individuel
  Widget _buildSlide(Map<String, String> slide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image avec gestion d'erreur
          Image.asset(
            slide['image']!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[400],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                      const SizedBox(height: 10),
                      Text(
                        'Image non trouvée',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        slide['image']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Overlay sombre
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Texte
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide['description']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Indicateur de page (point)
  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFFFF6600)
            : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
