
// lib/features/interview/data/datasources/question_bank.dart
import 'package:ai_interview_app/Screens/mainScreen/model/question_model.dart';

//import '../../domain/entities/question_entity.dart';

class QuestionBank {
  // ─── FLUTTER ─────────────────────────────────────────────────────────────
  static const List<QuestionEntity> flutter = [
    QuestionEntity(
      question: "What is Flutter?",
      level: "Beginner",
      keywords: ["google", "ui toolkit", "dart", "cross platform", "mobile"],
    ),
    QuestionEntity(
      question: "What is a Widget?",
      level: "Beginner",
      keywords: ["building block", "ui", "everything is widget", "component"],
    ),
    QuestionEntity(
      question: "What is StatelessWidget?",
      level: "Beginner",
      keywords: [
        "immutable",
        "no state",
        "static ui",
        "does not change its state",
      ],
    ),
    QuestionEntity(
      question: "What is StatefulWidget?",
      level: "Beginner",
      keywords: [
        "mutable",
        "dynamic ui",
        "setstate",
        "state object",
        "change its state",
      ],
    ),
    QuestionEntity(
      question: "What is hot reload?",
      level: "Beginner",
      keywords: ["instant update", "no restart", "development", "fast testing"],
    ),
    QuestionEntity(
      question: "What is hot restart in Flutter?",
      level: "Easy",
      keywords: ["full reload", "state reset", "restart", "rebuild"],
    ),
    QuestionEntity(
      question:
          "What is the difference between StatelessWidget and StatefulWidget?",
      level: "Easy",
      keywords: ["immutable", "mutable", "setstate", "rebuild"],
    ),
    QuestionEntity(
      question: "What is BuildContext?",
      level: "Easy",
      keywords: ["widget tree", "context", "location", "ancestor"],
    ),
    QuestionEntity(
      question: "What is a Navigator in Flutter?",
      level: "Easy",
      keywords: ["routes", "push", "pop", "navigation", "stack"],
    ),
    QuestionEntity(
      question: "What is the pubspec.yaml file?",
      level: "Easy",
      keywords: ["dependencies", "assets", "configuration", "packages"],
    ),
    QuestionEntity(
      question: "What is setState()?",
      level: "Medium",
      keywords: ["rebuild", "state change", "ui update", "stateful"],
    ),
    QuestionEntity(
      question: "Explain BLoC pattern.",
      level: "Medium",
      keywords: ["business logic", "stream", "event", "state", "bloc"],
    ),
    QuestionEntity(
      question: "What is Provider in Flutter?",
      level: "Medium",
      keywords: ["state management", "changenotifier", "inherited widget"],
    ),
    QuestionEntity(
      question: "What is a Future in Dart?",
      level: "Medium",
      keywords: ["async", "await", "asynchronous", "promise"],
    ),
    QuestionEntity(
      question: "What is a Stream in Dart?",
      level: "Medium",
      keywords: ["data flow", "async", "events", "listen", "streamcontroller"],
    ),
    QuestionEntity(
      question: "What is the widget lifecycle?",
      level: "Hard",
      keywords: ["initstate", "dispose", "build", "didchangedependencies"],
    ),
    QuestionEntity(
      question: "Explain Keys in Flutter.",
      level: "Hard",
      keywords: ["unique key", "value key", "widget identity", "list"],
    ),
    QuestionEntity(
      question: "What is RenderObject?",
      level: "Hard",
      keywords: ["painting", "layout", "rendering pipeline"],
    ),
    QuestionEntity(
      question: "What is isolate in Dart?",
      level: "Hard",
      keywords: ["multithreading", "parallel", "compute", "concurrency"],
    ),
    QuestionEntity(
      question: "Explain the Flutter rendering pipeline.",
      level: "Hard",
      keywords: ["build", "layout", "paint", "composite", "skia"],
    ),
  ];

