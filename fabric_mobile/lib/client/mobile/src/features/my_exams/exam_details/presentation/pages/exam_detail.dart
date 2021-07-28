import 'package:carousel_slider/carousel_slider.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/tabIcon_data.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/grid_item_top.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/gridmodel.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/presentation/pages/logincac.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamDetailScreen extends StatefulWidget{
  const ExamDetailScreen({Key key,this.animationController}) : super(key: key);
final AnimationController animationController;

@override
  ExamDetailScreenState createState() => new ExamDetailScreenState();
}


class ExamDetailScreenState extends State<ExamDetailScreen>
    with TickerProviderStateMixin {

AnimationController animationController;

List<TabIconData> tabIconsList = TabIconData.tabIconsList;

Widget tabBody = Container(
    color: LightColors.white
  );

  int _morningIndex = 0;
  int _afternoonIndex = 0;

 @override
 void initState() {
  super.initState();
      }


 CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height/40,
      backgroundColor: LightColors.grey,
      child: Icon(
        Icons.timer,
        size: MediaQuery.of(context).size.height/35,
        color: LightColors.white,
      ),
    );
  }


final List<String> _dropdownValues = [

    "Select a Batch",
    "Morning Batch",
    "Afternoon Batch",
  ];

String _value= 'Select a Batch';

final search_in = TextEditingController();

