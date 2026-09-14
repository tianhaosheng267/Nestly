# Project-6-Jade-On-Wheels

Nestly is a Ruby on Rails housing application designed to connect renters with landlords.

Renters can create accounts, set housing preferences, browse rental properties, like or reject listings, save favorite properties, communicate with landlords, and request property tours.

Landlords can create accounts, post and manage rental properties, communicate with renters, and review tour requests.

The application provides different functionality depending on whether the user registers as a renter or a landlord.

## Main Features

- User registration and login
- Renter and landlord account roles
- User profile management
- Housing preferences and filters
- Property listing creation and management
- Property browsing
- Property search
- Property likes and rejections
- Favorite property management
- Property matching
- Messaging between renters and landlords
- Property tour scheduling
- Property images
- Landlord profiles
- Match notifications
- Recently viewed properties
- Map and radius search
- CRUD operations for property listings

## Technologies Used

- Ruby
- Ruby on Rails
- ERB
- HTML
- CSS
- Bootstrap
- JavaScript
- Active Record
- Devise
- SQLite
- Git
- GitHub

## Database Models

### User

The User model stores account and profile information for renters and landlords.

Information stored may include:

- Name
- Email
- Encrypted password
- Account role
- Housing preferences
- Preferred budget
- Preferred location
- Preferred lease length
- Pet requirements

A user can register as either:

- `renter`
- `landlord`

A landlord can own multiple properties. A user can also send and receive multiple messages.

### Property

The Property model stores information about rental property listings.

Information stored may include:

- Landlord ID
- Address
- Monthly rent
- Number of bedrooms
- Number of bathrooms
- Property type
- Pet policy
- Parking availability
- Amenities
- Lease length
- Availability
- Description
- Property images

Each property belongs to one landlord.

### Swipe

The Swipe model records a renter’s interaction with a property listing.

A swipe can represent actions such as:

- Like
- Pass
- Save

The Swipe model connects renters with the properties they have reviewed.

### Message

The Message model stores messages exchanged between renters and landlords.

Information stored may include:

- Sender ID
- Receiver ID
- Property ID
- Message content
- Time sent

Each message belongs to a sender and a receiver and may be associated with a specific property.

### Tour Request

The Tour Request model stores requests made by renters to visit rental properties.

Information stored may include:

- Renter ID
- Property ID
- Requested date
- Requested time
- Request status

A tour request connects a renter with a property.

### Property Picture

The Property Picture model stores pictures associated with rental properties.

Information stored may include:

- Property ID
- Image location
- Image description

Each property may have multiple pictures.

## Model Relationships

The main relationships in the application include:

- A landlord has many properties.
- A property belongs to one landlord.
- A renter has many swipes.
- A property has many swipes.
- A renter can like or reject multiple properties.
- A user can send many messages.
- A user can receive many messages.
- A property can have many messages.
- A renter can create many tour requests.
- A property can have many tour requests.
- A property can have many pictures.

Primary keys and foreign keys are used to connect the models and maintain database consistency.

## User Authentication

The application uses Devise for user authentication.

Devise provides:

- User registration
- User login
- User logout
- Password validation
- Password recovery
- Remember-me functionality

Additional fields such as `name` and `role` are permitted during user registration and account updates.

# Execution Instructions

## 1. Clone the Repository

```bash
git clone <repository-url>
```

Replace `<repository-url>` with the actual GitHub repository URL.

## 2. Navigate to the Project Directory

```bash
cd Project-6-Jade-On-Wheels
```

## 3. Install the Required Gems

```bash
bundle install
```

## 4. Create the Database

```bash
bin/rails db:create
```

## 5. Run the Database Migrations

```bash
bin/rails db:migrate
```

## 6. Load the Seed Data

```bash
bin/rails db:seed
```

## 7. Start the Rails Server

```bash
bin/rails server
```

## 8. Open the Application

Open a browser and navigate to:

```text
http://localhost:3000
```
## 8. Open the Reset Letter Web

```text
http://127.0.0.1:3000/letter_opener
```

# Managers

## Overall Project Manager

Urja Chauhan

## Meeting Manager

