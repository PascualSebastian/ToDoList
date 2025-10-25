import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoPage(),
    );
  }
}

// Stateful because to-do list will change (adding/removing tasks)
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> tasks = [];
  final TextEditingController controller = TextEditingController(); // Read and clear text from input field

  @override
  void initState() {
    super.initState();
    loadTasks(); // Loads saved tasks from local storage
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      // Ensure app does not crash if data is corrupted
      try {
        final List decoded = jsonDecode(tasksString);
        setState(() {
          tasks = decoded.map((e) => Task.fromJson(e)).toList();
        });
      } catch (e) {
        setState(() => tasks = []);
      }
    }
  }

  // Converts each task to a JSON map
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', encoded);
  }

  // Adds new task to the list
  void addTask() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      tasks.add(Task(title:text));
      controller.clear();
    });
    saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added!')),
    );
  }

  // Flips the done status (true/false) of a task when the checkbox is tapped
  void toggleTask(int index) {
    setState(() => tasks[index].done = !tasks[index].done);
    saveTasks();
  }

  // Remoevs a task by index
  void deleteTask(int index) {
    setState(() => tasks.removeAt(index));
    saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted!')),
    );
  }

  // Clears all the tasks
  void clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasks');
    setState(() => tasks = []);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All tasks cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear all',
            onPressed: tasks.isEmpty
                ? null 
                : () => showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text('Clear all tasks?'),
                    content:
                        const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () {
                          Navigator.pop(context);
                          clearAll();
                        },
                      )
                    ],
                  ),
                ),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
            child: Text(
              'No tasks yet. Add one below!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
          : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: task.done,
                    onChanged: (_) => toggleTask(index),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                ),
              );
            },
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter a task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: addTask,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}