  // ─── JAVA ─────────────────────────────────────────────────────────────────
  static const List<QuestionEntity> java = [
    QuestionEntity(
      question: "What is Java?",
      level: "Beginner",
      keywords: [
        "object oriented",
        "platform independent",
        "jvm",
        "high level",
        "sun microsystems",
      ],
    ),
    QuestionEntity(
      question: "What is OOP?",
      level: "Beginner",
      keywords: [
        "object oriented programming",
        "encapsulation",
        "inheritance",
        "polymorphism",
        "abstraction",
      ],
    ),
    QuestionEntity(
      question: "What is a class and object?",
      level: "Beginner",
      keywords: ["blueprint", "instance", "attributes", "methods"],
    ),
    QuestionEntity(
      question: "What is JVM?",
      level: "Beginner",
      keywords: [
        "java virtual machine",
        "bytecode",
        "platform independent",
        "runtime",
      ],
    ),
    QuestionEntity(
      question: "What is JDK?",
      level: "Beginner",
      keywords: ["java development kit", "compiler", "jre", "tools"],
    ),
    QuestionEntity(
      question: "Explain inheritance.",
      level: "Easy",
      keywords: [
        "extends",
        "parent class",
        "child class",
        "reuse",
        "is-a relationship",
      ],
    ),
    QuestionEntity(
      question: "What is encapsulation?",
      level: "Easy",
      keywords: [
        "data hiding",
        "private",
        "getter",
        "setter",
        "access modifiers",
      ],
    ),
    QuestionEntity(
      question: "Difference between List and Set?",
      level: "Easy",
      keywords: ["duplicates", "order", "collection", "unique elements"],
    ),
    QuestionEntity(
      question: "What is a constructor?",
      level: "Easy",
      keywords: ["initialize", "same name as class", "object creation"],
    ),
    QuestionEntity(
      question: "What is method overloading?",
      level: "Easy",
      keywords: [
        "same method name",
        "different parameters",
        "compile time polymorphism",
      ],
    ),
    QuestionEntity(
      question: "What is exception handling?",
      level: "Medium",
      keywords: ["try", "catch", "finally", "runtime error", "throw"],
    ),
    QuestionEntity(
      question: "Explain multithreading.",
      level: "Medium",
      keywords: [
        "threads",
        "parallel execution",
        "concurrency",
        "runnable",
        "thread class",
      ],
    ),
    QuestionEntity(
      question: "What is the collection framework?",
      level: "Medium",
      keywords: ["list", "set", "map", "interfaces", "data structure"],
    ),
    QuestionEntity(
      question: "What is abstraction?",
      level: "Medium",
      keywords: [
        "hide implementation",
        "abstract class",
        "interface",
        "oop concept",
      ],
    ),
    QuestionEntity(
      question: "Difference between interface and abstract class?",
      level: "Medium",
      keywords: [
        "multiple inheritance",
        "abstract methods",
        "implements",
        "extends",
      ],
    ),
    QuestionEntity(
      question: "Explain garbage collection.",
      level: "Hard",
      keywords: ["memory management", "heap", "automatic", "jvm"],
    ),
    QuestionEntity(
      question: "What is synchronization?",
      level: "Hard",
      keywords: [
        "thread safety",
        "shared resource",
        "synchronized keyword",
        "race condition",
      ],
    ),
    QuestionEntity(
      question: "What is the Spring framework?",
      level: "Hard",
      keywords: ["dependency injection", "mvc", "enterprise", "framework"],
    ),
    QuestionEntity(
      question: "What is the JVM memory model?",
      level: "Hard",
      keywords: ["heap", "stack", "method area", "memory structure"],
    ),
    QuestionEntity(
      question: "Explain design patterns in Java.",
      level: "Hard",
      keywords: ["singleton", "factory", "observer", "reusable solution"],
    ),
  ];

  // ─── PYTHON ──────────────────────────────────────────────────────────────
  static const List<QuestionEntity> python = [
    QuestionEntity(
      question: "What is Python?",
      level: "Beginner",
      keywords: ["interpreted", "high level", "readable", "dynamic typing"],
    ),
    QuestionEntity(
      question: "What is a list?",
      level: "Beginner",
      keywords: ["mutable", "ordered", "collection", "square brackets"],
    ),
    QuestionEntity(
      question: "What is a tuple?",
      level: "Beginner",
      keywords: ["immutable", "ordered", "parentheses"],
    ),
    QuestionEntity(
      question: "What is a dictionary?",
      level: "Beginner",
      keywords: ["key value", "mapping", "curly braces"],
    ),
    QuestionEntity(
      question: "What is indentation?",
      level: "Beginner",
      keywords: ["code block", "whitespace", "syntax"],
    ),
    QuestionEntity(
      question: "Difference between list and tuple?",
      level: "Easy",
      keywords: ["mutable", "immutable", "list", "tuple"],
    ),
    QuestionEntity(
      question: "What is a lambda function?",
      level: "Easy",
      keywords: ["anonymous function", "lambda keyword", "inline function"],
    ),
    QuestionEntity(
      question: "What is a virtual environment?",
      level: "Easy",
      keywords: ["isolated", "dependencies", "venv"],
    ),
    QuestionEntity(
      question: "What is pip?",
      level: "Easy",
      keywords: ["package manager", "install packages", "pip install"],
    ),
    QuestionEntity(
      question: "What is slicing?",
      level: "Easy",
      keywords: ["substring", "range", "indexing"],
    ),
    QuestionEntity(
      question: "Explain decorators.",
      level: "Medium",
      keywords: ["wrapper function", "modify behavior", "@decorator"],
    ),
    QuestionEntity(
      question: "What is a generator?",
      level: "Medium",
      keywords: ["yield", "iterator", "lazy evaluation"],
    ),
    QuestionEntity(
      question: "What is exception handling?",
      level: "Medium",
      keywords: ["try", "except", "finally", "error handling"],
    ),
    QuestionEntity(
      question: "Explain OOP in Python.",
      level: "Medium",
      keywords: ["class", "object", "inheritance", "polymorphism"],
    ),
    QuestionEntity(
      question: "What is multithreading in Python?",
      level: "Medium",
      keywords: ["threads", "concurrency", "parallel execution"],
    ),
    QuestionEntity(
      question: "Explain GIL.",
      level: "Hard",
      keywords: [
        "global interpreter lock",
        "thread",
        "single thread execution",
      ],
    ),
    QuestionEntity(
      question: "What is a metaclass?",
      level: "Hard",
      keywords: ["class of class", "type", "object creation"],
    ),
    QuestionEntity(
      question: "What is async in Python?",
      level: "Hard",
      keywords: ["async", "await", "asynchronous", "non blocking"],
    ),
    QuestionEntity(
      question: "Explain memory management in Python.",
      level: "Hard",
      keywords: ["garbage collection", "reference counting", "heap memory"],
    ),
    QuestionEntity(
      question: "What is Django ORM?",
      level: "Hard",
      keywords: ["database", "object relational mapping", "models"],
    ),
  ];