Tianhao Sheng

# Use Cases

## Sampurna Sarkar

### Use Case 1: Finding Housing Preferences

A renter can create an account, set housing preferences such as budget and location, and browse personalized listings by swiping left to pass or right to like. Properties the renter likes are automatically saved to the Favorites page.

### Use Case 2: Contacting a Landlord

After saving a property, the renter can view the listing details and send a message to the landlord with questions or to request a tour.

### Use Case 3: Posting a Property

A landlord can log in to a landlord account and create a new property listing by entering details such as rent, location, photos, and amenities. The landlord can publish the listing so renters whose preferences match the property can discover it through the Swipes page.

## Ania Liulka

### Use Case 4: Filtering Properties

A user can filter housing listings by different attributes, such as whether the property allows pets, includes parking, or is a house or apartment.

### Use Case 5: Sharing a Property Listing

A user can share a property listing with roommates by clicking the Share button and selecting a sharing method.

### Use Case 6: Scheduling a Tour

A user can schedule a property tour without directly contacting the landlord by selecting a desired date from a calendar. The calendar is updated according to the landlord’s availability.

## Tianhao Sheng

### Use Case 7: Creating and Managing a User Profile

A new user can create an account by entering a name, email address, password, and account role. A renter can add housing preferences such as budget, preferred location, lease length, and pet requirements. The user can later update this information through the profile page.

### Use Case 8: Saving and Comparing Favorite Properties

When a renter finds an interesting property, the renter can save it to the Favorites page. The renter can view saved properties together and compare information such as rent, location, number of bedrooms, amenities, pet policies, and lease length. A property can also be removed from Favorites when the renter is no longer interested.

### Use Case 9: Managing an Existing Property Listing

A landlord can open the management dashboard to view all properties they have posted. The landlord can update information such as rent, availability, description, amenities, and property photos. The landlord can also remove a listing when the property is no longer available.

## Urja Chauhan

### Use Case 10: Saving Favorite Listings

When a renter swipes right on a property they are interested in, the listing is automatically added to the Favorites page.

### Use Case 11: Viewing Landlord Profiles

A renter can open a property listing and view the landlord’s profile to see all available properties managed by that landlord and view the landlord’s rating.

### Use Case 12: Editing a Property Listing

A landlord can update an existing property listing to reflect changes such as a new rent amount, updated photos, or updated amenities.

## Michael Ta

### Use Case 13: Receiving a Match Notification

When a renter is interested in a property and the landlord accepts the renter’s request, the application displays a match notification.

### Use Case 14: Searching by Map and Radius

A renter can enter a preferred location and adjust the search radius to find housing within the desired area.

### Use Case 15: Viewing Recently Viewed Listings

A renter can access a Recently Viewed section to revisit properties they previously viewed but did not save.

# Meeting Reports

## Meeting #1 — 7/19/2026

### Attendance

All team members were present.

### Meeting Overview

#### General

- Discussed the stand-up and meeting schedule for the upcoming week.
- Agreed on the time for the next stand-up meeting.
- Scheduled the next full team meeting.
- Planned a short Saturday morning check-in meeting.

### Meeting Schedule

- Quick Meeting: Saturday morning, time to be determined
- Team Meeting: Thursday, 7/23/2026, at 6:00 PM online after class
- Stand-up Meeting: Sunday, 7/26/2026, at 11:30 AM

### Project-Specific Discussion

- Discussed and determined the primary use cases for the project.
- Reviewed the main system requirements.
- Agreed that Sprint #1 would focus on creating the database tables and implementing the corresponding models.
- Assigned one database table and model to each team member.

### Project Requirements Discussed

- User registration and login system
- Messaging between renters and landlords
- Matching renters with suitable properties
- Viewing property listings
- Updating property listings
- Adding new rental properties
- Viewing matched properties
- Viewing liked properties
- Liking properties
- Rejecting properties
- Different functionality for renters and landlords
- Changing housing filters
- CRUD operations for property listings
- Property tour scheduling
- Property images

### Sprint #1 Assignments

