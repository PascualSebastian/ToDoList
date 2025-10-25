# What My App Does and Why
My app is a simple to-do list app where a user can add and remove tasks. Furthermore, the user can delete all tasks altogether by clicking the trash icon at the top right of the screen. Also, the user can mark the task complete, and it will be indicated by a line going through it. The tasks persist locally using shared_preferences even after closing the app or refreshing it. The reason why I wanted to make this app was because I know how difficult it is to stay on top of things. So this app helps with staying organized and making sure you do not miss anything. 
# What Storage Did I Use
I used shared_preferences to keep track of my data and allow it to persist
The features in my app include:
* Add, toggle, and delete tasks
* “Clear all” option with confirmation dialog
* Snackbar feedback for every action
* Persistent storage (data reloads automatically on app launch
# How to Run and Test Persistence
1. Clone the repo
2. Run flutter pub get
3. Run with flutter run on an emulator or simulator
4. Add tasks, close the app, and reopen. (Your tasks will remain)
# Data Format and Edge Cases
The data format I used was a JSON list of task objects, for example: <br/>
[
  {"title": "Buy groceries", "done": false},
  {"title": "Do laundry", "done": true}
]
* On the first run, it will be an empty list.
* Corrupted/missing data is handled safely thanks to my try and catch statement. 
* Empty inputs are ignored
* Confirmation dialog appears before deleting all tasks

Github Repository Link: https://github.com/PascualSebastian/ToDoList- <br/>
Loom Link: https://www.loom.com/share/ca9bc183bd2e4f7a93499b006aed7eab 
