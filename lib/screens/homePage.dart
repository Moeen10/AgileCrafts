import 'package:hive/hive.dart';
import 'package:task/bloc/AddCubit/AddCubit.dart';
import 'package:task/bloc/AddCubit/AddState.dart';
import 'package:task/bloc/EditCubit/EditCubit.dart';
import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/bloc/InternetCubit/InternetCubit.dart';
import 'package:task/bloc/InternetCubit/InternetState.dart';
import 'package:task/bloc/PostsCubit/post_Cubit.dart';
import 'package:task/bloc/PostsCubit/state_cubit.dart';
import 'package:task/models/product_model.dart';
import 'package:task/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:hive_flutter/hive_flutter.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool edit = false;
  bool add = false;
  MyFormData AddData = MyFormData();
  MyFormData AddDataOffline = MyFormData();

  MyFormData EditData = MyFormData();
  MyFormData OfflineEditData = MyFormData();
  final ValueNotifier<bool> hiveDataChangedNotifier = ValueNotifier<bool>(false);

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


            //   ======================  Disonnected Data ===========================
            
            
            if (state is DisconnectedState) {
              return Column(
                children: [
                  Text("Disconnected"),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        add = !add;
                        print(add);
                        if (add) {
                          BlocProvider.of<AddCubit>(context).OfflineAddProject(add);
                          AlertDialog(
                            title: Text("Add Product"),
                            actions: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name"),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        AddDataOffline.name = value;
                                      });
                                    },
                                  ),
                                  Text("Description"),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        AddDataOffline.description = value;
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
                                          groupValue: AddDataOffline.isAvailable,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              AddDataOffline.isAvailable = value ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('Select False'),
                                        leading: Radio(
                                          value: false,
                                          groupValue: AddDataOffline.isAvailable,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              AddDataOffline.isAvailable = value ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text('Selected: ${AddDataOffline.isAvailable}'),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){
                                          Product product = Product(
                                            tenantId: 20,
                                            name: AddDataOffline.name,
                                            description: AddDataOffline.description,
                                            isAvailable: AddDataOffline.isAvailable,
                                            id:1
                                          );
                                          print("{}{}{}{}");
                                          print(product.name);
                                          print(product.id);
                                          print(product.description);

                                          // Add 'product' to Hive
                                          Hive.box<Product>("products").add(product);

                                        },
                                        child: Text("Submit"),
                                      ),
                                      ElevatedButton(onPressed: (){
                                        BlocProvider.of<AddCubit>(context).closeScreen();
                                      }, child: Text("Close")),
                                    ],
                                  ),

                                ],
                              )
                            ],
                          );
                        }
                      });
                    },
                    child: Text("ADD"),
                  ),

                  // =====================  offline data fetch =======================
                  Expanded(
                    child: ValueListenableBuilder<Box<Product>>(
                      valueListenable: Boxes.getData().listenable(),
                      builder: (context, box, _) {
                        var data = box.values.toList().cast<Product>();

                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(data[index].name.toString()),
                              leading: Text(data[index].id.toString()),
                              trailing: IconButton(
                                onPressed: () {
                                  Product singleProduct =data[index];
                                  edit = !edit;
                                  BlocProvider.of<EditCubit>(context)
                                      .OfflineEditPermission(edit, singleProduct);
                                },
                                icon: Icon(Icons.edit),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  BlocConsumer<EditCubit,EditState>(builder: (context, state) {
                    if(state is OfflineDoEditState){

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
                                    OfflineEditData.name = value;
                                  });
                                },),
                                Text("Description"),
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      OfflineEditData.description = value;
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
                                        groupValue: OfflineEditData.isAvailable,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            OfflineEditData.isAvailable = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text('Select False'),
                                      leading: Radio(
                                        value: false,
                                        groupValue: OfflineEditData.isAvailable,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            OfflineEditData.isAvailable = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Text('Selected: ${OfflineEditData.isAvailable}'),


                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(8.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(onPressed: ()async{
                                  OffEdit(OfflineEditData,state.singleProduct.id as int);

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
                    else if(state is OfflineDoEditState){
                       Hive.openBox<Product>("products");
                    }

                    return Container();
                  }, listener: (context, state) {
                    if(state is DoneEditState){

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
                    if(state is OfflineOpenAddState){
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
                      }
                    },
                  ),

                  // BlocConsumer for add and edit state can go here if needed
                ],
              );

            } 
            
            
            
            
            //   ======================  Connected Data ===========================
            
            else if (state is ConnectedState) {
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
                          final box = Boxes.getData();

                          if (box.length >= 5) {
                            print("????????????     ${box.length}      ////////////////////////");
                          }

                          return ValueListenableBuilder<Box<Product>>(
                              valueListenable: Boxes.getData().listenable(),
                              builder: (context,box,_){
                                var data = box.values.toList().cast<Product>();




                                return ListView.builder(
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    return    ListTile(
                                      title: Text(data[index].name.toString()),
                                      leading: Text(data[index].id.toString()),
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
                                  },);
                              }
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
            if (state is DisconnectedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Internet Disonnected"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

Future<void> editOffline(Product editedProduct )async{

}


  Future<void> _showDialog()async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title:Text("Add Products"),
          );
        }
    );
  }



  void OffEdit(MyFormData EditData,int idd) async {
    final box = Hive.box<Product>("products");
    final int productId = idd ?? 0; // Replace 0 with a default value if needed

    // Fetch the existing product from the Hive box
    final Product existingProduct = box.get(productId) as Product;

    if (existingProduct != null) {
      // Update the existing product with the edited values
      existingProduct.name = EditData.name;
      existingProduct.description = EditData.description;
      existingProduct.isAvailable = EditData.isAvailable;

      // Replace the old product with the updated product in the Hive box
      box.put(productId, existingProduct);
      // final products = box.values.toList().cast<Product>();
      // await box.clear(); // Clear the previous data
      // await box.addAll(products);
      hiveDataChangedNotifier.value = true;
      print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
      for (int index = 0; index < box.length; index++) {
        final product = box.getAt(index) as Product; // Assuming Product is the type stored in the box

        if (product.id == productId) {
          print(":::::::::::::::::::::::::");
          print(product.id);
          print(product.name);
          break; // Stop searching when the updated product is found
        }
      }


    } else {
      // Handle the case where the product with the specified ID is not found
      print("Product with ID $productId not found in Hive");
    }
  }




}






class Boxes {
  static Box<Product> getData() => Hive.box<Product>("products");
}