- Tianhao Sheng — User table and model
- Ania Liulka — Property table and model
- Sampurna Sarkar — Swipe table and model
- Michael Ta — Message table and model
- Urja Chauhan — Tour Request table and model

## Meeting #2 — 7/23/2026

### Attendance

All team members were present.

### Meeting Schedule

- Quick Meeting: Sunday, 7/26/2026, at 4:30 PM
- Stand-up Meeting: Sunday, 7/26/2026, at 5:00 PM

### Meeting Overview

- Reviewed the database tables and models completed during Sprint #1.
- Discussed required updates to table attributes.
- Reviewed primary keys and foreign keys.
- Reviewed model relationships.
- Planned the main application routes.
- Discussed the required controllers and controller actions.
- Identified the views required for the application.
- Assigned routes, views, and functionality to each team member.
- Agreed to prepare a functional application for the Wednesday presentation.

### Pages Discussed

- Swipe page
- Login page
- Registration page
- Messages page
- Tour scheduling page
- Favorites page
- Account details page
- Property listings page
- Property details page
- New property page

### Sprint #2 Assignments

#### Tianhao Sheng

- Define Ruby on Rails routes for User-related functionality.
- Add Devise authentication to the User model.
- Create the login page.
- Create the registration page.
- Add Bootstrap styling to the login and registration pages.
- Implement User-related functionality.

#### Ania Liulka

- Define Ruby on Rails routes for Property-related functionality.
- Create the new property page with Bootstrap.
- Add seed data for users and properties.
- Implement Property-related functionality.

#### Sampurna Sarkar

- Define Ruby on Rails routes for Swipe-related functionality.
- Create the Swipe page with Bootstrap.
- Implement Swipe-related functionality.

#### Michael Ta

- Define Ruby on Rails routes for Message-related functionality.
- Create the Messages page with Bootstrap.
- Implement Message-related functionality.

#### Urja Chauhan

- Define Ruby on Rails routes for Tour Request-related functionality.
- Create the Tour Request page with Bootstrap.
- Add support for property pictures.
- Implement Tour Request-related functionality.

# Meeting #3 — 7/26/2026

## Attendance

All team members were present.

## Goal

Improve and complete the main application features by fixing the Favorites functionality, maintaining consistent background styling across pages, and completing the Tour Request functionality.

The team also planned to improve the connections between pages, complete account and property management features, enhance the Swipe page, and add message and property filtering functionality.

## Meeting Overview

### General

- Reviewed the current progress of the main application features.
- Discussed issues with the Favorites functionality.
- Agreed to maintain consistent background styling across all application pages.
- Discussed completing the Tour Request functionality for both renters and landlords.
- Planned improvements to the connections between different application pages.
- Discussed completing the account details and property management features.
- Planned improvements to the layout and functionality of the Swipe page.
- Discussed adding property filtering and unread message functionality.
- Agreed to review different font options for the application.
- Planned the content and design of the presentation slides.

## Sprint #3 Assignments

### Tianhao Sheng

- Create the Account Details page.
- Confirm that Devise authentication works correctly.
- Verify that the password reset functionality works correctly.

### Ania Liulka

- Create the My Properties page.
- Implement functionality for adding properties.
- Implement functionality for editing properties.
- Implement functionality for removing properties.
- Add support for property pictures.

### Sampurna Sarkar

- Reduce the size of the Swipe page content and property cards.
- Improve how account details are displayed in a pop-up.
- Display different property pictures on the Swipe page.
- Connect property pictures to the correct property listings.
- Help design the presentation slides.

### Michael Ta

- Add property filtering functionality to the Swipe page.
- Add support for displaying unread messages.

### Urja Chauhan

- Improve the connections between separate application pages.
- Implement a more complete Tour Request workflow.
- Add landlord-side Tour Request functionality.

### All Team Members

- Review and select appropriate fonts for the application.
- Work on the presentation slides.

## Sprint Deadline

- Sprint #3 Ending: Tuesday, 7/28/2026, at night

## Meeting Schedule

- Monday after class, in person: Review Sprint #3 progress and begin working on the presentation slides.
- Wednesday after class, in person: Explain the slides and complete a full practice run.
- Thursday at 12:00 PM: Presentation practice.

