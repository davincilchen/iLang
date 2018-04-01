# iLang

iLang where online language lessons are made easy

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
node-js
etherpad-lite
git clone https://github.com/ether/etherpad-lite.git
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
cd etherpad-lite
run bin/cleanRun.sh
rm var/dirty.db
run the server

cd iLang
rails server
```



```
change between heroku mode and local mode

in the applicatioon.html.erb
remove this line
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">

in the vendor/assets/javascripts/etherpad.js
change the setting to the local mode
```


## Authors

See also the list of [contributors](https://github.com/qscez2001/iLang/contributors) who participated in this project.
