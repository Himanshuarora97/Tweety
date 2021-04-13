# Tweety
Twitter clone with Firebase Firestore. with functionality like add, edit and delete tweet with realtime update.

## Features

- Type in a tweet with 280 characters limit
- Save this along with the current time into Firestore
- View a list of all tweets, sorted by most recent date
- The app update in realtime when the data changes on Firestore.
- Login and Signup using Firebase Authentication
- Edit and Delete tweet with realtime update

## Project Flow

1. User can login using credentials otherwise go for **Sign up**.
2. After authenticate, user navigated to the **home feed page** where all tweets are listed in sort by recent time order.
3. User can click on the bottom right button to add **Tweet** where there's limit to the tweet (280 characters), as the user typing circular progress start filling (first **white** color, after 90% of characters turn into **Yellow**, if limit exceeds tweet limit then **red** color)
4. After clicking on the tweet button bird sound is being played (from  **Resources/Sounds/birds.mp3**)
5. On the home feed page, if a user own that tweeet (currently checked with Logged in user email to tweet user email), then can delete and edit the tweet).

## Demo
- Signup flow
[![Tweety Signup](http://i3.ytimg.com/vi/_NHXSPhdiI8/maxresdefault.jpg)](https://youtu.be/_NHXSPhdiI8 "Tweety Signup")
- App flow
[![Tweety app flow](http://i3.ytimg.com/vi/CNKSY4-JunA/maxresdefault.jpg)](https://youtu.be/CNKSY4-JunA "Tweety app flow")

## Pods

Tweety is currently using the following pods.

| Plugin | Use |
| ------ | ------ |
| [Firebase/Firestore][firestore] | To store data and get realtime update |
| [FirebaseFirestore][firestore/dev] | Precompiled version of above pod, not use the above version for development as it takes too much time to build. |
| [Firebase/Auth][fireAuth] | To authenticate user and create user during signup |
| [FirebaseFirestoreSwift][firestoreSwift] | To use Codable protocol with Firebase functions with Document Id mapping |
| [SuperStackView][superStackView] | Feature rich version of UIStackView (created by me) |
| [Toast-Swift][Toast-swift] | For displaying Toast message like in Android for Error messages |
| [SDWebImage][SDWebImage] | Image caching library for displaying user profile avatar/dp |


   [firestore]: <https://cocoapods.org/pods/FirebaseFirestore>
   [firestore/dev]: <https://github.com/invertase/firestore-ios-sdk-frameworks>
   [fireAuth]: <https://cocoapods.org/pods/FirebaseAuth>
   [firestoreSwift]: <https://cocoapods.org/pods/FirebaseFirestoreSwift>
   [superStackView]: <https://github.com/Himanshuarora97/SuperStackView>
   [Toast-swift]: <https://github.com/scalessec/Toast-Swift>
   [SDWebImage]: <https://github.com/SDWebImage/SDWebImage>