# Meeting #4 — 7/27/2026

## Attendance

All team members were present.

## Goal

Simplify the account system, improve the navigation bar, and continue completing the individual Sprint #3 tasks.

## Meeting Overview

### General

- Agreed that each team member would continue working on their assigned Sprint #3 tasks.
- Reviewed the current progress of the main application features.

### Account System

- Agreed to combine renter and landlord permissions into one general user account.
- Removed the requirement for users to select an account type during registration.
- Continued using model associations to connect users with properties, messages, and tour requests.
- Discussed updating the existing account functionality to support the simplified account system.

### Navigation Bar

- Agreed to change the navigation bar to green to match the application’s updated color palette.
- Moved the Messages link into the hamburger menu.
- Added a dedicated My Properties tab.
- Agreed to display the hamburger menu on both small and large screens.
- Kept the signed-in user’s name visible next to the hamburger menu.

## Next Steps

- Complete the updated account functionality.
- Continue implementing the assigned Sprint #3 features.
- Verify that all navigation links connect to the correct pages.
- Test the hamburger menu on different screen sizes.
- Maintain consistent styling across all application pages.

# Team Member Contributions

## Tianhao Sheng

Implemented the user authentication portion of the application using the Devise gem. I configured the existing User model to support user registration, login, logout, password recovery, remember-me functionality, and email/password validation. I also updated the database through a migration that added the Devise-required fields, including encrypted_password, reset_password_token, reset_password_sent_at, and remember_created_at. 

Created and customized the login and registration pages using ERB and Bootstrap. The registration page allows users to enter their name, email, password, password confirmation, and account type. Users can register as either a renter or a landlord. The login page contains email and password fields, a remember-me option, and a link to the password reset page. 

Updated the application layout by adding a responsive Bootstrap navigation bar. The navigation bar displays login and registration buttons when the user is not signed in. After the user signs in, it displays the user’s name and a logout button. I also added Bootstrap success and error messages for authentication results. 

Added authentication protection in ApplicationController, so users who are not signed in are redirected to the login page before accessing the main application. After a successful login, the user is redirected to the properties index page. I also added sample renter and landlord accounts to db/seeds.rb for development and testing. 

The registration, login, logout, authentication redirect, account-role selection, and test-account features are currently functional. The password-reset page and database fields are available, but email delivery still needs to be fully configured and tested. 

Created and customized the Account Details page to display the signed-in user’s personal information, including their name and email address. The page retrieves the correct information from the currently authenticated user and provides access to account-related actions. I also connected the page to the navigation bar and protected it with Devise authentication so that only signed-in users can view their account details.

## Ania Liulka

Implemented model for Property class, its routes, PropertiesController class, views for new, show and index property pages and styling for them.  

Index in the Property Class is used to create a view of all property listings created by the landlord. The show method renders an individual page with details, as well as the buttons “Edit” and “Remove” to edit and remove the listing accordingly (functionality not implemented yet). New methods will redirect the user to the empty form and create method will create a new property that will be added to the table "properties". 

## Sampurna Sarkar

Implemented the swipe portion of the application, which records renter reactions to property listings. Created the swipes table through a migration with user_id, property_id, and direction columns. Added a foreign key to the properties table and a unique index on user_id and property_id so a user cannot swipe the same property twice.  

Created the Swipe model with a belongs_to association to Property, a validation that direction must be "like" or "pass", and a uniqueness validation that prevents duplicate swipes. 

Created the swipe deck page, which shows one property at a time that the user has not swiped on yet, with pass and like buttons. Created the likes page, which shows all liked properties as Bootstrap cards. Double-clicking a card removes the like, and that property returns to the swipe deck. Styled both pages with a full-screen layout, theme, and bottom navigation bar with SVG icons for home, likes, and messages. The controller currently uses a DEMO_USER_ID constant as a placeholder until it is switched to Devise's current_user.

## Michael Ta

Implemented the messaging feature of the application. Created the Message model with Active Record associations for the messages to have relationships with the users that will send and receive the messages, as well as the property that the messages will relate to. Added validations to the model to ensure that users cannot send messages to themselves. 

