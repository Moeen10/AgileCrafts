import 'package:task/bloc/AddCubit/AddCubit.dart';
import 'package:task/bloc/AddCubit/AddState.dart';
import 'package:task/bloc/EditCubit/EditCubit.dart';
import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/bloc/InternetCubit/InternetCubit.dart';
import 'package:task/bloc/InternetCubit/InternetState.dart';

import 'package:task/bloc/PostsCubit/post_Cubit.dart';
import 'package:task/bloc/PostsCubit/state_cubit.dart';
import 'package:task/models/post_model.dart';
import 'package:task/screens/test.dart';
import 'package:task/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool edit = false;
  bool add = false;
  MyFormData AddData = MyFormData();
  MyFormData EditData = MyFormData();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => AddCubit()),
        BlocProvider(create: (context) => EditCubit()),
        BlocProvider(create: (context) => InternetCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("test"),
        ),
        body: BlocConsumer<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is DisconnectedState) {
              return Text("Disconnected");
            } else if (state is ConnectedState) {
              return Column(
                children: [
                  Text("Connected"),
                  ElevatedButton(
                    onPressed: () {
                      add = !add;
                      print(add);
                      BlocProvider.of<AddCubit>(context).addProject(add);
                    },
                    child: Text("ADD"),
                  ),
                  Expanded(
                    child: BlocBuilder<PostCubit, PostState>(
                      builder: (context, state) {
                        if (state is GetDataState) {
                          return ListView.builder(
                            itemCount: state.posts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.posts[index].name.toString()),
                                leading: Text(state.posts[index].id.toString()),
                                trailing: IconButton(
                                  onPressed: () {
                                    Product singleProduct = state.posts[index];
                                    edit = !edit;
                                    BlocProvider.of<EditCubit>(context)
                                        .editPermission(edit, singleProduct);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              );
                            },
                          );
                        } else if (state is LoadingState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),


                BlocConsumer<EditCubit,EditState>(builder: (context, state) {
                  if(state is DoEditState){

                    return
                      AlertDialog(

                        title: Center(child: Text(state.singleProduct.name.toString())),
                        content: Text("Description : - ${state.singleProduct.description.toString()}"),
                        actions: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name"),
                              TextField(onChanged: (value) {
                                setState(() {
                                  EditData.name = value;
                                });
                              },),
                              Text("Description"),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    EditData.description = value;
                                  });
                                },
                              ),
                              Text("Available"),
                              Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text('Select True'),
                                    leading: Radio(
                                      value: true,
                                      groupValue: EditData.isAvailable,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          EditData.isAvailable = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Select False'),
                                    leading: Radio(
                                      value: false,
                                      groupValue: EditData.isAvailable,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          EditData.isAvailable = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text('Selected: ${EditData.isAvailable}'),


                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(8.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: ()async{
                                BlocProvider.of<EditCubit>(context).edit(EditData,state.singleProduct.id as int);

                              }, child: Text("Submit")),
                              ElevatedButton(
                                onPressed: () {
                                  edit = !edit;
                                  BlocProvider.of<EditCubit>(context).editPermission(edit,state.singleProduct as Product);

                                },
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        ],
                      );

                  }

                  if (state is NoEditState)
                  {
                    return Container();
                  }

                  return Container();
                }, listener: (context, state) {
                  if(state is DoneEditState){

                    BlocProvider.of<PostCubit>(context).fetchPosts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Edit Successfully"),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },),

                  BlocConsumer<AddCubit,AddState>(builder: (context, state) {

                   if(state is AddInitialStateState){
                     return Container();
                   }
                   if(state is OpenAddState){
                     return AlertDialog(
                       title: Text("Add Product"),
                       actions: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Name"),
                             TextField(
                               onChanged: (value) {
                                 setState(() {
                                   AddData.name = value;
                                 });
                               },
                             ),
                             Text("Description"),
                             TextField(
                               onChanged: (value) {
                                 setState(() {
                                   AddData.description = value;
                                 });
                               },
                             ),
                             Text("Is Available"),
                             Column(
                               children: <Widget>[
                                 ListTile(
                                   title: Text('Select True'),
                                   leading: Radio(
                                     value: true,
                                     groupValue: AddData.isAvailable,
                                     onChanged: (bool? value) {
                                       setState(() {
                                         AddData.isAvailable = value ?? false;
                                       });
                                     },
                                   ),
                                 ),
                                 ListTile(
                                   title: Text('Select False'),
                                   leading: Radio(
                                     value: false,
                                     groupValue: AddData.isAvailable,
                                     onChanged: (bool? value) {
                                       setState(() {
                                         AddData.isAvailable = value ?? false;
                                       });
                                     },
                                   ),
                                 ),
                               ],
                             ),
                             Text('Selected: ${AddData.isAvailable}'),
                             SizedBox(height: 20,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 ElevatedButton(
                                   onPressed: (){
                                     // print('Name: ${AddData.name}');
                                     // print('Description: ${AddData.description}');
                                     // print('Is Available: ${AddData.isAvailable}');
                                     BlocProvider.of<AddCubit>(context).productAdd(AddData);
                                   },
                                   child: Text("Submit"),
                                 ),
                                 ElevatedButton(onPressed: (){
                                   BlocProvider.of<AddCubit>(context).closeScreen();
                                 }, child: Text("Close")),
                               ],
                             )
                           ],
                         ),
                       ],
                     );
                   }
                   if(state is CancelAddState ){
                     return Container();
                   }
                   if(state is CancelAddState){
                     return Container();
                   }
                   return Container();



                 },
                     listener: (context, state) {
                       if (state is DoneAddState) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text("Added Successfully"),
                             backgroundColor: Colors.blue,
                           ),
                         );

                         BlocProvider.of<PostCubit>(context).fetchPosts();

                       }
                     },
                 )

                ],
              );
            } else {
              return Text("data");
            }
          },
          listener: (context, state) {
            if (state is ConnectedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Internet Connected"),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}






