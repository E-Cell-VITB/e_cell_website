import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/main.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/events/widgets/time_box.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class Ongoing_Events extends StatelessWidget {
 
   Ongoing_Events({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.sizeOf(context).width;
   final bool isMobile = screenwidth < 600;
    return Scaffold(
      body: ParticleBackground(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: LinearGradientText(
                    child:Text("Event 2K25",style:isMobile?Theme.of(context).textTheme.displayMedium: Theme.of(context).textTheme.displayLarge,) ),
                    
                ),
                SizedBox(height: 8,),
                SelectableText(
                  "Lorem ipsum is a dummy or placeholder text commonly used in graphic desig",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                  ),
                SizedBox(height: 35,),
                Container(
                  height:isMobile?100: 180,
                  width: MediaQuery.sizeOf(context).width*0.9,
                  decoration: BoxDecoration(
                    color:Color(0xFF303030),
                    borderRadius: BorderRadius.circular(9)
                  ),
                ),
                SizedBox(height: 35,),
                SizedBox(
                  width:isMobile?screenwidth*0.9: screenwidth*0.6,
                  child: SelectableText(
                    "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. Its purpose is to permit a page layout to be designed, independently of the copy that will subsequently populate it, or to demonstrate various fonts of a typeface without meaningful text that could be distracting.",
                    textAlign: TextAlign.center,
                    style:isMobile?  Theme.of(context).textTheme.labelSmall: Theme.of(context).textTheme.titleMedium,
                    )),
                SizedBox(height:isMobile?15: 35,),
                SizedBox(
                  width:isMobile?screenwidth*0.8: screenwidth*0.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimeBox(count: "02", type: "Days"),
                      LinearGradientText(child: Text(":",style: Theme.of(context).textTheme.displayLarge,)),
                      TimeBox(count: "12", type: "Hours"),
                      LinearGradientText(child: Text(":",style: Theme.of(context).textTheme.displayLarge,)),
                      TimeBox(count: "30", type: "Minutes"),
                      LinearGradientText(child: Text(":",style: Theme.of(context).textTheme.displayLarge,)),
                      TimeBox(count: "30", type: "Seconds"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                SizedBox(
                  width:isMobile?screenwidth*0.8: screenwidth*0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Gradient_tile("Feb 4-6 , 2025", Icons.calendar_month_outlined,isMobile),
                        Gradient_tile("COE , VITB", Icons.location_on_outlined,isMobile),
                        Gradient_tile("9AM - 6PM", Icons.access_time_outlined,isMobile),
                    ],
                  ),
                ),
                SizedBox(height:isMobile?40: 80,),
                LinearGradientText(child: Text("Team & Prizepool",style: Theme.of(context).textTheme.headlineMedium,)),
                SizedBox(height:isMobile?30: 50,),
                SizedBox(
                  width:isMobile?screenwidth*0.88: screenwidth*0.45,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        height:isMobile?80: 120,
                        width:isMobile?170: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color:const Color.fromARGB(255, 59, 59, 59)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset("assets/icons/team_member.png",height:isMobile?30: 60,width:isMobile?30:60,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,                              
                              children: [
                                Text("TEAM SIZE",style: TextStyle(fontSize:isMobile?12: 15),),
                                SizedBox(height:isMobile?0: 8,),
                                LinearGradientText(child: Text("2-4",style:TextStyle(fontSize:isMobile? 20:25,fontWeight: FontWeight.bold) ,))
                              ],
                            )
                          ],
                        ),
                      ),
                       Container(
                        padding: EdgeInsets.all(15),
                        height:isMobile?80: 120,
                        width:isMobile?170: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color:const Color.fromARGB(255, 59, 59, 59)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset("assets/icons/trophy.png",height:isMobile?30: 60,width:isMobile?30:60,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,                              
                              children: [
                                Text("PRIZE POOL",style: TextStyle(fontSize:isMobile?12: 15),),
                                SizedBox(height:isMobile?0: 8,),
                                LinearGradientText(child: Text("\u20B950,000",style:TextStyle(fontSize:isMobile? 20:25,fontWeight: FontWeight.bold) ,))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:isMobile?15: 50,),
                SizedBox(
                  width:isMobile?screenwidth*0.8: screenwidth*0.4,
                  child: Center(
                    child: Stack(
                      
                      children: [
                        Image.asset("assets/images/ticket.png",height: 225,width: screenwidth*0.8,),


                         Positioned.fill(
                           child: Align(
                            alignment: Alignment.center,
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset("assets/images/Ecell.png",height:isMobile?80: 180,width:isMobile?80: 180,fit: BoxFit.cover,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LinearGradientText(child: Text("Grab your Spot",style:TextStyle(fontWeight: FontWeight.bold,fontSize:isMobile?18: 25))),
                             
                                    SizedBox(height:isMobile?8: 15,),
                                    //time remaining
                                    Container(
                                      height:isMobile?20: 30,
                                      width:isMobile?90: 118,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 39, 39, 39),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.access_time_outlined,size:isMobile?8: 15,color: Colors.white,),
                                          SizedBox(width:isMobile?5: 10,),
                                          Text("5 days left",style:isMobile?Theme.of(context).textTheme.labelSmall: Theme.of(context).textTheme.labelMedium,),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height:isMobile?8: 15,),
                             
                             
                             
                                    //register button
                                    GestureDetector(                                     
                                      child: Container(               
                                        padding: EdgeInsets.symmetric(vertical:isMobile?5: 10,horizontal:isMobile?15: 30),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          gradient:LinearGradient(colors: linerGradient),
                                        ),
                                        child: Center(child: Text("Registe Now!",style: TextStyle(color: Colors.black,fontSize:isMobile?8: 12,fontWeight: FontWeight.bold),)),
                                      ),
                                    )
                             
                                  ],
                                )
                              ],
                             ),
                           ),
                         )
                    
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget Gradient_tile(String text,IconData icon,bool isMobile){
    return GradientBox(
    radius: 40, 
    height:isMobile?30: 40,
    width:isMobile?90: 160,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon,color: Colors.amberAccent,size:isMobile?10: 16,),
        Text(text,style: TextStyle(fontSize:isMobile?8: 14),),
      ],
    ),
    );
  }

  
}