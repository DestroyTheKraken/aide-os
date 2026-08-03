# Study Questions

[Student instructions for Practice Exams](file:/home/kraken/AIDE_OS/brain/bootcamp/01_lfcs/study/instructions.md)

## Question 1

```

Solve this question on: terminal

Write the Linux Kernel release into /opt/course/1/kernel.

Write the current value of Kernel parameter ip_forward into /opt/course/1/ip_forward.

Write the system timezone into /opt/course/1/timezone.

    ℹ️ If no server is mentioned in the question text, you'll need to create your solution on the default terminal

```

---

## Question 2

```text

Solve this question on: data-001

On server data-001, user asset-manager is responsible for timed operations on existing data. Some changes and additions are necessary.

Currently there is one system-wide cronjob configured that runs every day at 8:30pm. Convert it from being a system-wide cronjob to one owned and executed by user asset-manager. This means that user should see it when running crontab -l.

    ℹ️ Create a new cronjob owned and executed by user asset-manager that runs bash /home/asset-manager/clean.sh every week on Monday and Thursday at 11:15am.

```

---
## Question 3

```text

Solve this question on: terminal

Time synchronisation configuration needs to be updated:

    Set 0.pool.ntp.org and 1.pool.ntp.org as main NTP servers
    Set ntp.ubuntu.com and 0.debian.pool.ntp.org as fallback NTP servers
    The maximum poll interval should be 1000 seconds and the connection retry 20 seconds

```

---

## Question 4

```

Solve this question on: terminal

There is an existing env variable for user candidate@terminal: VARIABLE1=random-string , defined in file .bashrc. Create a new script under /opt/course/4/script.sh which:

    Defines a new env variable VARIABLE2 with content v2, only available in the script itself
    Outputs the content of the env variable VARIABLE2
    Defines a new env variable VARIABLE3 with content ${VARIABLE1}-extended, available in the script itself and all child processes of the shell as well
    Outputs the content of the env variable VARIABLE3


```

---

## Question 5

```

Solve this question on: data-001

There is archive /imports/import001.tar.bz2 on server data-001. You're asked to create a new gzip compressed archive with its raw contents.

Store the new archive under /imports/import001.tar.gz. Compression should be the best possible, using gzip.

To make sure both archives contain the same files, write a list of their sorted contents into /imports/import001.tar.bz2_list and /imports/import001.tar.gz_list.

```

---

## Question 6

```

Solve this question on: app-srv1

On server app-srv1:

    Change the primary group of user user1 to dev and the home directory to /home/accounts/user1
    Add a new user user2 with groups dev and op, home directory /home/accounts/user2, terminal /bin/bash
    User user2 should be able to execute sudo bash /root/dangerous.sh without having to enter the root password


```

---

## Question 7

```

Solve this question on: data-002

Server data-002 is used for big data and provides internally used apis for various data operations. You're asked to implement network packet filters on interface eth0 on data-002:

    Port 5000 should be closed
    Redirect all traffic on port 6000 to local port 6001
    Port 6002 should only be accessible from IP 192.168.10.80 (server data-001)
    Block all outgoing traffic to IP 192.168.10.70 (server app-srv1)

```

---

## Question 8

```

Solve this question on: terminal

Your team selected you for this task because of your deep filesystem and disk/devices expertise. Solve the following steps to not let your team down:

    Format /dev/vdb with ext4, mount it to /mnt/backup-black and create empty file /mnt/backup-black/completed.

    Find which of the two disks, /dev/vdc or /dev/vdd, has higher storage usage.

    Then empty the .trash folder on it.

    There are two processes running: dark-matter-v1 and dark-matter-v2.

    Find the one that consumes more memory or virtual memory.

    Then unmount the disk where the process executable is located on.

```

---

## Question 9

```

Solve this question on: data-001

There is a backup folder on server data-001 at /var/backup/backup-015, it needs to be cleaned up.

First:

    Delete all files modified before 01/01/2020

Then for the remaining:

    Find all files smaller than 3KiB and move these to /var/backup/backup-015/small/
    Find all files larger than 10KiB and move these to /var/backup/backup-015/large/
    Find all files with permission 777 and move these to /var/backup/backup-015/compromised/

```

---

## Question 10

```

Solve this question on: terminal

In this task it's required to access remote filesystems over network.

On your main server terminal use SSHFS to mount directory /data-export from server app-srv1 to /app-srv1/data-export. The mount should be read-write and option allow_other should be enabled.

The NFS service has been installed on your main server terminal. Directory /nfs/share should be read-only accessible from 192.168.10.0/24. On app-srv1, mount the NFS share /nfs/share to /nfs/terminal/share.
```

---

## Question 11

