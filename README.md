# Messenger Clone
Not yet fully finished clone of popular messaging app developed by Facebook,created in SwiftUI as a learning project.
My main objective was to learn how Firebase SDK works on iOS devices and how to apply it for user authentication and data storage.

## About the project
Works as any messaging app - to some extent of course, as Firebase Spark plan has its limitations and so do i as a beginner.
Users are able to create an account, search for a specific user (only by providing fully correct first name as advanced queries are not supported by Spark plan),
set a profile picture and most important functionality - chat in real time. As noted before, Spark plan has its limitations - 
functions are not available there. That thing is worth mentioning, as this feature would work as our backend, and we would handle assigning messages to a specific user/group.
This issue in my project has been resolved in primitive way - duplication, which later are assigned to both users in conversation.

<p float="left" align="center">
  <img src="https://i.imgur.com/M1wFk0b.png" width="200">
  <img src="https://i.imgur.com/Td0vgg1.png" width="200">
  <img src="https://i.imgur.com/7M4MbHq.png" width="200">
  <img src="https://i.imgur.com/P83XQ8D.png" width="200">
</p>

## Frameworks
In terms of frameworks, I decided to stick with the first-party ones created by Apple, specifically Combine and CoreData. 
But when it comes to Firebase SDK I have chosen module in development - FirebaseCombineSwift, which provides Combine support for Firebase API's
such as FirebaseAuth, FirebaseFirestore and FirebaseStorage
