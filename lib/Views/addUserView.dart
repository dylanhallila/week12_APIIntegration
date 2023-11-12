import "package:flutter/material.dart";
import "package:hallila_week12/Repositories/UserClient.dart";
import "package:hallila_week12/Views/usersView.dart";
import "../Models/User.dart";

class addUserView extends StatefulWidget {
  final UserClient userClient = UserClient();
  addUserView({Key? key}) : super(key: key);

  @override
  State<addUserView> createState() => _addUserViewState();
}

bool _loading = false;

class _addUserViewState extends State<addUserView> {
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var emailController = new TextEditingController();
  var authLevelController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("View Users"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Enter Credentials"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(hintText: "Username"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: authLevelController,
                          decoration:
                              InputDecoration(hintText: "Authorization Level"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: onAddButtonPress, child: Text("Add User"))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddButtonPress() {
    setState(() {
      var newUser = new User(
          "placeholder",
          usernameController.text,
          passwordController.text,
          emailController.text,
          authLevelController.text);

      widget.userClient.Add(newUser);

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

  onGetUsersSuccess(List<User>? users) {
    setState(() {
      if (users != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UsersView(
                      inUsers: users,
                    )));
      }
    });
  }
}
