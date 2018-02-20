# 2Openproject Readme

This README explains how to use 2Openproject. 

Here you will find a short introduction to it.

2Openproject is a script to import Bugs/Tickets from a tool into Openproject.

## Prerequisites

If you want to use 2Openproject, you need the following things:

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

### How to clone 2Openproject repository 

Clone 2Openproject repository in your current directory:

```
$ git clone repository-url
```
Example:

```
$ git clone https://github.com/example/2Openproject.git
```

Change into the new directory:

```
$ cd new directory name
```

Example:

```
$ cd 2Openproject/
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
$ sudo gem install mysql2
```

## How to import Bugs/Tickets into openproject

Change into your 2Openproject directory:

```
$ cd directory name
```

Example:

```
$ cd 2Openproject/
```

Enter the following command with its parameters:

```
$ ./2Openproject 
--openproject-source ../../example_file
--openproject-projectid projectid
--openproject-apikey apikey
--openproject-url https://openproject-url/projects/project
--source-tool source-tool
```


### Running / Params

Example:

Bugzilla importer imports the bugs from a xml file. Export the xml file manual from bugzilla. 

```
 ./2Openproject --openproject-source ../../example_file --openproject-projectid 12121212 --openproject-apikey 3ithrfj4uihguh --openproject-url https://openproject.example.ch --source-tool bugzilla --status-id 2
```
or

OTRS importer imports ticket from the OTRS database. You need a database user with at least read permisson.

```
 ./2Openproject --openproject-projectid 12121212 --openproject-apikey 3ithrfj4uihguh --openproject-url https://openproject.example.ch --source-tool otrs --status-id 2 --version-id 312 --type-id 2 --priority-id 4 --otrs-query p25 --otrs-queue MyQueue
```

| Params | Description           |
| ------------------------------- |:-------------:|
| --openproject-source     | Path to the File you wish to import |
| --openproject-projectid     | The openproject project id you wish your issues to import in      |
| --openproject-apikey | The API key to access to your openproject (MyAccount -> on the right side)      |
| --openproject-url | URL to the openproject  |
| --source-tool | which source tool you want to use (required) | Options: bugzilla, OTRS |
| --status-id | which status id you want to use (Default = 1) |
| --version-id | which version id you want to use |
| --type-id | which type id you want to use (Default = 2) |
| --priority-id | which priority id you want to use (Default = 4) |
| --otrs-query | otrs ticket title filter|
| --otrs-queue | otrs queue name to import tickets from, e.g. --otrs-queue-name MyQueue|

Please note: version-id has no default value. If you supply a version-id that does not exists in your openproject, then the work package will not be created.

### How do I get the StatusId or ProjectId?

Go to your openproject instance https://openproject.example.ch
You have to be logged in.

Now add the following to your url in order to get a json-representation, from which you can see the corresponding ids you're interested in: 

- /api/v3/projects/YOURPROJECT     (choose the value of "identifier", not the "id" !)
- /api/v3/projects/YOURPROJECT/versions
- /api/v3/statuses
- /api/v3/priorities
- /api/v3/types


## Database credentials for OTRS

In the root directory is a file called: db_credentials.yml.template
Rename it db_credentials.yml and write your username, password, hostadress and database name to this file.

