import 'dart:async';

class Process {
  int id;
  bool hasToken;
  Process next;

  Process(this.id, {this.hasToken = false});

  void start() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (hasToken) {
        enterCriticalSection();
        passToken();
      }
    });
  }

  void enterCriticalSection() {
    print('Process $id is in the critical section.');
    Future.delayed(Duration(seconds: 1), () {
      print('Process $id is leaving the critical section.');
    });
  }

  void passToken() {
    Future.delayed(Duration(seconds: 1), () {
      print('Process $id passes token to Process ${next.id}');
      hasToken = false;
      next.hasToken = true;
    });
  }
}

void main() {
  int numProcesses = 5;
  List<Process> processes = List.generate(numProcesses, (i) => Process(i));

  for (int i = 0; i < numProcesses; i++) {
    processes[i].next = processes[(i + 1) % numProcesses]; // Create ring
  }

  processes[0].hasToken = true; // Initial token holder

  for (var process in processes) {
    process.start();
  }
}
