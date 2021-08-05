import 'package:flutter/material.dart';


typedef OptionsBuilder<T> = Widget Function(BuildContext context, T option, T? choosen);
typedef OptionsFilterOnChange<T> = List<T> Function(List<T> options, String search);

void optionsShow<T>(
  BuildContext context, {required List<T> options, required void Function(T) onChoose, required OptionsBuilder<T> optionsBuilder, T? choosen, OptionsFilterOnChange<T>? onFilter, double? maxHeight, double? heightPerOption}){
  showModalBottomSheet(context: context, builder: (context) {
    return OptionsShow(
      onChoose: onChoose,
      options: options,
      optionsBuilder: optionsBuilder,
      maxHeight: maxHeight,
      heightPerOption: heightPerOption,
      choosen: choosen,
      onFilter: onFilter,
    );
  },isScrollControlled: true);
}

class OptionsShow<T> extends StatefulWidget {
  final void Function(T) onChoose;
  final List<T> options;
  final OptionsBuilder<T> optionsBuilder;
  final T? choosen;
  final double? maxHeight;
  final OptionsFilterOnChange<T>? onFilter;
  final double? heightPerOption;
  
  const OptionsShow({ Key? key, required this.onChoose, required this.options, required this.optionsBuilder, this.maxHeight, this.choosen, this.onFilter,  this.heightPerOption}) : super(key: key);


  @override
  _OptionsShowState<T> createState() => _OptionsShowState<T>();
}

class _OptionsShowState<T> extends State<OptionsShow<T>> {
  var _optionsFiltered = <T>[];

  @override
  void initState() {
    super.initState();

    _optionsFiltered = List<T>.from(widget.options);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _t = widget.heightPerOption != null? 
                (size.height * 0.03)+5.0+(size.height * 0.03)+45.0+(size.height * 0.03) + widget.options.length * widget.heightPerOption!
                :(size.height * 0.03)+5.0+(size.height * 0.03)+45.0+(size.height * 0.03) + widget.options.length*30.0;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: widget.maxHeight != null? _t > widget.maxHeight! ? widget.maxHeight:_t:_t,
          color: Color(0x00000000).withOpacity(0.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: Container(
                    width: size.width * 0.18,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    onChanged: (str){
                      setState(() {
                        if(widget.onFilter!=null){
                          _optionsFiltered = widget.onFilter!(widget.options, str);
                        }else{
                          _optionsFiltered = List<T>.from(widget.options);
                        }
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 12.0),
                      labelStyle:
                          TextStyle(fontSize: 14),
                      hintText: "Title, subtitle",
                      focusColor: Colors.blue,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent, width: 1.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent, width: 1.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent, width: 1.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent, width: 1.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade400,),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Expanded(
                  child: Container(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(delegate: SliverChildBuilderDelegate((context,index){
                          return InkWell(
                            onTap: (){
                              widget.onChoose(_optionsFiltered[index]);
                            },
                            child: widget.optionsBuilder(context, _optionsFiltered[index], widget.choosen)
                          );
                        }, childCount: _optionsFiltered.length))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
