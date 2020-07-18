import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/user.dart';

User_Data currentUser;
bool isDescending = true;
String SearchTag;
List NotesFilters = [];
String SearchNotesByTag = "Search by tags";
String SearchNotesByTitle = "Search by title";
List VideosFilters = [];
String SearchVideosByTag = "Search by tags";
String SearchVideosByTitle = "Search by title";
List DoubtsFilters = [];
String SearchDoubtsByTag = "Search by tags";
String SearchDoubtsByTitle = "Search by title";
QuerySnapshot notesTitles;
QuerySnapshot videosTitles;
String title;
String doubt;
String description;
List tag = [];
List<String> RecentlySearcedTags = [];
List<String> tagsList = [
  "JEE Main",
  "JEE Advance",
  "NEET",
  "Board exams",
  "Mathematics",
  "Physics",
  "Chemistry",
  "Mind Maps",
  "Reactions",
  "Flow Charts",
  "Important Formulas",
  "Structures",
  "Circuit Diagrams"
      "Physical Chemistry",
  "Inorganic Chemistry",
  "Organic Chemistry",
  "Permutation and combination",
  "Calculus",
  "Sets",
  "Relations and functions",
  "Complex numbers" "quadratic equations",
  "Matrices and determinants",
  "Mathematical induction",
  "Binomial theorem and its simple applications",
  "Sequences and series",
  "Coordinate geometry",
  "Vector algebra",
  "Trigonometry",
  "Statistics and probability",
  "Physics and Measurement",
  "Mechanics",
  "Rigid Body Dynamics",
  "Gravitation",
  "Properties Of Solids and Liquids",
  "Oscillations and Waves",
  "Thermodynamics",
  "Electrostatics",
  "Electrodynamics",
  "Magnetism and matter",
  "Electromagnetism",
  "Optics",
  "Modern Physics",
  "Gaseous State",
  "Solutions",
  "Solid states",
  "Mole concepts",
  "Chemical Bonding and Molecular Structure",
  "Chemical Thermodynamics",
  "Chemical and Ionic Equilibrium",
  "Redox Reactions and Electrochemistry",
  "Chemical Kinetics",
  "Surface Chemistry",
  "Periodic Table",
  "s-Block",
  "p-block",
  "d&f block",
  "Hydrogen and its properties",
  "General Principles and Processes of Isolation of Metals",
  "Coordination Compounds",
  "Environmental Chemistry",
  "General Organic Chemistry",
  "Hydrocarbons",
  "Organic Compounds Containing Halogens",
  "Organic Compounds Containing Oxygen",
  "Alcohols, Phenols and Ethers",
  "Organic Compounds Containing Nitrogen",
  "Polymers",
  "Biomolecules",
  "Chemistry in Everyday Life"
];

bool assert_1 = true;
List bookmarkUIDs = [];
List bookmarkFiles = ['Default'];
Map bookmarkStructure = {};

List watchLaterUids = [];
