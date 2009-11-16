=====================================================================================
1.1 Flash 	--> Request --> Server(userData.php)
=====================================================================================

GET /serverside/userData.php HTTP/1.1
Host: 127.0.0.1
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/3.0.195.32 Safari/532.0
Referer: http://127.0.0.1/main.swf
Accept: */*
Accept-Encoding: gzip,deflate,sdch
Cookie: fcauth09412210533340333505=ALhR-_uSR5yki-B-OFlYX4vbkfZ67sS-noHfRlhDEUxNnZI0ZCeFP90NRJqTpENVuWq3snpCXBZWl37_Ig2rUDVx5DDa6bewmg
Accept-Language: en-GB,en-US;q=0.8,en;q=0.6
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3

=====================================================================================
1.2 Flash 	<-- Session[UserID] <-- Server
=====================================================================================

userid=ABC123456789&username=katopz

=====================================================================================
2.2 Flash 	--> MD5[DES[UserID, UserName, Time, ModelID]]	--> Server(modelData.php)
-------------------------------------------------------------------------------------
DES key : thisisakey..
Time : time=1258361936375
UserID : userid=ABC123456789
UserName : username=katopz
ModelID : code=A2A916
DES : session=0x95fd90ff5c48c534af36996bc984607b81ad77f2d07037d791c59ef842c91527530011596f667bf3d7d8d255a69d73b4c8d1e7f6ddf23729a3d1eda0d74858c6f23153daa12ccbe5
MD5 : hash=90de2ba62f138aa518d521702833d5a6
-------------------------------------------------------------------------------------
=====================================================================================

POST /serverside/modelData.php?userid=ABC123456789&username=katopz&session=0x95fd90ff5c48c534af36996bc984607b81ad77f2d07037d791c59ef842c91527530011596f667bf3d7d8d255a69d73b4c8d1e7f6ddf23729a3d1eda0d74858c6f23153daa12ccbe5&code=A2A916&hash=90de2ba62f138aa518d521702833d5a6&time=1258361936375
HTTP/1.1
Host: 127.0.0.1
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/3.0.195.32 Safari/532.0
Referer: http://127.0.0.1/main.swf,http://127.0.0.1/main.swf
Content-Length: 259
content-type: application/x-www-form-urlencoded
Accept: */*
Accept-Encoding: gzip,deflate,sdch
Cookie: fcauth09412210533340333505=ALhR-_uSR5yki-B-OFlYX4vbkfZ67sS-noHfRlhDEUxNnZI0ZCeFP90NRJqTpENVuWq3snpCXBZWl37_Ig2rUDVx5DDa6bewmg
Accept-Language: en-GB,en-US;q=0.8,en;q=0.6
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3

serverside/modelData.php?userid=ABC123456789&username=katopz&session=0x95fd90ff5c48c534af36996bc984607b81ad77f2d07037d791c59ef842c91527530011596f667bf3d7d8d255a69d73b4c8d1e7f6ddf23729a3d1eda0d74858c6f23153daa12ccbe5&code=A2A916&hash=90de2ba62f138aa518d521702833d5a6&time=1258361936375

=====================================================================================
2.3 Flash 	<-- Model[Link]	<-- Server
=====================================================================================

http://127.0.0.1/serverside/J7.dae

=====================================================================================