  // ─── C++ ─────────────────────────────────────────────────────────────────
  static const List<QuestionEntity> cpp = [
    QuestionEntity(
      question: "What is C++?",
      level: "Beginner",
      keywords: ["object oriented", "procedural", "compiled language"],
    ),
    QuestionEntity(
      question: "What is a pointer?",
      level: "Beginner",
      keywords: ["memory address", "dereference", "address operator"],
    ),
    QuestionEntity(
      question: "What is a reference variable?",
      level: "Beginner",
      keywords: ["alias", "reference operator", "&"],
    ),
    QuestionEntity(
      question: "What is a class?",
      level: "Beginner",
      keywords: ["blueprint", "object", "oop"],
    ),
    QuestionEntity(
      question: "What is an object?",
      level: "Beginner",
      keywords: ["instance", "class"],
    ),
    QuestionEntity(
      question: "Difference between struct and class?",
      level: "Easy",
      keywords: ["public", "private", "access specifier"],
    ),
    QuestionEntity(
      question: "What is a constructor?",
      level: "Easy",
      keywords: ["initialize", "object creation", "same name as class"],
    ),
    QuestionEntity(
      question: "What is a destructor?",
      level: "Easy",
      keywords: ["cleanup", "memory release", "~"],
    ),
    QuestionEntity(
      question: "What is STL?",
      level: "Easy",
      keywords: ["vector", "map", "algorithm", "template"],
    ),
    QuestionEntity(
      question: "What is a namespace?",
      level: "Easy",
      keywords: ["scope", "avoid conflicts", "std"],
    ),
    QuestionEntity(
      question: "Explain polymorphism.",
      level: "Medium",
      keywords: ["overloading", "overriding", "virtual function"],
    ),
    QuestionEntity(
      question: "What is inheritance?",
      level: "Medium",
      keywords: ["base class", "derived class", "reuse"],
    ),
    QuestionEntity(
      question: "What is a virtual function?",
      level: "Medium",
      keywords: ["runtime polymorphism", "override", "virtual keyword"],
    ),
    QuestionEntity(
      question: "What is memory management in C++?",
      level: "Medium",
      keywords: ["new", "delete", "heap memory"],
    ),
    QuestionEntity(
      question: "What is a template?",
      level: "Medium",
      keywords: ["generic programming", "type parameter"],
    ),
    QuestionEntity(
      question: "Explain smart pointers.",
      level: "Hard",
      keywords: ["unique_ptr", "shared_ptr", "memory management"],
    ),
    QuestionEntity(
      question: "What is multithreading in C++?",
      level: "Hard",
      keywords: ["thread", "parallel execution", "concurrency"],
    ),
    QuestionEntity(
      question: "What is RAII?",
      level: "Hard",
      keywords: ["resource management", "constructor", "destructor"],
    ),
    QuestionEntity(
      question: "Explain move semantics.",
      level: "Hard",
      keywords: ["rvalue reference", "std::move", "performance"],
    ),
    QuestionEntity(
      question: "What is the diamond problem?",
      level: "Hard",
      keywords: ["multiple inheritance", "ambiguity", "virtual inheritance"],
    ),
  ];

  /// Returns filtered list by languageId and difficulty level.
  static List<QuestionEntity> getQuestions({
    required String languageId,
    required String level,
    required int count,
  }) {
    List<QuestionEntity> pool;
    switch (languageId.toLowerCase()) {
      case 'flutter':
        pool = flutter;
        break;
      case 'java':
        pool = java;
        break;
      case 'python':
        pool = python;
        break;
      case 'cpp':
        pool = cpp;
        break;
      default:
        pool = java;
    }

    // Filter by difficulty — cascade up if not enough
    final levels = _levelsFrom(level);
    List<QuestionEntity> filtered =
        pool.where((q) => levels.contains(q.level)).toList()..shuffle();

    return filtered.take(count).toList();
  }

  static List<String> _levelsFrom(String level) {
    switch (level) {
      case 'Beginner':
        return ['Beginner'];
      case 'Easy':
        return ['Beginner', 'Easy'];
      case 'Medium':
        return ['Beginner', 'Easy', 'Medium'];
      case 'Hard':
        return ['Beginner', 'Easy', 'Medium', 'Hard'];
      default:
        return ['Beginner', 'Easy', 'Medium'];
    }
  }
}
