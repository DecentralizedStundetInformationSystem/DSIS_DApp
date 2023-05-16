import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dsis_app/contract_classes.dart';
import 'home_screen.dart';

double _height = 50;
int selectedTermIndex = 0;

class SemesterGrades extends StatefulWidget {
  const SemesterGrades({Key? key}) : super(key: key);

  @override
  State<SemesterGrades> createState() => _SemesterGradesState();
}

class _SemesterGradesState extends State<SemesterGrades> {
  late Color borderColor;
  late double screenWidth;
  late double screenHeight;
  late Student student;
  late String firstYear;
  String yearValue = '2023';
  String semesterValue = 'Fall';
  
  void _onHeightChanged(double newHeight) {
    setState(() {
      _height = newHeight;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['tag'] == 'student') {
        // Student object was passed
        student = args['data'] as Student;
        // Do something with student object
      }
    }
    firstYear = student.terms.isNotEmpty ? student.terms[0].year.toString() : "";
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    borderColor = Colors.transparent;
    List<Term> dropTermsList = [];
    for (int i = 0; i < student.terms.length; i += 2){
      dropTermsList.add(student.terms[i]);
    }
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
                  Navigator.pushNamed(context, '/home', arguments: {
                    'tag': 'student',
                    'data': student,
                  },
                  );
                  _height = 50;
                },
              ),
              ListTile(
                title: const Text('Transcript'),
                onTap: () {
                  Navigator.pushNamed(context, '/transcript', arguments: {
                    'tag': 'student',
                    'data': student,
                  },
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrangeBox(
                    width: screenWidth * 0.46,
                    height: screenHeight * 0.05,
                    child: Center(
                      child: DropdownButton<String>(
                        isExpanded: false,
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        alignment: Alignment.center,
                        elevation: 0,
                        dropdownColor: const Color(0xFF1e1e2e),
                        borderRadius: BorderRadius.circular(4),
                        underline: const SizedBox(
                          width: 0,
                        ),
                        value: yearValue,
                        onChanged: (String? newValue) {
                          if(newValue == yearValue) {
                            return;
                          }
                          setState(() {
                            if(int.parse(newValue!) - int.parse(firstYear) == 0){
                              selectedTermIndex = 0;
                              semesterValue = 'Fall';
                            }
                            else if (int.parse(newValue) - int.parse(firstYear) == 1){
                              selectedTermIndex = 2;
                              semesterValue = 'Fall';
                            }
                            else if (int.parse(newValue) - int.parse(firstYear) == 2){
                              selectedTermIndex = 4;
                              semesterValue = 'Fall';
                            }
                            else if (int.parse(newValue) - int.parse(firstYear) == 3){
                              selectedTermIndex = 6;
                              semesterValue = 'Fall';
                            }
                            yearValue = newValue;
                          });
                        },
                        items: dropTermsList
                            .map<DropdownMenuItem<String>>((Term term) {
                          return DropdownMenuItem<String>(
                            value: term.year.toString(),
                            child: Center(
                              child: SizedBox(
                                  width: screenWidth * 0.30,
                                  child: Text(term.year.toString())),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  OrangeBox(
                    width: screenWidth * 0.46,
                    height: screenHeight * 0.05,
                    child: Center(
                      child: DropdownButton<String>(
                        isExpanded: false,
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        alignment: Alignment.center,
                        elevation: 0,
                        dropdownColor: const Color(0xFF1e1e2e),
                        borderRadius: BorderRadius.circular(4),
                        underline: const SizedBox(
                          width: 0,
                        ),
                        value: semesterValue,
                        onChanged: (String? newValue) {
                          if(newValue == semesterValue) {
                            print("came true");
                            return;
                          }
                          else {
                            setState(() {
                              if (newValue == 'Fall') {
                                selectedTermIndex -= 1;
                                semesterValue = newValue!;
                              }
                              else if (newValue == 'Spring') {
                                if (student.terms.length - selectedTermIndex >=
                                    2) {
                                  selectedTermIndex += 1;
                                  semesterValue = newValue!;
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: const Text('Invalid Term'),
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        elevation: 10,
                                        width: 240,
                                      )
                                  );
                                }
                              }
                            });
                          }
                        },
                        items: <String>['Fall', 'Spring']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                                width: screenWidth * 0.30, child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              AnimatedContainer(
                duration: const Duration(microseconds: 200),
                width: screenWidth,
                height: student.terms.isNotEmpty ? _height + student.terms[selectedTermIndex].courses.length * screenHeight * 0.09 : 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(student.terms.isNotEmpty ? (student.terms[selectedTermIndex].courses.length * 75 / 6) : 12),
                      border: Border.all(color: borderColor, width: 3),
                      color: const Color(0xFF1e1e2e)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(flex: 5, child: Text('Course Name')),
                            Expanded(flex: 2, child: Text('Grade')),
                            Expanded(flex: 3, child: Text('')),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        if (student.terms.length > selectedTermIndex)
                        Flexible(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: student.terms[selectedTermIndex].courses.length,
                            itemBuilder: (context, index) => CourseDetails(
                                onHeightChanged: _onHeightChanged,
                                course: student.terms[selectedTermIndex].courses[index], courses: student.terms[selectedTermIndex].courses,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
class CourseDetails extends StatefulWidget {
  final Course course;
  final List<Course> courses;
  final Function(double) onHeightChanged;

  CourseDetails(
      {super.key, required this.course, required this.onHeightChanged, required this.courses});

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      _height = _expanded
          ? _height += 250
          : _height -= 250; // Set the desired height here
    });
    widget.onHeightChanged(_height);
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final borderColor = borderColors[random.nextInt(borderColors.length)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 5, child: Text(widget.course.name)),
            Expanded(flex: 2, child: Text(widget.course.letterGrade)),
            Expanded(
              flex: 3,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _toggleExpanded();
                  });
                },
                child: const Text('Details'),
              ),
            )
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.courses.length * 75 / 12),
              border: Border.all(color: borderColor, width: 3),
              color: const Color(0xFF313244)),
          child: Column(
            children: [
              if (_expanded)
                ...widget.course.evaluationCriteria.map(
                      (entry) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.name),
                        entry.grade == 101 ? const Text('') : Text(entry.grade.toString()),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.courses.length * 75 / 12),
              border: Border.all(color: borderColor, width: 3),
              color: const Color(0xFF313244)),
          child: Column(
            children: [
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Course Code'),
                      Text(widget.course.code),
                    ],
                  ),
                ),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Credit'),
                      Text(widget.course.credit.toString()),
                    ],
                  ),
                ),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Instructor'),
                      Text(widget.course.instructor),
                    ],
                  ),
                ),
            ],
          ),
        ),

      ],
    );
  }
}
