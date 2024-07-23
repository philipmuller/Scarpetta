# Scarpetta

>**Scarpetta** (*italian*)  
> *n.*  
> 1. The act of mopping up leftover sauce on a plate with a piece of bread, typically performed at the end of a meal.  
> Example: "After finishing her pasta, she made a scarpetta to savor every bit of the delicious tomato sauce."  

Scarpetta is a simple, cross-platform recipe app written in Flutter. You can try it [here](https://philipmuller.github.io/Scarpetta/).

## Core features
All users:
* Viewing individual recipes
* Listing recipe categories
* Listing recipes in a given category
* Searching recipes by name

With an account:
* Creating and editing recipes
* Marking recipes as favorite
* Listing favorite recipes

## Challenges
* Having a responsive navigation layout using NavigationBar, NavigationRail and NavigationDrawer was very challenging due to the different nesting these components require. Having a single scaffold to wrap all views presented some challenges.
* Adapting the scaffold based on the contents of the page, like presenting back buttons when appropriate, was very challenging due to the difficulty getting the navigation state uri at any given time.
* Dealing with a document based database like FireStore was challenging due to no support for joining "tables".
* Using GoRouter proved very hard, forcing a rewrite of the app
* managing state and a paginated UI was very challenges, especially providing local updates

## Learning moments
* I learned about and "implemented" normalization in Firestore, which I hate with burning passion.
* I learned about extensive theming available in Material3, and implemented a full theme.
* I learned how to work with and implement the built-in search functionality in Flutter and sync it with Firestore via streaming.
* I learned how to "skin" remote data with local updates for a smooth user experience

## Database structure
Firestore database with 3 collections: categories, recipes, users.
### Category
* imageUrl (string)
* name (string)
### Recipes
* name (string)
* description (string)
* authorId (string)
* imageUrl (string)
* favouriteCount (number)
* categories (array - string/map)
* ingredients (array - map)
    * ingredient (map)
        * name (string)
        * description (string)
        * imageUrl (string)
    * quantity (number)
    * unit (map)
        * abbreviation (string)
        * name (string)
* steps (array - map)
    * description (string)
    * duration (map)
        * value (number)
        * unit (map)
            * abbreviation (string)
            * name (string)
### User
* favourites (array - string)
* recipes (array - string)

## Dependencies
* cupertino_icons: ^1.0.6
* google_fonts: ^6.2.1
* material_color_utilities: ^0.8.0
* phosphor_flutter: ^2.1.0
* uuid: ^4.4.0
* firebase_core: ^3.2.0
* cloud_firestore: ^5.1.0
* cached_network_image: ^3.3.1
* firebase_auth: ^5.1.2
* infinite_scroll_pagination: ^4.0.0
* provider: ^6.1.2