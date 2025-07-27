import 'package:flutter/material.dart';
import 'package:taskflow/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) async {
    // get auth service
    final auth = AuthService();
    auth.signOut();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Container(
                  height: 160,
                  alignment: Alignment.center,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Icon(
                    Icons.note_alt_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              // notes tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("H O M E"),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // settings tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text("S E T T I N G S"),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // navigate to settings page
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
              ),
            ],
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("L O G O U T"),
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
