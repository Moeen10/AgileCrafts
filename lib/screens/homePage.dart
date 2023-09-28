import 'package:task/bloc/AddCubit/AddCubit.dart';
import 'package:task/bloc/AddCubit/AddState.dart';
import 'package:task/bloc/EditCubit/EditCubit.dart';
import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/bloc/InternetCubit.dart';
import 'package:task/bloc/PostsCubit/post_Cubit.dart';
import 'package:task/bloc/PostsCubit/state_cubit.dart';
import 'package:task/models/post_model.dart';
import 'package:task/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   bool edit = false;

   bool add = false;

  bool isSelected = false;
   MyFormData AddData = MyFormData();
   MyFormData EditData = MyFormData();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("test"),
      ),
      body: BlocProvider(
        create: (context) => AddCubit(),
        child: BlocProvider(
          create: (context) => EditCubit(),
          child: SafeArea(

            child: Column(
              children: [

                Expanded(
                  child: BlocBuilder<PostCubit,PostState >(
                    builder: (context, state) {
                      if(state is LoadingState){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      else if(state is GetDataState){
                        return Column(
                          children: [
                            ElevatedButton(onPressed: (){
                              add =!add;
                              print(add);
                              BlocProvider.of<AddCubit>(context).addProject(add);
                            }, child: Text("ADD")),
                            Expanded(
                              child: ListView.builder(

                                itemCount: state.posts.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(state.posts[index].name.toString()),
                                    leading:  Text(state.posts[index].id.toString()),
                                    trailing: IconButton(onPressed: (){
                                      Product singeProduct = state.posts[index];
                                      edit = !edit;
                                      BlocProvider.of<EditCubit>(context).editPermission(edit,singeProduct);
                                    }, icon: Icon(Icons.edit)),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return  Center(
                        child: Text("Here have an error"),
                      );
                    },
                  ),
                ),

                BlocBuilder<EditCubit,EditState>(builder:
                (context, state) {

                  if(state is DoEditState){

                    return
                        AlertDialog(

                          title: Center(child: Text(state.singleProduct.name.toString())),
                          content: Text(state.singleProduct.description.toString()),
                          actions: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name"),
                                TextField(),
                                Text("Description"),
                                TextField(),
                                Text("Available"),

                              ],
                            ),
                            Container(
                             margin: EdgeInsets.all(16.0),
                             ),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(onPressed: (){}, child: Text("Submit")),
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
                },
                ),

                BlocBuilder<AddCubit,AddState>(builder: (context, state) {
                  if(state is AddInitialStateState){
                    return Container();
                  }
                  if(state is OpenAddState){
                    return AlertDialog(
                     title: Text("Add Device"),
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
                                 // Reset the form or perform other actions
                                 AddData = MyFormData(); // Clear the form data
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
                  if (state is DoneAddState) {
                    // Show a Snackbar if the state is DoneAddState
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Add Successfullly'),
                          duration: Duration(seconds: 2), // Adjust the duration as needed
                        ),
                      );
                    });
                  }
                  return Container();

                },)


              ],
            ),
          ),
        ),
      ),
    );
  }
}





