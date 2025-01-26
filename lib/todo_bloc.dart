import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'database.dart';

// Event
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String description;

  const AddTodo(this.description);

  @override
  List<Object> get props => [description];
}

class DeleteTodo extends TodoEvent {
  final int id;

  const DeleteTodo(this.id);

  @override
  List<Object> get props => [id];
}

// State
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Map<String, dynamic>> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

// BLoC
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDatabase database;

  TodoBloc(this.database) : super(TodoLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      final todos = await database.readAll();
      emit(TodoLoaded(todos));
    } catch (e) {
      print("Error loading todos: $e");
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await database.create(event.description);
      final updatedTodos = await database.readAll();
      emit(TodoLoaded(updatedTodos));
    } catch (e) {
      print("Error adding todo: $e");
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await database.delete(event.id);
      final updatedTodos = await database.readAll();
      emit(TodoLoaded(updatedTodos));
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }
}