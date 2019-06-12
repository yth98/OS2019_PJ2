# 2019 OS Project 2 - Synchronous Virtual Device
> http://rswiki.csie.org/dokuwiki/courses:107_2:project_2

## 設計 Program Design

### Design

Here we emphasize the implementation of memory-mapped I/O.

Master side

- master_device.c
    1. If notified by the user_program, find the input file in memory.
    1. Send the input file to slave device via ksend.

- master.c
    1. Map the input file to the memory of user_program and then map the memory of device to user_program.
    1. Copy the input file to the mapped memory via memcpy, and then notify that device mapping is finished via ioctl.


Slave side

- slave_device.c
    1. Receive the file in memory from master device.
    1. Copy the memory data to the buffer via memcpy.
    1. Generate a socket and wait the connection from slave.c to be done.

- slave.c
    1. Make connection to slave device and fetch the file.
    1. Map the memory of device to user_program and then map the data to the output file.


### How to Run

    sudo ./compile.sh 
    sudo ./run_fcntl.sh
    sudo ./run_mmap.sh
    sudo ./clean.sh

run_fcntl and run_mmap will access the master program to read the four .in files and access the slave program to write them to the four .out files sequencially by the method of fcntl or mmap respectively, which is quite convenient to collect all result at once.


## 執行結果 The Result
### fcntl
```
Log of Master:
Transmission time: 0.020400 ms, File size: 32 bytes
Transmission time: 0.025400 ms, File size: 4619 bytes
Transmission time: 0.679000 ms, File size: 77566 bytes
Transmission time: 17.698100 ms, File size: 12022885 bytes

Log of Slave:
Transmission time: 0.111300 ms, File size: 32 bytes
Transmission time: 0.433400 ms, File size: 4619 bytes
Transmission time: 0.849600 ms, File size: 77566 bytes
Transmission time: 25.740900 ms, File size: 12022885 bytes
```

### mmap
```
Log of Master:
Transmission time: 0.020700 ms, File size: 32 bytes
[  763.441686] [PJ2] master: 8000000058600267
Transmission time: 0.020500 ms, File size: 4619 bytes
[  763.455095] [PJ2] master: 8000000058680267
Transmission time: 0.027200 ms, File size: 77566 bytes
[  763.466013] [PJ2] master: 8000000058680267
Transmission time: 3.385400 ms, File size: 12022885 bytes
[  763.467215] [PJ2] master: 8000000058680267

Log of Slave:
Transmission time: 0.599400 ms, File size: 32 bytes
[  763.443435] [PJ2] slave: 8000000058680225
Transmission time: 0.445400 ms, File size: 4619 bytes
[  763.457700] [PJ2] slave: 8000000058600225
Transmission time: 0.798800 ms, File size: 77566 bytes
[  763.472651] [PJ2] slave: 8000000058600225
Transmission time: 7.393000 ms, File size: 12022885 bytes
[  763.475611] [PJ2] slave: 8000000058600225
```

## 效能比較 Performance Comparison

### Comparison between fnctl and mmap
It can be seen that when the file size gets larger, using mmap would be a lot faster. 

We have known that primitive I/O have an extra cost on coping files from page cache to the target address, while memory-mapped I/O is able to directly access the file from the page cache by the map. However, mmap has a large overhead on setup/tear down overhead and page fault compared to fnctl. So when the file size is large enough for the cost of coping in fnctl to bypass the cost of overhead in mmap, memory-mapped I/O tends to work better.

Note that primitive I/O usually doesn't suffer from page fault, while memory-mapped I/O does. So, say, if we need to access ramdom parts of the file frequently, mmap might waste a lot of time on the overhead. This is not the case here since we only need to access the file once from start to end.

### Miscellaneous
Theoretically in file1 primitive I/O would do better since memory-mapped I/O spend time seting up/tearing down. But there is little difference in the result. 

In fact, the transmission time in file1 and file2 varies in a range every time we run it. Even two different machine would get a quite different result. This might be due to some scheduling issue when CPU deals with the program.




## 組員貢獻 Contributions

- B04201020： Collect results, debugging

- B04201021： Write report.md, debugging

- B04201043： Collect results, part of the report.

- B05902028： coding, debugging

- B06901031： Major of the program structure
