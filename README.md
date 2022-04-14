# End-to-End Encrypted Chat
##### Description:
    a chat application for secure communication between mobile users.

##### Requirments:
    - Flutter 2.8.0
    - Dart 2.16.1
    - Android studio to create an emulator to run the application
    - Nodejs to run the server instance
    - Ngrok to create a tunnel for the local host

##### Instruction:
    - Navigate to the server directory and in the command line run 'node server.js'
    - Run the command 'ngrok http 3000' which will generate a link for localhost:3000
    - In the client directory, navigate to lib/Socket.dart and paste the link generate by ngrok in the host property as a string with 'wss' protocol instead of 'https'
    - In the lib directory run the command 'flutter run' or 'flutter run main.dart' which will start the application on emulator

##### Test data:
    - user name is case sensative
    Username: Test_a    -   Password: pass123
    Username: Test_b    -   Password: pass987