static DateTime now = DateTime.now();
String formattedDate = DateFormat('dd-MM-yyyy\nkk:mm:a').format(now);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
         backgroundColor: LightColors.white,
    
        body:FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
            
              );
             
            }
             else {
              return Stack(

                children: <Widget>[

              SingleChildScrollView(

                child: Container(         
                    decoration: BoxDecoration(color: LightColors.white),
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    width: width,

              child: Column(
                children: <Widget>[

                Container(
                  decoration: BoxDecoration(color: LightColors.white),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: width,
                  child: Column(
                    children: <Widget>[

                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.only(right: 2.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                    
                    children: <Widget>[
                      Text(formattedDate, style: TextStyle(color:LightColors.grey,fontSize: MediaQuery.of(context).size.height/55, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                 ),

                 SizedBox(height: 10.0,),
                  
                  //SizedBox(height: 20),
                  Container(
                                          
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                       Card(
                         elevation: 1,
                         color: LightColors.kGrey,
                          
                      child:Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child:Column(
                          children: <Widget>[   
                                          
                        SizedBox(height: 15.0,),
                                             
                      //TextField(label: 'Title'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child:Container(
                              height:MediaQuery.of(context).size.height/20,
                            child: TextField(
                              controller: search_in,
                              autofocus: false,
                            decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                          hintText : ('    Search'),
                          hintStyle: TextStyle(
                          color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/55
                      
                    ),
                    suffixIcon:  Icon(Icons.search,color: LightColors.grey,size: MediaQuery.of(context).size.height/35,)),
                                ),
                          ),
                          ),
                            SizedBox(width: 10.0,),

                          calendarIcon(),
                      
                        ],
                      ),

                      SizedBox(height: 5.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[

                        DropdownButton(
                          items: _dropdownValues.map((value) => DropdownMenuItem(
                          child:  Text('$value',style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/60)),
                          value: value,
                          )).toList(),
                          onChanged:(String value) {

                              print(value);
                              setState(() {
                                    _value = value;
                              }); 
                          },
                              value: _value,
                          ),
                        ]
                      ),
                      SizedBox(height:10.0),
                  ]
                ),
               ),       
              ),
            ],
          ),
         ),

                        SizedBox(height: 5.0,),

                    Card(
                      elevation: 1,

                      child:Container(
                       width: double.maxFinite,
                       child:Container(
                         decoration: BoxDecoration(
                        
                       color: LightColors.kGrey,
                     
                ),
                        
                         child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                          
                    
                      // padding: EdgeInsets.all(5.0),
                      Padding(padding:EdgeInsets.only(left:15.0,top:7.0),
                      child: Text('8:00 AM - 11:00 AM',style: TextStyle(fontSize: MediaQuery.of(context).size.height/60,color: LightColors.grey,fontWeight:FontWeight.bold),), 
                         ),

               Container(
                 width: width,
                  decoration: BoxDecoration(
                ),

                child: InkWell(

                   onTap: () {
                        setState(() {
                              Navigator.push( context,
                            MaterialPageRoute(builder: (context) =>
                               tabBody = LoginCacScreen(animationController: animationController,),
                               ),
                          );
                          
                          });
                        },


                 child: CarouselSlider(
                   options: CarouselOptions(
                   reverse: false,
                  aspectRatio: 3.8,
                  viewportFraction: 0.92,
                  initialPage: 0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  onPageChanged: (index,reason) {
                    setState(() {
                      _morningIndex = index;
                      print(_morningIndex);
                    });
                  },
                   ),
                  
                  items: List<GridView>.generate(
                      (2), (int index) {
                    return GridView.count(
                      crossAxisCount: 4,
                      children: List<GridItemTop>.generate((4), (int index) {
                        return GridItemTop(
                            _morningList()[index + (_morningIndex * 4)]);
                            
                      }),
                    );
                  }),
                ),
                ),
            
             
          ),
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (int index) {
                  return dots(_morningIndex, index);
                }),
            
            ),
          
                ]
                ),
               ),
                ),
                    ),
                  
                         SizedBox(height: 5.0,),

                      Card(
                        
                        elevation: 1,

                      child:Container(                  
                       width: width,
                       child:Container(
                       decoration: BoxDecoration(
                        
                           color: LightColors.kGrey,
                        ),


                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[



           Padding(
             padding: EdgeInsets.only(left:15.0,top:7.0),
                   child:  Text('12:00 PM - 3:00 PM',style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/60,fontWeight: FontWeight.bold),), 
                     ),  
                Container(

                 child: InkWell(

                  onTap: () {
                     Navigator.push( context,
                            MaterialPageRoute(
                              builder: (context) => LoginCacScreen(animationController: animationController,),
                            ),
                          );
                        },
                  child: CarouselSlider(
                    options: CarouselOptions(
                  reverse: false,
                  aspectRatio: 3.8,
                  viewportFraction:0.92,
                  initialPage: 0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  onPageChanged: (index,reason) {
                    setState(() {
                      _afternoonIndex = index;
                      print(_afternoonIndex);
                    });
                  },
                    ),
                  
                  items: List<GridView>.generate(
                      (2), (int index) {


                        
                    return GridView.count(
                      crossAxisCount: 4,
                      children: List<GridItemTop>.generate((4), (int index) {
                        
                        return GridItemTop(
                                   
                            _afternoonList()[index + (_afternoonIndex * 4)],
                         );
                      }),
                    );
                  }),
                  
                ),
                            ),
             
          ),
                

             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (int index) {
                  return dots1(_afternoonIndex, index);
                }),
            ),
          
                ]
                ),
               ),
                ),
                      ),

                SizedBox(height: 10,),          
                     
                    ],
                  )
                  ),

                ]
              ),
       ),

              ),
                  //bottomBar(),
                ],
              
              );
            }
          },
        ),
       
      
       // bottomNavigationBar: bottomBar()
        );


    
    
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

Widget dots(int current, index) {
    if (current != index) {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor(index),
          ));
    } else {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: dotColor(index)
          ));
    }
  }

Widget dots1(int current, index) {
    if (current != index) {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor1(index),
          ));
    } else {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: dotColor1(index)
          ));
    }
  }


  



List<GridModel> _morningList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(Icons.library_books, "TANGO 1", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 2", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 3", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 4", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 5", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 6", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 7", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 8", LightColors.grey));

    return list;
  }

List<GridModel> _afternoonList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(Icons.library_books, "TANGO 9", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 10", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 11", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 12", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 13", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 14", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 15", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 16", LightColors.grey));

    return list;
  }

 Color dotColor(int index) {
    return _morningIndex == index
        ? LightColors.grey
        : LightColors.white;
  }

  Color dotColor1(int index) {
    return _afternoonIndex == index
         ? LightColors.grey
        : LightColors.white;
  }


  
  
}