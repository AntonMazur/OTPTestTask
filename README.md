# Steps to clone and launch the project:

1. Clone the repository:
  Use `git clone <this_repository_url>`
2. Open the project folder.
3. Launch file with .xcodeproj extenstion.
4. Build and run:
  Select simulator to run in Xcode and press CMD + R

# Architecture description:

The project utilizes SwiftUI with a clear separation of concerns using the MVVM+C pattern. 
Business logic resides primarily in the Use Case, while View Model is focused on UI state and data for the view. 
Navigation is managed using a Coordinator, facilitating transitions between OTP and Success screens.

