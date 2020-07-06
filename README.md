Original App Design Project - README 
===

# ItsChoreTurn

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
* user can upload a profile picture
* user can login
* user user can logout
* users can logout
* user can create a household
* user can join a household
* user can invite a housemate
* user can create a task
    * make it one time or reoccuring daily, weekly, monthly
    * assign a housemate to a task
* user can create a task
* user can finish a task
* user can delete a task
* user can remind housemate of a task
* user can view feed of their tasks

These two stories and a system to do this would be cool and I think I'll need it if I want to add more sophisticated logic into the app thus, I am keeping it in the required section. 
* user can create a payment
* user can create a charge

**Optional Nice-to-have Stories**

* user can view balances between housemates
* users can skip tasks
* users can name/rename households
* users can view a housemates profile



### 2. Screen Archetypes

* Login Screen
    * login to account with secure credentials
* Register Screen
    * register for an account
    * upload profile picture
* Home Screen 
    * view feed of their tasks
    * user can mark task as complete 
    * user can remind housemate of a task
* Task Management Screen 
    * add new task
    * assign a housemate to a task
* Household Screen 
    * view household 
    * create household 
    * join household
    * add to household)
* Profile Screen
    * edit profile picture
    * edit name


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* home screen
* task management screen
* profile screen

**Flow Navigation** (Screen to Screen)

* login screen
    * sign up screen
    * home screen

* sign up screen
    * log in screen

* home screen
    * task management screen
    * household screen
    * profile screen
    * login screen (via a logout button)

* household screen
    * profile screen for that user
    * task management screen

* profile screen
    * task management screen



## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
