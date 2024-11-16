#!/usr/bin/expect

set timeout 20
set host "47.237.8.229"
set user "root"
set password "cum@L(2020)"

spawn ssh -o StrictHostKeyChecking=no $user@$host
expect "password:"
send "$password\r"
interact
