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

## User Stories
```
身為一個在線上學/教外語的使用者
我想要與對方互動並且紀錄每次的上課筆記/教材
以便我課後整理、運用
```
```
身為一個在線上學/教外語的使用者
我可以瀏覽、搜尋與整理與不同老師/學生的上課記錄
以便我集中管理學習歷程
```
```
身為一個在線上學外語的學生
課堂結束後，我想要馬上用字卡方式複習該課堂學過的單字
以便節省我手動製作字卡的時間
```
```
身為一個在線上學外語的學生
上過的課堂累積一定量後，我想要用字卡方式綜合複習單字
以便增強我的記憶力
```
## Todos
ID|Description|Code Location|Status
---|---|---|---
1|add guided tour on homepage after user login |user#home | OPEN
2|add comment to the code where more explanations are needed | entire project | OPEN
3|add unit test|entire project|OPEN
4|review all models and add data base validation|all models|OPEN
5|adjust fake data either by modifying dev rake or manually | dev rake or manually |OPEN
6|block user from viewing lesson content that does not belong to himself, either as student or teacher | lesson#show|OPEN

## Authors
See also the list of [contributors](https://github.com/qscez2001/iLang/contributors) who participated in this project.
