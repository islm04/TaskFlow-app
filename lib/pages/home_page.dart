import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Home Page",
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 21, 55, 112),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),
      body: Center(child: Text("Register Succeded")),
    );
  }
}