```

Solve this question on: terminal

Someone overheard that you're a Containerisation Specialist, so the following should be easy for you! Please:

    Stop the Docker container named frontend_v1

    Gather information from Docker container named frontend_v2:

        Write its assigned ip address into /opt/course/11/ip-address

        It has one volume mount. Write the volume mount destination directory into /opt/course/11/mount-destination

    Start a new detached Docker container:

        Name: frontend_v3

        Image: nginx:alpine

        Memory limit: 30m (30 Megabytes)

        TCP Port map: 1234/host => 80/container

```

---

## Question 12

```

Solve this question on: terminal

You're asked to perform changes in the Git repository of the Auto-Verifier app:

    Clone repository /repositories/auto-verifier to /home/candidate/repositories/auto-verifier.

    Perform the following steps in the newly cloned directory

    Find the one of the branches dev4, dev5 and dev6 in which file config.yaml contains user_registration_level: open. Merge only that branch into branch main

    In branch main create a new directory logs on top repository level. To ensure the directory will be committed create hidden empty file .keep in it

    Commit your change with message added log directory

```

---

## Question 13

```

Solve this question on: web-srv1

There was a security alert which you need to follow up on. On server web-srv1 there are three processes: collector1, collector2, and collector3. It was alerted that any of these might run periodically the per custom policy forbidden syscall kill.

End the process and remove the executable for those where this is true.

    ℹ️ You can use strace -p PID

```

---

## Question 14

```

Solve this question on: app-srv1

On server app-srv1 there is a program /bin/output-generator which, who would've guessed, generates some output. It'll always generate the very same output for every run:

    Run it and redirect all stdout into /var/output-generator/1.out
    Run it and redirect all stderr into /var/output-generator/2.out
    Run it and redirect all stdout and stderr into /var/output-generator/3.out
    Run it and write the exit code number into /var/output-generator/4.out

```

---

## Question 15

```

Solve this question on: app-srv1

Install the text based terminal browser links2 from source on server app-srv1. The source is provided at /tools/links-2.14.tar.bz2 on that server.

Configure the installation process so that:

    The target location of the installed binary will be /usr/bin/links
    Support for ipv6 will be disabled

```

---

## Question 16

```

Solve this question on: web-srv1

Server web-srv1 is hosting two applications, one accessible on port 1111 and one on 2222. These are served using Nginx and it's not allowed to change their config. The ip of web-srv1 is 192.168.10.60.

Create a new HTTP LoadBalancer on that server which:

    Listens on port 8001 and redirects all traffic to 192.168.10.60:2222/special
    Listens on port 8000 and balances traffic between 192.168.10.60:1111 and 192.168.10.60:2222 in a Random or Round Robin fashion

Nginx is already preinstalled and is recommended to be used for the implementation. Though it's also possible to use any other technologies (like Apache or HAProxy) because only the end result will be verified.

```

---

## Question 17

```

Solve this question on: data-002

You need to perform OpenSSH server configuration changes on data-002. Users marta and cilla exist on that server and can be used for testing. Passwords are their username and shouldn't be changed. Please go ahead and:

    Disable X11Forwarding

    Disable PasswordAuthentication for everyone but user marta

    Enable Banner with file /etc/ssh/sshd-banner for users marta and cilla

    ℹ️ In case of misconfiguration you can still access the instance using sudo lxc exec data-002 bash

```

---

## Question 18

```

Solve this question on: terminal

You're required to perform changes on LVM volumes:

    Reduce the volume group vol1 by removing disk /dev/vdh from it
    Create a new volume group named vol2 which uses disk /dev/vdh
    Create a 50M logical volume named p1 for volume group vol2
    Format that new logical volume with ext4

```

---

## Question 19

```

Solve this question on: web-srv1

On server web-srv1 there are two log files that need to be worked with:

    File /var/log-collector/003/nginx.log: extract all log lines where URLs start with /app/user and that were accessed by browser identity hacker-bot/1.2. Write only those lines into /var/log-collector/003/nginx.log.extracted

    File /var/log-collector/003/server.log: replace all lines starting with container.web, ending with 24h and that have the word Running anywhere in-between with: SENSITIVE LINE REMOVED

```

---

## Question 20

```

Solve this question on: web-srv1

User Jackie caused an issue with her account on server web-srv1. She did run a program which created too many subprocesses for the server to handle. A coworker of yours already solved it temporarily and limited the number of processes user jackie can run.

For this the coworker added a command into .bashrc in the home directory of jackie. But the command just sets the soft limit and not the hard limit. Jackie's password is brown in case needed.

Configure the number-of-processes limitation as a hard limit for user jackie. Use the same number currently set as a soft limit for that user. Do it in the proper way, not via .bashrc.

On the same server you should enforce that group operators can only ever log in once at the same time, use maxlogins for this.

    ℹ️ It's not possible to test/verify the maxlogins after configuration due to how the server has been configured

```

