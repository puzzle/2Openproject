# 2Redmine Readme

This README explains how to use 2Redmine. 

Here you will find a short introduction to it.

2Redmine is a Script to Import Bugs/Tickets from a tool into Redmine.

## Prerequisites

If you want to use 2Redmine, you need the following things:

-Git

-Ruby

-Bundler

## Installation

### Git

Git is a free software for distributed version management of files initiated by Linus Torvalds.

### How to install Git on Linux

```
$ sudo yum install git-all
```

or

```
$ sudo apt-get install git-all
```

### Ruby

Ruby is an object-oriented programming language

### How to install Ruby on Linux

```
$ sudo yum install ruby
```

or

```
$ sudo apt-get install ruby
```

### Bundler

Bundler provides an environment for Ruby projects by tracking and installing the gems and versions that are needed.

### How to install Bundler on Linux

```
$ gem install bundler
```

### How to clone 2Redmine repository 

Clone 2Redmine repository in your current directory:

```
$ git clone repository-url
```
Example:

```
$ git clone https://github.com/example/2Redmine.git
```

Change into the new directory:

```
$ cd new directory name
```

Example:

```
$ cd 2Redmine/
```

Execute bundle install:

```
$ bundle install
```

If an error occurs, enter the following commands:

```
$ sudo apt-get install ruby-dev
```

```
$ sudo apt-get install libmysqlcient-dev
```

```
$ sudo gem install mysql
```

## How to import Bugs/Tickets into Redmine

Change into your 2Redmine directory:

```
$ cd directory name
```

Example:

```
$ cd 2Redmine/
```

Enter the following command with its parameters:

```
$ ./2redmine 
--redmine-source ../../example_file
--redmine-projectid projectid
--redmine-apikey apikey
--redmine-url https://redmine-url/projects/project
--source-tool source-tool
```

Example:

```
$ ./2redmine 
--redmine-source /home/mmustermann/Desktop/bugzilla_bugs.xml
--redmine-projectid 1
--redmine-apikey 143b50e261187g461h1677bd4afdd260fc98tf9j
--redmine-url https://redmine-test.example.ch/projects/test
--source-tool bugzilla
```

### Running / Params

Example:

Bugzilla importer imports the bugs from a xml file. Export the xml file manual from bugzilla. 

```
 ./2redmine --redmine-source ../../example_file --redmine-projectid 12121212 --redmine-apikey 3ithrfj4uihguh --redmine-url https://redmine.example.ch --source-tool bugzilla --status-id 2
```
or

OTRS importer imports ticket from the OTRS database. You need a database user with at least read permisson.

```
 ./2redmine --redmine-source ../../example_file --redmine-projectid 12121212 --redmine-apikey 3ithrfj4uihguh --redmine-url https://redmine.example.ch --source-tool otrs --status-id 2 --otrs-query p25 --otrs-queue MyQueue
```

| Params | Description           |
| ------------------------------- |:-------------:|
| --redmine-source     | Path to the File you wish to import |
| --redmine-projectid     | The redmine project id you wish your issues to import in      |
| --redmine-apikey | The API key to access to your redmine (MyAccount -> on the right side)      |
| --redmine-url | URL to the Redmine  |
| --source-tool | which source tool you want to use (required) | Options: bugzilla, OTRS |
| --status-id | The status-id you want to set to this file export (by default is set 1)|
| --otrs-query | otrs ticket title filter|
| --otrs-queue | otrs queue name to import tickets from, e.g. --otrs-queue-name MyQueue|

### How do I get the StatusId or ProjectId?

Go on the redmine

Type in the url: 

- projects.xml

- issue_statuses.xml

Examples:

ProjectId: https://redmine.example.com/ptojects.xml

StatusId: https://redmine.example.com/issue_statuses.xml

You have to enter your password an then you see the xml file with the id's.

## Database credentials for OTRS

In the root directory is a file called: db_credentials.yml
Write your username, password, hostadress and database name to this file.
