import 'package:flutter/material.dart';
import 'package:flutter_my_first_app/add_projects_form.dart';

class ProjectScreen extends StatefulWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectScreen({super.key, required this.projects});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late List<Map<String, dynamic>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = widget.projects
        .map((project) => Map<String, dynamic>.from(project))
        .toList();
    sortProjectsList();
  }

  // Method to handle both adding and editing projects
  void _addOrEditProject({int? index}) async {
    // Initialize editedProject as null-safe and type it correctly
    final Map<String, dynamic>? editedProject = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => index != null
            ? AddProjectForm(
                initialTitle: _projects[index]['title'],
                initialDescription: _projects[index]['description'],
              )
            : const AddProjectForm(),
      ),
    );

    // If editedProject is not null, update or add the project
    if (editedProject != null) {
      setState(() {
        if (index != null) {
          // Update the edited project
          _projects[index] = Map<String, dynamic>.from(editedProject);
        } else {
          // Add new project
          _projects.add(Map<String, dynamic>.from(editedProject));
        }
        sortProjectsList();
      });
    }
  }

  void _togglePinProject(int index) {
    setState(() {
      _projects[index]['isPinned'] = !(_projects[index]['isPinned'] ?? false);
      sortProjectsList();
    });
  }

  void sortProjectsList() {
    _projects.sort(
        (a, b) => b['isPinned'].toString().compareTo(a['isPinned'].toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return ListTile(
            title: Text(project['title'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(project['description']),
            trailing: IconButton(
              icon: Icon(project['isPinned'] == true
                  ? Icons.push_pin
                  : Icons.push_pin_outlined),
              onPressed: () => _togglePinProject(index),
            ),
            onTap: () {
              // Trigger edit mode when a project is tapped
              _addOrEditProject(index: index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProject(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
