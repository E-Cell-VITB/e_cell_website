import 'package:cached_network_image/cached_network_image.dart';
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
  int _speakersLength = 0; // Track the current number of speakers

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

  // Maps a card index to one of the 5 dots
  int _getActiveDotIndex(int cardIndex, int totalSpeakers) {
    if (totalSpeakers <= 5) {
      return cardIndex;
    }

    // For lists longer than 5 items, we need to map them to 5 dots
    // Calculate which segment each card belongs to
    double segmentSize = (totalSpeakers - 1) / 4; // 4 segments for 5 dots

    // Calculate which dot corresponds to the current card
    return (cardIndex / segmentSize).floor();
  }

  // Maps a dot index to the corresponding card index
  int _getCardIndexFromDot(int dotIndex, int totalSpeakers) {
    if (totalSpeakers <= 5) {
      return dotIndex < totalSpeakers ? dotIndex : totalSpeakers - 1;
    }

    // For lists longer than 5, calculate the card index
    double segmentSize = (totalSpeakers - 1) / 4; // 4 segments for 5 dots
    return (dotIndex * segmentSize).round();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final speakerProvider = Provider.of<SpeakerProvider>(context);

    return StreamBuilder<List<Speaker>>(
      stream: speakerProvider.getSpeakersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const SizedBox(
            height: 360,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 360,
            child: Center(
              child: Text(
                speakerProvider.error ?? 'Failed to load speakers',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // Get speakers data (empty list if null)
        final speakers = snapshot.data ?? [];

        // Update the speaker length for auto-scrolling
        if (_speakersLength != speakers.length) {
          _speakersLength = speakers.length;
        }

        // If the current page is now out of bounds (e.g., after data update),
        // reset to a valid page
        if (speakers.isNotEmpty && _currentPage >= speakers.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentPage = speakers.length - 1;
              _pageController.jumpToPage(_currentPage);
            });
          });
        }

        return SizedBox(
          height: 360,
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
                      ? const Center(child: Text('No speakers available'))
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: speakers.length,
                          itemBuilder: (context, index) {
                            return Center(
                                child: SpeakerCard(speaker: speakers[index]));
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
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 8,
                            width: 8,
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
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      margin: EdgeInsets.all(isMobile ? 12.0 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: eventBoxLinearGradient),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAA8A20), width: 1),
      ),
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: isMobile
          // Mobile layout (vertical orientation)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Speaker Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: speaker.imageUrl,
                    width: double.infinity,
                    height: 172,
                    fit: BoxFit.fill,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 172,
                        color: Colors.grey[800],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white60),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Speaker Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearGradientText(
                      child: Text(
                        speaker.name,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearGradientText(
                      child: Text(
                        speaker.designation,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            )
          // Desktop/tablet layout (horizontal orientation)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Speaker Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: speaker.imageUrl,
                    width: 180,
                    height: 240,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 240,
                        color: Colors.grey[800],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white60),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 24),
                // Speaker Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearGradientText(
                        child: Text(
                          speaker.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearGradientText(
                        child: Text(
                          speaker.designation,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        maxLines: 6,
                        speaker.about.trim(),
                        style: const TextStyle(
                          fontSize: 16,
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
