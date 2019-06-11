# 2019 OS Project 2 - Synchronous Virtual Device
> http://rswiki.csie.org/dokuwiki/courses:107_2:project_2

## 設計 Program Design

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
Transmission time: 0.018100 ms, File size: 32 bytes
Transmission time: 0.057100 ms, File size: 4619 bytes
Transmission time: 0.094800 ms, File size: 77566 bytes
Transmission time: 12.240700 ms, File size: 12022885 bytes

Log of Slave:
Transmission time: 0.091500 ms, File size: 32 bytes
Transmission time: 0.085200 ms, File size: 4619 bytes
Transmission time: 0.425000 ms, File size: 77566 bytes
Transmission time: 15.113500 ms, File size: 12022885 bytes
```

### mmap
```
Log of Master:
Transmission time: 0.018400 ms, File size: 32 bytes
[  763.441686] [PJ2] master: 8000000058600267
Transmission time: 0.045600 ms, File size: 4619 bytes
[  763.455095] [PJ2] master: 8000000058680267
Transmission time: 0.058500 ms, File size: 77566 bytes
[  763.466013] [PJ2] master: 8000000058680267
Transmission time: 3.501100 ms, File size: 12022885 bytes
[  763.467215] [PJ2] master: 8000000058680267

Log of Slave:
Transmission time: 0.092700 ms, File size: 32 bytes
[  763.443435] [PJ2] slave: 8000000058680225
Transmission time: 0.164700 ms, File size: 4619 bytes
[  763.457700] [PJ2] slave: 8000000058600225
Transmission time: 0.087800 ms, File size: 77566 bytes
[  763.472651] [PJ2] slave: 8000000058600225
Transmission time: 8.833100 ms, File size: 12022885 bytes
[  763.475611] [PJ2] slave: 8000000058600225
```

## 效能比較 Performance Comparison

### Comparison between fnctl and mmap
It can be seen that when the file size gets larger, using mmap would be a lot faster. 

We have known that primitive I/O have an extra cost on coping files from page cache to the target address, while memory-mapped I/O is able to directly access the file from the page cache by the map. However, mmap has a large cost on setup/tear down overhead and page fault compared to fnctl. So when the file size is large enough for the cost of coping in fnctl to bypass the cost of overhead in mmap, memory-mapped I/O tends to work better.

Note that primitive I/O usually doesn't suffer from page fault, while memory-mapped I/O does. So, say, if we need to access ramdom parts of the file frequently, mmap might waste a lot of time on the overhead. This is not the case here since we only need to access the file once from start to end.

### Miscellaneous
Theoretically in file1 primitive I/O would do better since memory-mapped I/O spend time seting up/tearing down. But there is little difference in the result. 

In fact, the transmission time in file1 and file2 varies in a range every time we run it. Even two different machine would get a quite different result. This might be due to some scheduling issue when CPU deals with the program.




## 組員貢獻 Contributions

- B04201020： Collect results

- B04201021： Write report.md

- B04201043： Collect results, part of the report.

- B05902028： Debugging

- B06901031： Major part of the code
