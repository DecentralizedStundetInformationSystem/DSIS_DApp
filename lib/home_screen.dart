import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dsis_app/contract_classes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<Color> borderColors = [
  const Color(0xFF74c7ec),
  const Color(0xFFcba6f7),
  const Color(0xFFeba0ac),
  const Color(0xFFfab387),
  const Color(0xFFe5c890),
  const Color(0xFFa6d189),
  const Color(0xFF99d1db),
  const Color(0xFF8caaee),
  const Color(0xFFbabbf1),
];
bool _isLoading = true;

String capitalize(String str) {
  return '${str.split(' ')[0][0].toUpperCase()}${str.split(' ')[0].substring(1)} ${str.split(' ')[1][0].toUpperCase()}${str.split(' ')[1].substring(1)}';
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  late String contractAddress;
  late Web3Client ethClient;
  late Client httpClient;
  late String projectURL;
  late Student student;

  Future<String> getContractAddress(String userEmail) async {
    String contractAddress = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('students')
        .where('email', isEqualTo: userEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      contractAddress = querySnapshot.docs.first.get('contract');
    }
    return contractAddress;
  }

  Future<Student> initStudent() async {
    _isLoading = true;
    await dotenv.load();
    projectURL = dotenv.env['PROJECT_URL']!;
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['tag'] == 'user') {
        user = args['data'] as User;
      } else if (args['tag'] == 'student') {
        student = args['data'] as Student;
        return student;
      }
    }
    httpClient = Client();
    ethClient = Web3Client(projectURL, httpClient);
    var contractAddress = await getContractAddress(user.email!);
    String studentFile =
        await rootBundle.loadString("assets/contracts/student.json");
    String termFile = await rootBundle.loadString("assets/contracts/term.json");
    String courseFile =
        await rootBundle.loadString("assets/contracts/course.json");
    var contract = DeployedContract(
        ContractAbi.fromJson(studentFile, 'Student'),
        EthereumAddress.fromHex(contractAddress));
    var name = await ethClient.call(
      contract: contract,
      function: contract.function('getName'),
      params: [],
    );
    var faculty = await ethClient.call(
      contract: contract,
      function: contract.function('getFaculty'),
      params: [],
    );
    var department = await ethClient.call(
      contract: contract,
      function: contract.function('getDepartment'),
      params: [],
    );
    var regYear = await ethClient.call(
      contract: contract,
      function: contract.function('getRegYear'),
      params: [],
    );
    var id = await ethClient.call(
      contract: contract,
      function: contract.function('getID'),
      params: [],
    );
    var result = await ethClient.call(
      contract: contract,
      function: contract.function('getTerms'),
      params: [],
    );
    List<Term> termList = [];
    List<String> arr = result[0]
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '')
        .split(',');
    if (arr[0].toString() != '') {
      for (int i = 0; i < arr.length; i++) {
        var termContract = DeployedContract(
            ContractAbi.fromJson(termFile, 'Term'),
            EthereumAddress.fromHex(
                arr[i].toString().replaceAll('[', '').replaceAll(']', '')));
        var termYear = await ethClient.call(
            contract: termContract,
            function: termContract.function('year'),
            params: []);
        var termSeason = await ethClient.call(
            contract: termContract,
            function: termContract.function('season'),
            params: []);
        var termCourses = await ethClient.call(
            contract: termContract,
            function: termContract.function('getCourses'),
            params: []);
        List<String> termCourseList = termCourses[0]
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
        List<Course> courses = [];
        if (termCourseList[0].toString() != '') {
          for (int i = 0; i < termCourseList.length; i++) {
            var courseContract = DeployedContract(
                ContractAbi.fromJson(courseFile, 'Course'),
                EthereumAddress.fromHex(
                    termCourseList[i].toString().replaceAll(' ', '')));
            var courseName = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('name'),
                params: []);
            var courseID = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('courseID'),
                params: []);
            var courseCode = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('courseCode'),
                params: []);
            var courseInstructor = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('instructor'),
                params: []);
            var courseAttendance = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('getAttendance'),
                params: []);
            var courseCredit = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('credit'),
                params: []);
            var courseOverallGrade = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('overallGrade'),
                params: []);
            var courseLetterGrade = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('letterGrade'),
                params: []);
            var courseEvalCount = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('evaluationCount'),
                params: []);
            var courseResultContents = await ethClient.call(
                contract: courseContract,
                function: courseContract.function('getEvaluationCriteria'),
                params: []);
            var courseResult = courseResultContents[0];
            List<EvaluationCriterion> evaluationCriteria = [];
            for (int i = 0; i < int.parse(courseEvalCount[0].toString()); i++) {
              EvaluationCriterion evaluationCriterion = EvaluationCriterion(
                  courseResult[i][0].toString(),
                  int.parse(courseResult[i][1].toString()),
                  int.parse(courseResult[i][2].toString()));
              evaluationCriteria.add(evaluationCriterion);
            }
            BigInt courseIDValue = BigInt.parse(courseID[0].toString());
            BigInt courseAttendanceValue =
                BigInt.parse(courseAttendance[0].toString());
            BigInt courseCreditValue = BigInt.parse(courseCredit[0].toString());
            BigInt courseEvalValue =
                BigInt.parse(courseEvalCount[0].toString());
            Course course = Course(
                courseName[0].toString(),
                courseIDValue.toInt(),
                courseCode[0].toString(),
                courseInstructor[0].toString(),
                courseAttendanceValue.toInt(),
                courseCreditValue.toInt(),
                courseEvalValue.toInt(),
                evaluationCriteria,
                courseOverallGrade[0].toString(),
                courseLetterGrade[0].toString());
            courses.add(course);
          }
        }
        BigInt termYearValue = BigInt.parse(termYear[0].toString());
        Term term =
            Term(termYearValue.toInt(), termSeason[0].toString(), courses);
        termList.add(term);
      }
    }
    BigInt studentIDValue = BigInt.parse(id[0].toString());
    BigInt studentRegYearValue = BigInt.parse(regYear[0].toString());
    student = Student(
        name[0].toString(),
        studentIDValue.toInt(),
        faculty[0].toString(),
        department[0].toString(),
        studentRegYearValue.toInt(),
        termList);
    setState(() {
      _isLoading = false;
    });
    return student;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    initStudent().then((initializedStudent) {
      setState(() {
        student = initializedStudent;
        for (int i = 0; i < student.terms.length; i++) {
          for (int j = 0; j < student.terms[i].courses.length; j++) {
            courseLoad++;
            creditLoad += student.terms[i].courses[j].credit;
          }
        }
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  int courseLoad = 0;
  int creditLoad = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: _isLoading
            ? const Text('')
            : Align(
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
            ListTile(
              title: const Text('Transcript'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/transcript',
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
      body: _isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator())),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OrangeBox(
                      width: screenWidth * 1,
                      height: screenHeight * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ID : ${student.id}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    'Class : ${(student.terms.length / 2 + 1).toInt()}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Faculty : Faculty of ${student.faculty}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    'Department : ${student.department}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OrangeBox(
                          width: screenWidth * 0.46,
                          height: screenWidth * 0.46,
                          child: CircularIndicatorWidget(
                            bigValue: 46,
                            smallValue: courseLoad,
                            header: 'Your Course Load',
                          ),
                        ),
                        OrangeBox(
                          width: screenWidth * 0.46,
                          height: screenWidth * 0.46,
                          child: CircularIndicatorWidget(
                            bigValue: 240,
                            smallValue: creditLoad,
                            header: 'Your ECTS Load',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    OrangeBox(
                      width: screenWidth,
                      height: student.terms.isNotEmpty
                          ? screenHeight * 0.07 +
                              (0.05 *
                                  student.terms[0].courses.length *
                                  screenHeight)
                          : 100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(flex: 6, child: Text('Course')),
                                Expanded(flex: 4, child: Text('Absenteeism'))
                              ],
                            ),
                            if (student.terms.isNotEmpty)
                              ...List<Row>.generate(
                                  student.terms[student.terms.length - 1]
                                      .courses.length, (index) {
                                Course course = student
                                    .terms[student.terms.length - 1]
                                    .courses[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex: 6, child: Text(course.name)),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.25,
                                            child: LinearProgressIndicator(
                                              value: 0,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(2)),
                                          Text(
                                              '${course.attendance.toString()}/12'),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CircularIndicatorWidget extends StatefulWidget {
  final int bigValue;
  final int smallValue;
  final String header;

  const CircularIndicatorWidget(
      {super.key,
      required this.bigValue,
      required this.smallValue,
      required this.header});

  @override
  State<CircularIndicatorWidget> createState() =>
      _CircularIndicatorWidgetState();
}

class _CircularIndicatorWidgetState extends State<CircularIndicatorWidget> {
  late Color color1;
  late Color color2;

  @override
  void initState() {
    // TODO: implement initState
    final random = Random();
    color1 = borderColors[random.nextInt(borderColors.length)];
    color2 = borderColors[random.nextInt(borderColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.header,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
          CircularPercentIndicator(
            radius: 60,
            percent: (widget.smallValue / widget.bigValue),
            backgroundColor: color1,
            progressColor: color2,
            lineWidth: 6,
            center: Text('${widget.smallValue} of ${widget.bigValue}'),
          ),
        ]);
  }
}

class OrangeBox extends StatefulWidget {
  const OrangeBox(
      {super.key,
      required this.child,
      required this.width,
      required this.height});

  final Widget child;
  final double width;
  final double height;

  @override
  State<OrangeBox> createState() => _OrangeBoxState();
}

class _OrangeBoxState extends State<OrangeBox> {
  late Color color1;

  @override
  void initState() {
    // TODO: implement initState
    final random = Random();
    color1 = borderColors[random.nextInt(borderColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 6),
              border: Border.all(color: color1, width: 3),
              color: const Color(0xFF1e1e2e)),
          child:
              Padding(padding: const EdgeInsets.all(4), child: widget.child)),
    );
  }
}
