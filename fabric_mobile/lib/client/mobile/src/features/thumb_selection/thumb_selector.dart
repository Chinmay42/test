
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:selectable_circle/selectable_circle.dart';

import 'package:toast/toast.dart';

import 'entity/finger_selector.dart';

class ThumbSelector extends StatefulWidget
{
  @override
  ThumbSelectorState createState() => ThumbSelectorState();
}

class ThumbSelectorState extends State<ThumbSelector>
{
  bool _leftOne=false,_leftTwo=false,_leftThree=false,_leftFour=false,_leftFive=false;
  bool _rightOne=false,_rightTwo=false,_rightThree=false,_rightFour=false,_rightFive=false;
  bool _isSelect=false;
  int lastSelectionIndex=-1;

  var _circleWidth=35.0;

  bool isLastLeftSelect;

  var _selectCircleWidth=45.0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Opacity(
        opacity: .7,
        child: Container(
          color: LightColors.black,
          child: Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/thumb_image.png',fit: BoxFit.contain,height:MediaQuery.of(context).size.height/2,width:MediaQuery.of(context).size.height/2),
                SizedBox(height: 5),
                Row(
                    children: <Widget>[
                      Expanded(
                          child: Align(alignment: Alignment.center,child: Text("Select left hand\nfinger",textAlign: TextAlign.center,style: TextStyle(color: LightColors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/50,)
                          )),),

                      Expanded(
                          child: Align(alignment: Alignment.center,child:Text("Select right hand\nfinger",textAlign: TextAlign.center,style: TextStyle(color: LightColors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/50),
                      ),),
                      )]
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child:Center(
                          child: _leftHandChild()
                      ),),

                      Expanded(
                          child:_rightHandChild()
                      ),
                    ]
                ),
                SizedBox(height: 100),
                SimpleRoundButton(
                  buttonText: !_isSelect
                      ? Text('Select Finger',style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/45))
                      : Text('Process',style: TextStyle(color: LightColors.white,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.height/45),),

                  backgroundColor:!_isSelect
                      ? LightColors.kGrey
                      : LightColors.kGreen,
                  onPressed: () async {

                    if( _isSelect)
                    {
                      await _processExecution();
                    }
                    else
                      Toast.show('Please select finger number for scan!',context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );


  }

  Widget _leftHandChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SelectableCircle(
          isSelected: _leftFive,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _leftFive?_selectCircleWidth:_circleWidth,
          child: _tittle("5",_leftFive),
          onTap: () {
            if(!_leftFive)
            setState(() {
              _leftFive = !_leftFive;
              _onCircleSelection(5,_leftFive,true);
            });
          },
        ),
        SelectableCircle(
          isSelected: _leftFour,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _leftFour?_selectCircleWidth:_circleWidth,
          child: _tittle("4",_leftFour),
          onTap: () {
            if(!_leftFour)
            setState(() {
              _leftFour = !_leftFour;
              _onCircleSelection(4,_leftFour,true);
            });
          },
        ),
        SelectableCircle(
          isSelected: _leftThree,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _leftThree?_selectCircleWidth:_circleWidth,
          child: _tittle("3",_leftThree),
          onTap: () {
            if(!_leftThree)
            setState(() {
              _leftThree = !_leftThree;
              _onCircleSelection(3,_leftThree,true);
            });
          },
        ),
        SelectableCircle(
          isSelected: _leftTwo,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _leftTwo?_selectCircleWidth:_circleWidth,
          child: _tittle("2",_leftTwo),
          onTap: () {
            if(!_leftTwo)
            setState(() {
              _leftTwo = !_leftTwo;
              _onCircleSelection(2,_leftTwo,true);
            });
          },
        ),
        SelectableCircle(
          isSelected: _leftOne,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _leftOne?_selectCircleWidth:_circleWidth,
          child: _tittle("1",_leftOne),
          onTap: () {
            if(!_leftOne)
            setState(() {
              _leftOne = !_leftOne;
              _onCircleSelection(1,_leftOne,true);
            });
          },
        ),




      ],
    );
  }

  Widget _rightHandChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableCircle(
          isSelected: _rightOne,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _rightOne?_selectCircleWidth:_circleWidth,
          child:  _tittle("1",_rightOne),
          onTap: () {
            if(!_rightOne)
            setState(() {
              _rightOne = !_rightOne;
              _onCircleSelection(1,_rightOne,false);
            });
          },
        ),
        SelectableCircle(
          isSelected: _rightTwo,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _rightTwo?_selectCircleWidth:_circleWidth,
          child:  _tittle("2",_rightTwo),
          onTap: () {
            if(!_rightTwo)
            setState(() {
              _rightTwo = !_rightTwo;
              _onCircleSelection(2,_rightTwo,false);
            });
          },
        ),
        SelectableCircle(
          isSelected: _rightThree,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _rightThree?_selectCircleWidth:_circleWidth,
          child:  _tittle("3",_rightThree),
          onTap: () {
            if(!_rightThree)
            setState(() {
              _rightThree = !_rightThree;
              _onCircleSelection(3,_rightThree,false);
            });
          },
        ),
        SelectableCircle(
          isSelected: _rightFour,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _rightFour?_selectCircleWidth:_circleWidth,
          child:  _tittle("4",_rightFour),
          onTap: () {
            if(!_rightFour)
            setState(() {
              _rightFour = !_rightFour;
              _onCircleSelection(4,_rightFour,false);
            });
          },
        ),
        SelectableCircle(
          isSelected: _rightFive,
          borderColor: Colors.grey,
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.red,
          width: _rightFive?_selectCircleWidth:_circleWidth,
          child:  _tittle("5",_rightFive),
          onTap: () {
            if(!_rightFive)
            setState(()
            {
              _rightFive = !_rightFive;
              _onCircleSelection(5,_rightFive,false);
            });
          },
        ),
      ],
    );
  }



  _processExecution()
  {
    Navigator.of(context).pop(new FingerSelector(lastSelectionIndex,isLastLeftSelect));

  }

  _onCircleSelection(int selectIndex,bool isSelected,bool isLeftHand)
  {

    print( "$selectIndex $isSelected,$isLeftHand");



      switch(lastSelectionIndex)
      {

        case 1:
          {
            isLastLeftSelect?_leftOne = false:_rightOne=false;
          }
          break;
        case 2:
          {
            isLastLeftSelect?_leftTwo= false:_rightTwo=false;
          }
          break;
        case 3:
          {
            isLastLeftSelect?_leftThree = false:_rightThree=false;
          }
          break;
        case 4:
          {
            isLastLeftSelect?_leftFour = false:_rightFour=false;
          }
          break;
        case 5:
          {
            isLastLeftSelect?_leftFive = false:_rightFive=false;
          }
          break;


      }

      if(!_isSelect)_isSelect=true;
      lastSelectionIndex = selectIndex;
      isLastLeftSelect = isLeftHand;
  }

  _tittle(String s, bool select) {

    return Text(s,style: TextStyle(color: select?Colors.white:Colors.grey),);
  }



}
