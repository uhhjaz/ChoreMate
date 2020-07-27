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
* user can register for an account (DONE)
* user can login to account (DONE)
* user can login with FB authentication (DONE)
* user can persistently stay logged unless user manually logs out (DONE)
* user can logout (DONE) 
* user can upload profile picture (DONE)
* user can view feed of their onetime tasks (DONE)
* user can view feed of their recurring tasks (DONE)
* user can mark task as complete (DONE)
* user can delete tasks (DONE)
* user can create new one time task (DONE)
* user can create a new rotational task (DONE)
* user can create a new rotational task (DONE)
* user can create a new reoccuring task (IP)
* user can view household (IP)
* user can create household (IP)
* user can join household (IP)
* user can view housemates tasks (IP)
* user can remind housemate of a task (IP)




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

* one time task creation screen 
    * task view screen [home]

* recurring task creation screen 
    * task view screen [home]

* rotational task creation screen 
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
|  objectId | String  | the unique Id of the object  |
|  name | String  | the name of the user  |
| username | String  | the users chosen username  |
|  email |  String | the users inputted email  |
| password  | String | the users chosen password  |
| profile_image | File | profile image chosen by user |
| household_Id |  String | the uniqueID representing the household the user is in |


#### Household Model
| Property  |  Type | Description |
|---|---|---|
| household_id | String | unique ID to represent this Household |
|  name | String  | the the chosen name of the household  |
| created_at | DateTime | the date when the household was created |


#### Task Model
| Property  |  Type | Description |
|---|---|---|
| objectId | String | unique ID to represent this Task |
|  type | String  | the type of task: rotational,reccuring,one_time  |
| dueDate | DateTime| user selected date to complete the task by |
| taskDescription |  String | the description of the task to complete |
| assignedTo  | Array<UserId> | iDs of the users assigned to the task  |
| completed  | PFRelation | information about the completion progress of the task |
| createdAt | DateTime  |  date when the task is created (default field) |
| repeats | String | How this task repeats:  daily,weekly,monthly | 
| occurrences | Number | how many times the task repeats |
| repeats | String | How this task repeats:  daily,weekly,monthly | 
| repetitionPoint | Number | the moment in the day, week, month that the task repeats |
| rotational_order|Array<User> | the order the task rotates and gets assigned to a new user on a daily, weekly, monthly basis |


#### Completed Model
| Property  |  Type | Description |
|---|---|---|
| objectId | String | unique ID to represent the properties of this Completed task|
|  task | Task  | the Task this completion belongs to |
| endDate | DateTime | the date to complete this task by |
| currentCompletionStatus | Array<UserId> | userIds of the household members who have already completed the task |
| assignedTo  | Array<UserId> | iDs of the users assigned to the task  |
| isCompleted  | Boolean | whether this task is fully completed or not |


### Networking
* Login Screen
* Register Screen
* Task View Screen [home] 
* Task Adding Screen 
* Household Screen 
* Profile Screen


