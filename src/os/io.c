// For portability issues, these functions are still written in C

#include <stdio.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>

/*
 * Tests if a file exists
 */
int file_exists(char* filename)
{
	struct stat st;
	int err = stat(filename, &st);
	return err==0 || errno != ENOENT;
}

/*
 * Returns the file size
 */
size_t file_size(char* filename)
{
	struct stat st;
	int err = stat(filename, &st);
	if( err!=0 )
		return 0xFFFFFFFF;
	else
		return st.st_size;
}

/*
 * Returns read only status of the file
 */
int file_read_only(char* filename)
{
	int err = access(filename, W_OK);
	return err==0 ? 0 : 1;
}

/*
 * Returns true if the name is a directory
 */
int file_is_directory(char* filename)
{
	struct stat st;
	int err = stat(filename, &st);
	if( err!=0 )
		return 0;
	else
		return S_ISDIR(st.st_mode);
}

/*
 * Returns the time of last modification of file
 */
time_t file_last_modification(char* filename)
{
	struct stat st;
	int err = stat(filename, &st);
	if( err!=0 )
		return 0xFFFFFFFF;
	else
		return st.st_mtime;
}

/*
 * Put a string to stderr
 */
void fputs_stderr(char* s)
{
	fputs(s, stderr);
}

/*
 * Returns the name of a dirent
 */
char* dirent_name(struct dirent* d)
{
	return d->d_name;
}

/*
 * Returns true if the directory entry is a directory
 */
int dirent_is_directory(struct dirent* d)
{
	return d->d_type == DT_DIR;
}

/*
 * Open a directory
 */
DIR* dir_open(char* name)
{
	return opendir(name);
}

struct dirent* dir_read(DIR* dir)
{
	return readdir(dir);
}

void dir_close(DIR* dir)
{
	closedir(dir);
}

