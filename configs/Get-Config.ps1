(ssh root@turris "uci show") -replace "^(network\.wan\.username|network\.wan\.password|wireless\.default_radio[\d]\.key)='(.*)'$","`$1='***'"
