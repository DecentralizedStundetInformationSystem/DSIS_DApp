import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class Term {
  int year;
  String season;
  List<Course> courses;

  Term(this.year, this.season, this.courses);
}

class EvaluationCriterion {
  String name;
  int weight;
  int grade;

  EvaluationCriterion(this.name, this.weight, this.grade);
  
}

class Course {
  String name;
  int id;
  String code;
  String instructor;
  int credit;
  int evalCount;
  List<EvaluationCriterion> evaluationCriteria;
  String overallGrade;
  String letterGrade;

  Course(
      this.name,
      this.id,
      this.code,
      this.instructor,
      this.credit,
      this.evalCount,
      this.evaluationCriteria,
      this.overallGrade,
      this.letterGrade,
      );
}

class Student {
  String name;
  String faculty;
  String department;
  int regYear;
  int id;
  List<Term> terms = [];

  Student(this.name, this.id, this.faculty, this.department, this.regYear, this.terms);

  String getName() => name;

  String getFaculty() => faculty;

  String getDepartment() => department;

  int getRegYear() => regYear;

  int getID() => id;

  List<Term> getTerms() => terms;
  
}


