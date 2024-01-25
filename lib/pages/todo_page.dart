//   //
//  Import LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';
//  Import FILES
import '../models/todo.dart';
//  PARTS
//  PROVIDERS

// /

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Page'),
      ),
      // body: const Center(
      //   child: Text('Todo Page'),
      // ),
      body: Consumer(
        builder: (context, wiRef, child) {
          List<Todo> todos = wiRef.watch(todoNotifierProvider);
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              return ListTile(
                leading: IconButton.filledTonal(
                  onPressed: () {
                    buildUpdate(todo);
                  },
                  icon: const Icon(Icons.edit),
                ),
                title: Text(todo.title),
                subtitle: Text(todo.body),
                // trailing: const Icon(Icons.delete),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(todoNotifierProvider.notifier).remove(todo.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // buildAdd();
          buildAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // buildAdd(BuildContext context) {
  buildAdd() {
    final edtTitle = TextEditingController();
    final edtBody = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        // title: const Text('Add Todo'),
        title: const Text('Add Todo'),
        contentPadding: const EdgeInsets.all(20.0),
        children: <Widget>[
          TextField(controller: edtTitle),
          const SizedBox(height: 20.0),
          TextField(controller: edtBody),
          const SizedBox(height: 20.0),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .read(todoNotifierProvider.notifier)
                    .add(edtTitle.text, edtBody.text);
              },
              child: const Text('Save'))
        ],
      ),
    );
  }

  buildUpdate(Todo oldTodo) {
    final edtTitle = TextEditingController();
    final edtBody = TextEditingController();
    edtTitle.text = oldTodo.title;
    edtBody.text = oldTodo.body;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Update Todo'),
        contentPadding: const EdgeInsets.all(20.0),
        children: <Widget>[
          TextField(controller: edtTitle),
          const SizedBox(height: 20.0),
          TextField(controller: edtBody),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Todo todoUpdated = oldTodo.copyWith(
                title: edtTitle.text,
                body: edtBody.text,
              );
              ref.read(todoNotifierProvider.notifier).update(todoUpdated);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
