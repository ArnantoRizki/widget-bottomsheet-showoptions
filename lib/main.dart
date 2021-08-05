import 'package:flutter/material.dart';
import 'bottom-sheet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show Options',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Show Options'),
    );
  }
}

class DummyModel{
  final int id;
  final String title;
  final String subtitle;

  DummyModel({required this.id, required this.title, required this.subtitle});

  String get text => "{id: $id, title: $title, subtitle: $subtitle}";
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DummyModel? choosenOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: InkWell(
            onTap: (){
              optionsShow<DummyModel>(
                context,
                choosen: choosenOption,
                heightPerOption: 20.0+2.0+12.0+10.0+10.0,
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                options: [
                  DummyModel(id: 1, title: "AC Milan", subtitle: "Serie A"),
                  DummyModel(id: 2, title: "Internazionale", subtitle: "Serie A"),
                  DummyModel(id: 3, title: "Real Madrid", subtitle: "La Liga"),
                  DummyModel(id: 4, title: "Barcelona", subtitle: "La Liga"),
                  DummyModel(id: 5, title: "Ajax", subtitle: "Eredivisie"),
                  DummyModel(id: 6, title: "PSV", subtitle: "Eredivisie"),
                  DummyModel(id: 7, title: "PSG", subtitle: "Ligue 1"),
                  DummyModel(id: 8, title: "OM", subtitle: "Ligue 1"),
                ],
                onChoose: (option) {
                  print(option.text);
                  
                  setState(() {
                    choosenOption = option;
                  });

                  if(Navigator.of(context).canPop()) Navigator.of(context).pop();
                },
                onFilter: (options, search) {
                  if(search.length>0){
                    return options.where((s) => s.subtitle.toLowerCase().contains(search.toLowerCase()) || s.title.toLowerCase().contains(search.toLowerCase())).toList();
                  }else{
                    return options;
                  }
                },
                optionsBuilder: (context, option, choosen){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.5
                          )
                        )
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${option.title}", style: TextStyle(color: Colors.black, fontSize: 20.0)),
                                SizedBox(height: 2.0),
                                Text("${option.subtitle}", style: TextStyle(color: Colors.grey, fontSize: 14.0),),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: choosen!=null? option.id==choosen.id? Colors.blue:Colors.grey.shade400:Colors.grey.shade400
                            ),
                            child: Center(
                              child: Container(
                                width: 5.0,
                                height: 5.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.blue,
                  width: 0.8
                )
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(choosenOption==null? "Empty" : "${choosenOption?.title}", style: TextStyle(color: Colors.black, fontSize: 20.0)),
                        SizedBox(height: 4.0),
                        Text(choosenOption==null? "empty" : "${choosenOption?.subtitle}", style: TextStyle(color: Colors.grey, fontSize: 14.0),),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Icon(Icons.arrow_drop_down, size: 18.0, color: Colors.black,)
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