Created the MessagesController to handle the messaging functionality of the application. Implemented actions to retrieve every message conversation that the currently logged in user has participated in, as well as to group those messages by both the property and the other conversation participant. Implemented actions to load a conversation between two users and to ensure that only users that are authorized to access those conversations can actually view them. Implemented actions to create new messages for users to send, automatically assigning the sender of the message to the currently logged in user, and then redirecting the user to the message conversation that was created. 

Created the views that will display the conversations between users. Created a list of message conversations for the user that will display the other conversation participant, the property, and the most recent message in each conversation. Created the individual conversations between two users that will display all of the messages in chronological order with different message styles for messages that were sent as opposed to received by the current user. Created the message form that automatically scrolls to the newest message after the conversation is loaded. 

The messaging feature of the application is currently functional. Current users are able to send and receive messages to other users within the same property. Conversations are grouped correctly by property and conversation participant. Only users authorized to read a conversation are able to view the conversation. Invalid messages are prevented from being stored in the database via model validations. 

## Urja Chauhan

Implemented the complete Tour Request feature, allowing renters to request property tours directly from a property’s details page. Added the TourRequest model with validations, created the TourRequestsController with index, new, and create actions, developed the tour request form and index pages, integrated the feature into the property show page with a Request Tour button, and added Bootstrap success notifications after successful submissions. 

# Sprint #1

## Duration

7/19/2026 – 7/23/2026

## Goal

Create the initial database structure and implement the models required for the housing application.

## Deliverables

- Create the required database tables.
- Implement a model for each table.
- Define the appropriate attributes for each model.
- Establish relationships between the models.
- Add primary keys where necessary.
- Add foreign keys where necessary.
- Add model validations where necessary.
- Test that the models work correctly.
- Test that the database relationships work correctly.

## Assignments

### Tianhao Sheng — User Table

Responsibilities:

- Create the User table.
- Store the user’s name.
- Store the user’s email.
- Store the encrypted password.
- Store the user’s account role.
- Store housing preferences.
- Define renter and landlord roles.
- Add User model validations.
- Implement User model relationships.

### Ania Liulka — Property Table

Responsibilities:

- Create the Property table.
- Store rental property information.
- Store the property address.
- Store the monthly rent.
- Store the number of bedrooms.
- Store the property amenities.
- Store landlord information.
- Connect each property to a landlord.
- Implement Property model relationships.

### Sampurna Sarkar — Swipe Table

Responsibilities:

- Create the Swipe table.
- Record renter interactions with properties.
- Store liked property actions.
- Store rejected property actions.
- Store saved property actions.
- Connect renters with properties.
- Implement Swipe model relationships.

### Michael Ta — Message Table

Responsibilities:

- Create the Message table.
- Store the sender ID.
- Store the receiver ID.
- Store the related property ID.
- Store the message content.
- Store the time sent.
- Implement Message model relationships.

### Urja Chauhan — Tour Request Table

Responsibilities:

- Create the Tour Request table.
- Store the renter ID.
- Store the property ID.
- Store the requested date and time.
- Store the request status.
- Connect renters with properties.
- Implement Tour Request model relationships.

# Sprint #2

## Duration

7/23/2026 – 7/29/2026

## Goal

Review and improve the existing database tables and models, then implement the routes, controllers, and views needed to connect the database with the user interface.

The team will prepare a stable and functional version of the main application features for the Wednesday presentation.

## Deliverables

- Review all database tables.
- Ensure each table meets the project requirements.
- Fix or update table attributes where necessary.
- Verify primary keys.
- Verify foreign keys.
- Review model relationships.
- Add or update model validations.
- Define the required routes.
- Implement the corresponding controller actions.
- Create the initial application views.
- Connect the views to the controllers.
- Connect the controllers to the database models.
- Test routes and pages.
- Test database create operations.
- Test database read operations.
- Test database update operations.
- Test database delete operations.
- Prepare a stable version for the presentation.

## Planned Views

- Login page
- Registration page
- Account details page
- Property listings page
- Property details page
- New property page
- Swipe page
- Favorites page
- Matched properties page
- Messages page
- Tour Request page
- Tour scheduling page

