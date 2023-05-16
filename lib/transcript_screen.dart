import 'dart:math';
import 'package:flutter/material.dart';
import 'contract_classes.dart';
import 'home_screen.dart';

Map<String, double> gradeMap = {
  'AA': 4.0,
  'BA': 3.5,
  'BB': 3.0,
  'CB': 2.5,
  'CC': 2.0,
  'DC': 1.5,
  'DD': 1.0,
  'FD': 0.5,
  'FF': 0.0,
};

class TranscriptScreen extends StatefulWidget {
  const TranscriptScreen({Key? key}) : super(key: key);

  @override
  State<TranscriptScreen> createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen> {
  late Student student;
  double gpa = 0;
  int termTotalCredit = 0;
  double termTotalPoints = 0;
  int globalTotalCredit = 0;
  double globalTotalPoints = 0;
  List<double> totalDNO = [];

  String calculateGPA(Term term) {
    double totalPoints = 0;
    int totalCredit = 0;
    int courseCount = term.courses.length;
    for (int j = 0; j < courseCount; j++) {
      Course currentCourse = term.courses[j];
      totalCredit += currentCourse.credit;
      if (currentCourse.letterGrade.isEmpty) {
      } else {
        double coursePoint =
            gradeMap[currentCourse.letterGrade]! * currentCourse.credit;
        totalPoints += coursePoint;
      }
    }
    double DNO = totalPoints / totalCredit;
    termTotalCredit = totalCredit;
    globalTotalCredit += totalCredit;
    termTotalPoints = totalPoints;
    globalTotalPoints += totalPoints;
    double sum = 0;
    for (int i = 0; i < totalDNO.length; i++){
      sum += totalDNO[i];
    }
    totalDNO.add(DNO + sum);
    return DNO.toString();
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['tag'] == 'student') {
        student = args['data'] as Student;
      }
    }
    final random = Random();
    final borderColor = borderColors[random.nextInt(borderColors.length)];
    final borderColor1 = borderColors[random.nextInt(borderColors.length)];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Align(
              alignment: Alignment.topRight,
              child: Text(capitalize(student.name))),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          width: screenWidth * 0.6,
          backgroundColor: const Color(0xFF1e1e2e),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(screenHeight * 0.08),
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: {
                      'tag': 'student',
                      'data': student,
                    },
                  );
                },
              ),
              ListTile(
                title: const Text('Semester Grades'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/semester',
                    arguments: {
                      'tag': 'student',
                      'data': student,
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: student.terms.length,
          itemBuilder: (context, index) {
            final term = student.terms[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: screenWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: borderColor),
                      child: Text(
                        '${term.year} - ${term.season}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Table(
                    columnWidths: const {
                      0: FractionColumnWidth(.19),
                      1: FractionColumnWidth(.35),
                      2: FractionColumnWidth(.15),
                      3: FractionColumnWidth(.2),
                      4: FractionColumnWidth(.13),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: borderColor1),
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                                height: screenHeight * 0.05,
                                child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Code'))),
                          )),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.05,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Course Name'))))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.05,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('ECTS'))))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.05,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Grade'))))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.05,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Point'))))),
                        ],
                      ),
                      ...term.courses.map((course) {
                        termTotalPoints = 0;
                        termTotalCredit = 0;
                        return TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: Text(course.code)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: Text(course.name)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: Text('${course.credit}')))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: Text(course.letterGrade)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: Text(course.letterGrade.isEmpty
                                            ? ''
                                            : (course.credit *
                                                    gradeMap[
                                                        course.letterGrade]!)
                                                .toString())))),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.06,
                                      child: const Text('DNO')))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.06,
                                      child: Text(calculateGPA(term) == '0.0'
                                          ? ''
                                          : calculateGPA(term))))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.06,
                                      child: Text(termTotalCredit.toString())))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.06,
                                      child: const Text('Total')))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                      height: screenHeight * 0.06,
                                      child: Text(termTotalPoints.toString())))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Text('GPA'))),
                          TableCell(
                              child: SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Text((totalDNO[index] / index).toString()))
                          ),
                          TableCell(
                              child: SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Text(globalTotalCredit.toString()))),
                          TableCell(
                              child: SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Text('Grand Total'))),
                          TableCell(
                              child: SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Text(globalTotalPoints.toString()))),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}

