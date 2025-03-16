import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class ShowEventBox {
  ShowEventBox(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
            child: Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            // border: Border.all(color: secondaryColor.withOpacity(0.7)),
            gradient: const LinearGradient(
              colors: linerGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
              height: size.width > 600 ? size.height * 0.65 : size.height * 0.5,
              width: size.width > 600 ? size.width * 0.50 : size.height * 0.3,
              decoration: BoxDecoration(
                // border: Border.all(color: secondaryColor.withOpacity(0.7)),
                gradient: const LinearGradient(
                  colors: eventBoxLinearGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: linerGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: SelectableText(
                            'TechSprouts 2K25',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SelectableText(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.....",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: size.width * 0.012,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Material(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.09,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                        colors: linerGradient),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Read More",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ])),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                      height: size.height * 0.50,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        "hello",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ))
                ],
              )),
        ));
      },
    );
  }
}
