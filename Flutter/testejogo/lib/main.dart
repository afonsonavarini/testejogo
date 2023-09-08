import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double object1X = 50;
  double object1Y = 200;
  double object2X = 250;
  double object2Y = 200;
  bool isColliding = false;

  late List<List<double>> matrixA;
  late List<List<double>> matrixB;
  late List<List<double>> resultMatrix;

  @override
  void initState() {
    super.initState();

    matrixA = generateRandomMatrix(3, 3);
    matrixB = generateRandomMatrix(3, 3);
    resultMatrix = List.generate(3, (_) => List.filled(3, 0.0));

    Timer.periodic(Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  void updateGame() {
    setState(() {
      // Move objects or perform other game logic here
      object1X += 1;
      object2X -= 1;

      // Perform matrix multiplication in a loop
      for (int i = 0; i < matrixA.length; i++) {
        for (int j = 0; j < matrixB[0].length; j++) {
          resultMatrix[i][j] = 0;
          for (int k = 0; k < matrixA[0].length; k++) {
            resultMatrix[i][j] += matrixA[i][k] * matrixB[k][j];
          }
        }
      }

      // Check for collision
      isColliding = checkCollision();
    });
  }

  List<List<double>> generateRandomMatrix(int rows, int cols) {
    var rng = Random();
    return List.generate(rows, (_) {
      return List.generate(cols, (_) => rng.nextDouble() * 10);
    });
  }

  bool checkCollision() {
    double distance = sqrt(pow(object1X - object2X, 2) + pow(object1Y - object2Y, 2));
    return distance < 50; // Assuming radius of both objects is 50
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game with Intensive Calculations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Collision: $isColliding',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: object1X,
                    top: object1Y,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    left: object2X,
                    top: object2Y,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Matrix Multiplication Result:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: resultMatrix.map((row) {
                return Text(row.toString());
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
