# Movie Demo iOS App
Movie Demo is an iOS app that allows users to search for movies and add them to a favorites list. The app includes three main pages: a home page for searching movies, a movie detail page, and a favorites list page.

## Build Instructions
To run the app on your local machine, follow these steps:

1. `Clone` the repository to your local machine.
2. Open `MovieDemo.xcworkspace` in `Xcode`.
3. Select the simulator you want to run the app on from the top of Xcode.
4. Click the `play button` to build and run the app. Xcode will automatically launch the simulator.

If you want to run the app on a physical device, follow these steps:

1. `Clone` the repository to your local machine.
2. Open `MovieDemo.xcworkspace` in `Xcode`.
3. Select the `MovieDemo` target under the `Signing & Capabilities` section.
4. Select your `developer account` for the `Team` option.
5. Select your physical device from the top of Xcode.
6. Click the `play button` to build and run the app.

## App Contents
### Home Page
The home page of the app allows users to search for movies by entering keywords in the search bar. When searching for a movie, the app will automatically paginate and display the results in a table view. If the user is offline, the app will use the stored search data to display results.

### Movie Detail Page
When a user clicks on a movie in the search results table view, they are taken to the movie detail page. This page displays the title, release date, overview, and poster image of the movie. Users can add or remove movies from their favorites list from this page.

### Favorites List Page
The favorites list page displays all of the movies that the user has added to their favorites list. The movies are stored locally on the device, so users can still access their favorites list even when offline.


# Thank you for using Movie Demo!
