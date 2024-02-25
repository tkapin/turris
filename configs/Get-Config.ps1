(ssh root@turris "uci show") -replace "(username|password)='(.*)'","`$1='***'"
