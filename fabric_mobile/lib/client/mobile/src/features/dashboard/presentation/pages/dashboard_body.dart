

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/GlobalKeys.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/grid_item.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/grid_item_top.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/gridmodel.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/presentation/pages/logincac.dart';

import 'package:flutter/material.dart';



class DashboardBody extends StatefulWidget{
   @override
  _DashboardBodyState createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {

   int _currentIndexUp = 0;
 

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
     return SingleChildScrollView(
      child: new Column(
        children: <Widget>[

           SizedBox(height: 5.0,),
          Padding(padding: const EdgeInsets.only(left:10.0,right:10.0,bottom: 1),
            child: Container(

              height: MediaQuery.of(context).size.height/22,
              width: MediaQuery.of(context).size.width,
             child: Row(
              
                children: <Widget>[
                
                  Text('Today\'s Projects',style: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: LightColors.grey,fontWeight: FontWeight.bold), key: GlobalKeys.keyAssignProject,),
                 
                ],
              ),
            ),
          ),

          SizedBox(height: 5.0,),
          Padding(padding: EdgeInsets.only(left:10.0,right: 10.0),

          child: Card(
            elevation: 1,
          
           child:Container(
              width: double.maxFinite,
              
                decoration: BoxDecoration(
                  
                color: LightColors.kGrey,
               ),

              child: Column(
                children: <Widget>[

               Container(
                 child: InkWell(
                   onTap: () {
                            Navigator.push( context,
                            MaterialPageRoute(builder: (context) =>
                                LoginCacScreen(),
                               ),
                          );
                   },
                 child: CarouselSlider(
                   options: CarouselOptions(
                   reverse: false,
                  aspectRatio: 4.0,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  onPageChanged: (index,reason) {
                    setState(() {
                      _currentIndexUp = index;
                      print(_currentIndexUp);
                    });
                  }
                   ),
                
                  items: List<GridView>.generate(
                      (2), (int index) {
                    return GridView.count(
                      crossAxisCount: 3,
                      children: List<GridItemTop>.generate((3), (int index) {
                        return GridItemTop(
                            _getGridList()[index + (_currentIndexUp * 4)]
                            
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
                  return dots(_currentIndexUp, index);
                }),
            ),
          
                ]
                ),
           ),
          ),
        ),
        

          SizedBox(height: 5.0,),
          Padding(padding: const EdgeInsets.only(left:10.0,right:10.0,bottom: 1),
            child: Container(

              height: MediaQuery.of(context).size.height/25,
              width: MediaQuery.of(context).size.width,
             child: Row(
              
                children: <Widget>[
                
                  Text('Projects',style: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: LightColors.grey,fontWeight: FontWeight.bold), key: GlobalKeys.keyTotalProject,),
                 
                ],
              ),
            ),
          ),

            SizedBox(height: 5.0,),
            Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0,top: 1, bottom: 10),
            child: InkWell(
                   onTap: () {
                            Navigator.push( context,
                            MaterialPageRoute(builder: (context) =>
                                LoginCacScreen(),
                               ),
                          );
                   },
            child:GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: List<GridItem>.generate(_getGridItemList().length, (int index) {
              return GridItem(_getGridItemList()[index]);
            }),
          ),
            ),
        ),
        SizedBox(height: 20.0,),
          
        ],
      ),
    );



  }
  
  List<GridModel> _getGridItemList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(Icons.library_books, "TANGO 1", LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO 2", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 3", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 4", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 5",LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 6", LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO 7", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 8", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 9", LightColors.grey));
    return list;
  }

  List<GridModel> _getGridList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO",LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO", LightColors.grey));

    return list;
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
    }
     else 
    {
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


  

  Color dotColor(int index) {
    return _currentIndexUp == index
        ? LightColors.grey
        : LightColors.white;
  }


}