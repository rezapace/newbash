#!/usr/bin/expect -f

set timeout -1
set host "s_01j25dadvwvbmvr1q6vmwedz8n@ssh.lightning.ai"

while {1} {
    spawn ssh -o StrictHostKeyChecking=no $host
    expect {
        "password:" {
            # Jika server meminta password, kita bisa menangani ini di sini
            send -- "your_password\r"
        }
        "$ " {
            send -- "a\r"
            expect "$ "
            send -- "exit\r"
        }
        timeout {
            puts "Connection timed out. Retrying..."
        }
        eof {
            puts "Connection closed by remote host. Retrying..."
        }
    }
    sleep 1
}
