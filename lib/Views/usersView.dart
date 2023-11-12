import "package:flutter/material.dart";
import "package:hallila_week12/Repositories/UserClient.dart";
import "package:hallila_week12/Views/addUserView.dart";
import "../Models/User.dart";

class UsersView extends StatefulWidget {
  List<User> inUsers;
  final UserClient userClient = UserClient();
  UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

bool _loading = false;

class _UsersViewState extends State<UsersView> {
  _UsersViewState(users);

  late List<User> users = widget.inUsers;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("View Users"),
      ),
      body: _loading
          ? Column(
              children: [
                CircularProgressIndicator(),
                Text("Loading..."),
              ],
            )
          : SingleChildScrollView(
              child: Column(
              children: users.map((user) {
                return Padding(
                  padding: EdgeInsets.all(3),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Username: ${user.Username}"),
                          subtitle: Text("Auth Level: ${user.AuthLevel}"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                                onPressed: () {}, child: const Text("UPDATE")),
                            const SizedBox(
                              width: 8,
                            ),
                            TextButton(
                                onPressed: () => ShowDialog(user.ID),
                                child: const Text("DELETE")),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddPressed,
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    ));
  }

  void ShowDialog(String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to permanently delete this user?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteUser(userId);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteUser(String userId) {
    setState(() {
      widget.userClient.Delete(userId);
      getUsers();
    });
  }

  void getUsers() {
    setState(() {
      _loading = true;
      widget.userClient
          .GetUsersAsync()
          .then((response) => onGetUsersSuccess(response));
    });
  }

  onGetUsersSuccess(List<User>? newUsers) {
    setState(() {
      _loading = false;
      if (newUsers != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UsersView(
                      inUsers: newUsers,
                    )));
      }
    });
  }

  void onAddPressed() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addUserView()));
  }
}
