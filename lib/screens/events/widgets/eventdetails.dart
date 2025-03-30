// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/speakerbox.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = (size.width < 500) ? true : false;
    return ParticleBackground(
      child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: (isMobile) ? 400 : size.width * 0.9,
                      height: (isMobile) ? 80 : size.width * 0.13,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(colors: linerGradient),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: List.generate(
                            widget.event.allPhotos.length < 3
                                ? widget.event.allPhotos.length
                                : 3,
                            (generatorIndex) {
                              return Expanded(
                                child: SizedBox(
                                  height: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.event.allPhotos[generatorIndex],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: secondaryColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.image),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (isMobile) ? 82 : 180,
                  ),
                  SizedBox(
                    width: isMobile ? size.width : size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeadingWidget(
                            text: "${widget.event.numParticipants.toString()}+",
                            theme: "Participants",
                          ),
                          HeadingWidget(
                            text: "${widget.event.numTeams.toString()}+",
                            theme: "Teams",
                          ),
                          HeadingWidget(
                            text: "\u20B9 ${widget.event.prizePool.toString()}",
                            theme: "Prize pool",
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (isMobile) ? 30 : 60,
                  ),

                  //location block
                  Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isMobile ? 10 : 20,
                      runSpacing: isMobile ? 10 : 15,
                      children: [
                        GradientBox(
                          height: isMobile ? 36 : 50,
                          radius: 25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: isMobile ? 14 : 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: isMobile ? 6 : 10),
                                Text(
                                  DateFormat("MMM dd, yyyy")
                                      .format(widget.event.eventDate),
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GradientBox(
                          height: isMobile ? 36 : 50,
                          radius: 25,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: isMobile ? 14 : 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: isMobile ? 6 : 10),
                                Text(
                                  widget.event.place,
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (isMobile) ? 30 : 60,
                  ),

                  //event Speakers Block
                  if (widget.event.guestsAndJudges.isNotEmpty)
                    Column(
                      children: [
                        LinearGradientText(
                            child: Text("Guests & Judges",
                                style: TextStyle(
                                    fontSize: (isMobile) ? 20 : 36,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Center(
                            child: Wrap(
                              spacing: 30,
                              runSpacing: 40,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                  widget.event.guestsAndJudges.length, (index) {
                                GuestOrJudge guestOrJudge =
                                    widget.event.guestsAndJudges[index];
                                return Speakerbox(
                                  guestOrJudge: guestOrJudge,
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (isMobile) ? 30 : 60,
                        ),
                      ],
                    ),

                  SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearGradientText(
                            child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: (isMobile) ? 20 : 36,
                              fontWeight: FontWeight.bold),
                        )),
                        SizedBox(
                          height: 40,
                        ),
                        MasonryGridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 3,
                          ),
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          itemCount: widget.event.allPhotos.length,
                          itemBuilder: (context, index) {
                            final ratio = _getRandomAspectRatio();

                            return Container(
                              height: (isMobile ? 150 : 200) * ratio,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color(0xFF333333),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget.event.allPhotos[index],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: secondaryColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: Icon(
                                      Icons.image,
                                      color: secondaryColor,
                                    )),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          imageDialog(
                                              context, isMobile, size, index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: (isMobile) ? 30 : 60,
                  ),

                  SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      children: [
                        LinearGradientText(
                            child: Text(
                          "Winners",
                          style: TextStyle(
                              fontSize: (isMobile) ? 20 : 36,
                              fontWeight: FontWeight.bold),
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        // Winners in masonry layout
                        MasonryGridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 3,
                          ),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount:
                              widget.event.winnerPhotos.length, // 3 winners
                          itemBuilder: (context, index) {
                            // Calculate random height to simulate different image sizes
                            final height =
                                (isMobile ? 200 : 250) + Random().nextInt(100);

                            return GradientBox(
                              radius: 15,
                              height: height.toDouble(),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.event.winnerPhotos[index],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                            color: secondaryColor),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: (isMobile) ? 82 : size.width * 0.13),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: (isMobile) ? 300 : size.width * 0.7,
                    height: (isMobile) ? 80 : size.width * 0.11,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: linerGradient),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Container(
                      width: (isMobile) ? 350 : size.width * 0.7,
                      height: (isMobile) ? 100 : size.width * 0.11,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient:
                              LinearGradient(colors: eventBoxLinearGradient)),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LinearGradientText(
                              child: Text(widget.event.name,
                                  style: TextStyle(
                                      fontSize: (isMobile) ? 12 : 35,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(
                              height: (isMobile) ? 0 : 12,
                            ),
                            SelectableText(
                              widget.event.description.trim(),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (isMobile) ? 10 : 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  Future<dynamic> imageDialog(
      BuildContext context, bool isMobile, Size size, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? 15 : 40),
          child: Container(
            width: size.width * 0.8,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black87,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ),

                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.event.allPhotos[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: secondaryColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Caption (optional)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Photo ${index + 1} of ${widget.event.allPhotos.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getRandomAspectRatio() {
    final ratios = [0.6, 0.8, 1.0, 1.2, 1.5, 1.8];
    return ratios[Random().nextInt(ratios.length)];
  }
}

class HeadingWidget extends StatelessWidget {
  final String text;
  final String theme;

  const HeadingWidget({
    super.key,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 500;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LinearGradientText(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            theme,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class GradientBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;
  final double radius;
  const GradientBox({
    super.key,
    required this.radius,
    required this.child,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(colors: linerGradient),
      ),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(colors: eventBoxLinearGradient),
          ),
          child: child,
        ),
      ),
    );
  }
}
