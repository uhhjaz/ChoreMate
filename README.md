Original App Design Project - README 
===

# ChoreMate

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
ChoreMate allows for the equal distribution and cycling of household chores
between residents, ensures chores and payments are completed on time through a timedeadline sorted task feed and notification system.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Lifestyle/Productivity
- **Mobile:** Real-time use and reminders of deadlines. Ability to have this in hand whereever you go.
- **Story:** Housing with people is a delicate situation and many times you end up with housemates who do not equally complete house work. With busy schedules, it is also difficult to sometimes complete taks and easy to forget to do them. Choremate serves as that link between housemates to remind themselves and each other of deadlines, payments, etc.  
- **Market:** I have not seen many apps like this. Normally conversations like "Remember to take out the trash" are done in person or through text, but constant reminders can be seem as irritating to some people. So choremates is platform solely for these interations. Venmo doeshave things like app reminders, and charges. 
- **Habit:** Average user might open this app every couple of days to mark off that they have completed a task.
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* user can register for an account
* user can login to account
* user can login with fb authentication
* user can persistently stay logged unless user manually logs out
* user can upload profile picture
* user can view feed of their tasks
* user can view housemates tasks
* user can mark task as complete 
* user can remind housemate of a task
* user can create new one time task
* user can create a new rotational task
* user can create a new reoccuring task
* user can delete tasks
* user can view household 
* user can create household 
* user can join household
* user can securely logout 




**Optional Nice-to-have Stories**
* user can update their profile picture
* user can invite another user to household
* user can update tasks
* user can skip tasks ( user can mark off unavailability dates )
* user can name/rename households
* user can edit their name
* user can view a housemates profile
* user can create a payment
* user can create a charge




### 2. Screen Archetypes

* Login Screen
    * user can login to account
    * user can login with fb 
    * user can persistently stay logged unless they manually logout
* Register Screen
    * user can register for an account
    * user can register with fb
        * https://developers.facebook.com/docs/ios/use-facebook-login
    * user can upload profile picture
* Task View Screen [home] 
    * user can view feed of their tasks
    * user can view housemates tasks
    * user can mark task as complete 
    * user can remind housemate of a task
* Task Adding Screen 
    * user can create new one time task
    * user can create a new rotational task
    * user can create a new reoccuring task
* Household Screen 
    * user can view household 
    * user can create household 
    * user can join household
        * https://developers.facebook.com/docs/graph-api/reference/user/friends/
* Profile Screen
    * user can securely logout 
    * user can edit their name

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* task view screen [home]
* profile screen
* household screen

**Flow Navigation** (Screen to Screen)

* login screen
    * sign up screen
    * task view screen [home]

* sign up screen
    * log in screen

* task view screen [home]
    * task creation screen 
    * household screen
    * profile screen

* task creation screen 
    * task view screen [home]

* household screen
    * profile screen for that user
    * task view screen [home]

* profile screen
    * task view screen [home]
    * login screen (via a logout button)



## Wireframes

<img src="https://github.com/uhhjaz/fbu_final_project/blob/master/AppWireframes.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models



#### User Model
| Property  |  Type | Description |
|---|---|---|
|  name | String  | the name of the user  |
| username  | String  | the users chosen username  |
|  email |  String | the users inputted email  |
| password  | String | the users chosen password  |
| profile_image |File | profile image chosen by user |
|  in_household |  String | the uniqueID representing the household the user is in |
|busy_dates| Array<NSDates> |Dates the user has marked being unavailable|



#### Household Model
| Property  |  Type | Description |
|---|---|---|
| household_id | String | unique ID to represent this Household |
|  name | String  | the the chosen name of the household  |
| created_at | DateTime | the date when the household was created |




#### Task Model
| Property  |  Type | Description |
|---|---|---|
|  type | String  | the type of task: rotational,reoccuring,one_time  |
| task_id | String | unique ID to represent this Task |
| description |  String | the description of the task to complete |
| assigned_to  | Array<User> | the users assigned to the task  |
|  created_at | DateTime  |  date when the task is created (default field) |
| due_date | DateTime| user selected date to complete the task by |
| status | Boolean | whether task has been completed or not |
| repeats | String | How this task repeats:  daily,weekly,monthly | 
| start_date | DateTime | the starting date of task repeatability |
| end_date | DateTime | the ending date of task repeatability |
| rotational_order|Array<User> | the order the task rotates and gets assigned to a new user on a daily, weekly, monthly basis |




### Networking
* Login Screen
* Register Screen
* Task View Screen [home] 
* Task Adding Screen 
* Household Screen 
* Profile Screen



- [OPTIONAL: List endpoints if using existing API such as Yelp]