## Assignments

### Tianhao Sheng

Responsibilities:

- Define Ruby on Rails routes for User-related functionality.
- Add Devise to the User model.
- Add Devise database fields.
- Create the login view.
- Create the registration view.
- Permit the `name` and `role` parameters.
- Add Bootstrap styling to the authentication pages.
- Add login and registration links to the navigation bar.
- Add logout functionality.
- Add authentication checks.
- Continue implementing User-related functionality.

### Ania Liulka

Responsibilities:

- Define Ruby on Rails routes for Property-related functionality.
- Create the new Property view.
- Add Bootstrap styling to the Property view.
- Create seed data for users.
- Create seed data for properties.
- Continue implementing Property-related functionality.

### Sampurna Sarkar

Responsibilities:

- Define Ruby on Rails routes for Swipe-related functionality.
- Create the Swipe page.
- Add Bootstrap styling to the Swipe page.
- Continue implementing Swipe-related functionality.

### Michael Ta

Responsibilities:

- Define Ruby on Rails routes for Message-related functionality.
- Create the Messages page.
- Add Bootstrap styling to the Messages page.
- Continue implementing Message-related functionality.

### Urja Chauhan

Responsibilities:

- Define Ruby on Rails routes for Tour Request-related functionality.
- Create the Tour Request page.
- Add Bootstrap styling to the Tour Request page.
- Add the Property Picture table.
- Connect pictures with properties.
- Continue implementing Tour Request-related functionality.

# Sprint #3

## Duration

7/26/2026 – 7/29/2026

## Goal

Improve and complete the main application features by fixing the Favorites functionality, maintaining consistent background styling across pages, and completing the Tour Request functionality.

The team will also improve the connections between pages, complete account and property management features, enhance the Swipe page, and add message and property filtering functionality.

## Deliverables

- Fix and improve the Favorites functionality.
- Maintain consistent background styling across the application.
- Complete the Tour Request functionality.
- Create the Account Details page.
- Confirm that Devise authentication works correctly.
- Confirm that password reset functionality works correctly.
- Create the My Properties page for landlords.
- Allow landlords to add and edit property listings.
- Allow landlords to add pictures to properties.
- Improve the size and layout of the Swipe page.
- Display different property pictures on the Swipe page.
- Connect property pictures with the corresponding properties.
- Display account details from the Swipe page.
- Add property filters to the Swipe page.
- Add unread message indicators.
- Improve navigation and connections between separate pages.
- Test the updated application features.

## Planned Improvements

- Favorites page functionality
- Consistent page background styling
- Account Details page
- Devise authentication
- Password reset functionality
- My Properties page
- Property creation and editing
- Property picture management
- Improved Swipe page layout
- Property filters
- Unread message indicators
- Improved Tour Request workflow
- Improved navigation between pages

## Assignments

### Tianhao Sheng

Responsibilities:

- Create the Account Details page.
- Display the current user's account information.
- Confirm that Devise authentication works correctly.
- Test user login and registration functionality.
- Confirm that the password reset functionality works correctly.
- Fix User-related issues where necessary.

### Ania Liulka

Responsibilities:

- Create the My Properties page.
- Display the properties owned by the current landlord.
- Allow landlords to add new property listings.
- Allow landlords to edit existing property listings.
- Add property pictures.
- Connect property pictures with the corresponding properties.

### Sampurna Sarkar

Responsibilities:

- Make the Swipe page display smaller and improve its layout.
- Determine how account details should appear from the Swipe page.
- Display different property pictures for different Swipe listings.
- Connect property pictures with the corresponding properties.
- Improve the overall Swipe page functionality.

### Michael Ta

Responsibilities:

- Add property filtering functionality to the Swipe page.
- Allow users to filter the properties displayed in Swipes.
- Add unread message indicators.
- Improve Message-related functionality where necessary.

### Urja Chauhan

Responsibilities:

- Improve the connections and navigation between separate application pages.
- Complete and improve the full Tour Request workflow.
- Improve the landlord side of the Tour Request functionality.
- Test Tour Request creation, display, and status updates.
