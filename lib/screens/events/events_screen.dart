import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/main.dart';
import 'package:e_cell_website/screens/events/widgets/dialog.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Text(
                    'Events',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Fueling Ideas, Igniting Change: E-Cell VITB Events",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: getAppTheme().primaryColor,
                    fontSize: size.width * 0.01,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: size.width*0.1),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width > 600 ? 3 : 1,
                      crossAxisSpacing: size.width * 0.08,
                      mainAxisSpacing: size.height * 0.1,
                      childAspectRatio: 3.5,
                      
                    ),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => ShowEventBox(context, index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: linerGradient),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(1),
                          child: Container(
                            height: size.height*0.6,
                            width: size.width*0.3,                       
                            decoration: BoxDecoration(                    
                                gradient: LinearGradient(colors: eventBoxLinearGradient),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child:
                               Text('Tech Spourt 2k25',style: TextStyle(fontSize:size.width*0.02 ,)),
                          ),
                          ),
                        )
                      );
                    }
                  ),
              ],
            ),
          ),
        ),
    );
  }
 }
