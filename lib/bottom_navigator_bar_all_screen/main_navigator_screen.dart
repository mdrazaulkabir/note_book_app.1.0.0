import 'package:flutter/material.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/add_new_task.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/cancel_screen.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/complete_screen.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/new_task_screen.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/progress_screen.dart';
import 'package:note_book_app/custom_widget/appBar_navigator.dart';

class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  static final String name = 'navigatorScreen';

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  // final List<Widget> navigatorScreen = [
  //   NewTaskScreen(),
  //   CompleteScreen(),
  //   CancelScreen(),
  //   ProgressScreen(),
  // ];
  Widget getCurrentScreen() {
    switch (_selectedScreen) {
      case 0:
        return NewTaskScreen(key: UniqueKey()); // creates a new instance every time
      case 1:
        return CompleteScreen();
      case 2:
        return CancelScreen();
      case 3:
        return ProgressScreen();
      default:
        return NewTaskScreen(key: UniqueKey());
    }
  }

  late int _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppbarNavigator(), //vvi you can take like this way because scaffold can't take this type of parameter
      //vvi
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarNavigator(),
      ),
      //body: navigatorScreen[_selectedScreen],
      body: getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _selectedScreen = value;
          setState(() {});
        },
        currentIndex: _selectedScreen,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.greenAccent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            // backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.receipt_outlined),
            label: "New Task",
          ),
          BottomNavigationBarItem(
            // backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.receipt_outlined),
            label: "Complete",
          ),
          BottomNavigationBarItem(
            // backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.receipt_outlined),
            label: "Cancel",
          ),
          BottomNavigationBarItem(
            // backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.receipt_outlined),
            label: "Progress",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _floatingActionButton();
        },
        child: Icon(Icons.edit, color: Colors.greenAccent),
      ),
    );
  }

  void _floatingActionButton() async {
    final result1 = await Navigator.pushNamed(context, AddNewTask.name);
    if (result1 == true && _selectedScreen == 0) {
      setState(() {});
    }
  }
}
