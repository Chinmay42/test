
import 'package:fabric_mobile/client/mobile/injection_container.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/repositories/formbuilder_repository.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/presentation/bloc/formbuilder_bloc.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/presentation/widgets/formbuilder_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../../../../../../injection_container.dart';


class FormBuilderScreen extends StatefulWidget {
  final String formtitle;
  final String examtype;

  FormBuilderScreen(
      {Key key, @required this.formtitle, @required this.examtype});

  @override
  _FormBuilderScreenState createState() =>
      _FormBuilderScreenState(formtitle, examtype);
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  final String _formtitle;
  final String _examtype;
  _FormBuilderScreenState(this._formtitle, this._examtype);

  FormbuilderBloc formbuilderBloc;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  void initState() {
    super.initState();
    formbuilderBloc = FormbuilderBloc(repositiry: sl<FormBuilderRepositiry>());
  }

  @override
  Widget build(BuildContext context) {
    formbuilderBloc.add(Getdata(_examtype));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.kGrey,
        title: Text(
          _formtitle,
          style: TextStyle(color: LightColors.grey),
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocBuilder<FormbuilderBloc, FormbuilderState>(
          bloc: formbuilderBloc,
          builder: (BuildContext context, FormbuilderState formbuilderstate) {
            if (formbuilderstate is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (formbuilderstate is Error) {
              return Text('Ayo! Error');
            } else if (formbuilderstate is Loaded) {
              return SingleChildScrollView(
                child: Container(
                  padding:  EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
                  child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child:   Card(
                        color: LightColors.kGrey,
                        elevation: 1,
                          child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10),
                      
                          child:Column(
                          children: <Widget>[
                          FormBuilderList(
                              frombuilder: formbuilderstate.fromdata,
                              formKey: _formKey,
                              autoValidate: _autoValidate),
                        ],
                       ),
                      )
                   ),),
                ),
              );
              //;
            }
            return Container(
                color: Colors.orangeAccent,
                height: double.infinity,
                width: double.infinity);
          }),
    );
  }
}
