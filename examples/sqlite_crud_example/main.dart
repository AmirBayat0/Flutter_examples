import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:insta_project/helper.dart';
import 'package:lottie/lottie.dart';

//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FinalView(),
      ),
    );

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> allData = [];
  bool isLoading = true;

  /// Refreshing Data After every User action
  void refreshData() async {
    final data = await SQLHelper.getItems();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  /// Show Form for adding a new task / update task
  void showForm(int? id) async {
    if (id != null) {
      // id != null -> update an existing item
      final existingJournal =
          allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
    // id == null -> create new item
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              id == null ? 'Add New One!' : 'Update Current',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Tell me about Your Task:)",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Colors.deepPurpleAccent.withOpacity(.5)),
              ),
              onPressed: () async {
                if (id == null) {
                  await addItem();
                }

                if (id != null) {
                  await updateItem(id);
                }

                _titleController.text = '';
                _descriptionController.text = '';

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  /// Add Task Function
  Future<void> addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    refreshData();
  }

  /// Update Task Function
  Future<void> updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    refreshData();
  }

  /// Delete
  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Successfully removed task',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    refreshData();
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDFF),
      appBar: const HomeAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopSideTitles(allData: allData),
                allData.isEmpty
                    ? const Expanded(child: EmptyListState())
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: allData.length,
                          itemBuilder: (context, index) => Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  flex: 3,
                                  onPressed: (_) =>
                                      deleteItem(allData[index]['id']),
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Remove',
                                  autoClose: true,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 110,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              showForm(allData[index]['id']),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Colors.deepPurpleAccent
                                          .withOpacity(0.5),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12, left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              allData[index]['title'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30),
                                            ),
                                            Text(
                                              allData[index]['description'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),

      /// Floating Action Button
      floatingActionButton: _buildFAB(),
    );
  }

  /// Floating Action Button
  Widget _buildFAB() {
    return SizedBox(
      width: 220,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color.fromARGB(255, 164, 132, 250),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Write a new project"),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.add),
          ],
        ),
        onPressed: () => showForm(null),
      ),
    );
  }
}

/// Top Side Titles
class TopSideTitles extends StatelessWidget {
  const TopSideTitles({
    super.key,
    required this.allData,
  });

  final List<Map<String, dynamic>> allData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Amir!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            "Your \nProjects ${allData.isNotEmpty ? "(${allData.length})" : " "}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 55,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty List State
class EmptyListState extends StatelessWidget {
  const EmptyListState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: FadeInUp(
                from: 30,
                child: Lottie.network(
                    fit: BoxFit.cover,
                    'https://lottie.host/6c5d8b9e-aa40-4ca6-bd94-417832dfc644/vSG6B2gPfU.json')),
          ),
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            from: 30,
            child: const Text(
              "All Tasks Done!👍",
              style: TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          FadeInUp(
            from: 30,
            delay: const Duration(milliseconds: 400),
            child: Text(
              "For Creating a Task Tap on the FAB button👇",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Home AppBar
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.apps,
            color: Colors.black,
            size: 40,
          )),
      actions: const [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/91388754?v=4',
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
