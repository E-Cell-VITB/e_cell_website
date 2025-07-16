import 'package:e_cell_website/backend/models/speaker.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/speakers_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SpeakerCards extends StatefulWidget {
  const SpeakerCards({super.key});

  @override
  State<SpeakerCards> createState() => _SpeakerCardsState();
}

class _SpeakerCardsState extends State<SpeakerCards> {
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
  );
  bool _isScrolling = true;
  int _currentPage = 0;
  Timer? _timer;
  int _speakersLength = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });

    _pageController.addListener(() {
      if (!_pageController.hasClients) return;

      int next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_isScrolling && _pageController.hasClients && _speakersLength > 0) {
        if (_currentPage < _speakersLength - 1) {
          _pageController.nextPage(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  int _getActiveDotIndex(int cardIndex, int totalSpeakers) {
    if (totalSpeakers <= 5) {
      return cardIndex;
    }
    double segmentSize = (totalSpeakers - 1) / 4;
    return (cardIndex / segmentSize).floor();
  }

  int _getCardIndexFromDot(int dotIndex, int totalSpeakers) {
    if (totalSpeakers <= 5) {
      return dotIndex < totalSpeakers ? dotIndex : totalSpeakers - 1;
    }
    double segmentSize = (totalSpeakers - 1) / 4;
    return (dotIndex * segmentSize).round();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600 && size.width <= 1024;
    final isMobile = size.width <= 600;

    // Hide speakers section on tablet
    if (isTablet) {
      return const SizedBox.shrink();
    }

    final speakerProvider = Provider.of<SpeakerProvider>(context);

    return StreamBuilder<List<Speaker>>(
      stream: speakerProvider.getSpeakersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return SizedBox(
            height: size.height * 0.4,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: size.height * 0.4,
            child: Center(
              child: Text(
                speakerProvider.error ?? 'Failed to load speakers',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontSize: size.width * 0.04,
                    ),
              ),
            ),
          );
        }

        final speakers = snapshot.data ?? [];

        if (_speakersLength != speakers.length) {
          _speakersLength = speakers.length;
        }

        if (speakers.isNotEmpty && _currentPage >= speakers.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _currentPage = speakers.length - 1;
                _pageController.jumpToPage(_currentPage);
              });
            }
          });
        }

        return SizedBox(
          height: isMobile ? size.height * 0.495 : size.height * 0.55,
          width: size.width * 0.8,
          child: Column(
            children: [
              Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isScrolling = false),
                  onExit: (_) => setState(() {
                    _isScrolling = true;
                  }),
                  child: speakers.isEmpty
                      ? Center(
                          child: Text(
                            'No speakers available',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: size.width * 0.04,
                                ),
                          ),
                        )
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: speakers.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: SpeakerCard(speaker: speakers[index]),
                            );
                          },
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                        ),
                ),
              ),
              if (speakers.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      speakers.length <= 5 ? speakers.length : 5,
                      (dotIndex) {
                        bool isActive =
                            _getActiveDotIndex(_currentPage, speakers.length) ==
                                dotIndex;

                        return GestureDetector(
                          onTap: () {
                            final targetCardIndex =
                                _getCardIndexFromDot(dotIndex, speakers.length);
                            _pageController.animateToPage(
                              targetCardIndex,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            height: size.height * 0.01,
                            width: size.height * 0.01,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? const Color(0xFFAA8A20)
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SpeakerCard extends StatelessWidget {
  final Speaker speaker;

  const SpeakerCard({
    super.key,
    required this.speaker,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isMobile = screenWidth < 600;

    // Dynamic font sizes
    final nameFontSize = isMobile ? screenWidth * 0.03 : screenWidth * 0.02;
    final designationFontSize =
        isMobile ? screenWidth * 0.030 : screenWidth * 0.015;
    final aboutFontSize = isMobile ? screenWidth * 0.03 : screenWidth * 0.01;

    // Dynamic dimensions
    final margin = isMobile ? screenWidth * 0.03 : screenWidth * 0.01;
    final padding = isMobile ? screenWidth * 0.04 : screenWidth * 0.020;
    final borderRadius = screenWidth * 0.02;
    final imageWidth = isMobile ? double.infinity : screenWidth * 0.15;
    final imageHeight = isMobile ? screenHeight * 0.3 : screenHeight * 0.55;
    final spacing = screenHeight * 0.02;

    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: eventBoxLinearGradient),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFFAA8A20), width: 1),
      ),
      padding: EdgeInsets.all(padding),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius * 0.75),
                  child: Image.network(
                    speaker.imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white60,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        color: Colors.grey[800],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white60),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearGradientText(
                      child: Text(
                        speaker.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: spacing * 0.5),
                    LinearGradientText(
                      child: Text(
                        speaker.designation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: designationFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius * 0.75),
                  child: Image.network(
                    speaker.imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white60,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        color: Colors.grey[800],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white60),
                      );
                    },
                  ),
                ),
                SizedBox(width: spacing * 1.2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearGradientText(
                        child: Text(
                          speaker.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      LinearGradientText(
                        child: Text(
                          speaker.designation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: designationFontSize,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      SelectableText(
                        maxLines: 6,
                        speaker.about.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: aboutFontSize,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
