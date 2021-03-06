# Usage: sudo ./run_mmap.sh

# Reference: Bash script processing limited number of commands in parallel
# https://stackoverflow.com/posts/19543185/revisions

# use > instead of >> here to truncate the log
user_program/master data/file1_in mmap > log_master &
user_program/slave data/file1_out mmap 127.0.0.1 > log_slave &
wait
echo Diff of file1 on mmap/mmap:
diff data/file1_in data/file1_out
wait

user_program/master data/file2_in mmap >> log_master &
user_program/slave data/file2_out mmap 127.0.0.1 >> log_slave &
wait
echo Diff of file2 on mmap/mmap:
diff data/file2_in data/file2_out
wait

user_program/master data/file3_in mmap >> log_master &
user_program/slave data/file3_out mmap 127.0.0.1 >> log_slave &
wait
echo Diff of file3 on mmap/mmap:
diff data/file3_in data/file3_out
wait

user_program/master data/file4_in mmap >> log_master &
user_program/slave data/file4_out mmap 127.0.0.1 >> log_slave &
wait
echo Diff of file4 on mmap/mmap:
diff data/file4_in data/file4_out
wait

echo
echo Log of Master:
cat log_master
echo
echo Log of Slave:
cat log_slave