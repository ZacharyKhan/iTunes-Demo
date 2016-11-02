# iTunes-Demo
A basic, quick app that communicates with Apple's iTunes API to show Top 40 songs in multiple genres and allows searching for artists and indevidual tracks with autocomplete. 

# Requirements
- Swift 3.0
- Xcode 8+

# Instructions
1. Download or Clone the project
2. Run the project in Xcode

# Notes
- Swift 3.0
- Written without the use of Storyboards.
- The app will sometimes fail to load data in search and parts of top lists due to apple limiting their iTunes Search API if large amounts of requests are made (1k-2k).
- The UI/UX is fairly basic as my limited time was spent on making the code as stable and clean as possible.
- Images may change while scrolling, depending on the user's network speed, due to the fact that none of the images are cached. They are being loaded asynchronously while the user is scrolling.  
