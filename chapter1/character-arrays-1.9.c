#include <stdio.h>

#define MAXLINE 1000

int getline(char line[], int lim);
void copy(char to[], char from[]);
int main()
{
	int i, len, maxlength;
	char line[MAXLINE], longest[MAXLINE];
	maxlength = 0;
	for (i = 0; i < MAXLINE; ++i){
		line[i] = 0;
		longest[i] = 0;
	}
	while ((len = getline(line, MAXLINE)) > 0) {
		if (len > maxlength) {
			copy(longest, line);
			maxlength = len;
		}
	}
	if (maxlength > 0) {
	printf("maxlength: %d\n", maxlength);
	printf("%s\n", longest);
	}
}

/* getline: read a line into s, return length */
int getline(char s[], int lim)
{
	int c, i;
	for (i = 0; i < lim -1 &(c=getchar())!=EOF &c!='\n'; ++i)
		s[i] = c;
	if (c == '\n') {
		s[i] = c;
		++i;
	}
	s[i] = '\0';
	return i;
}

/* copy: Copy 'from' into 'to'; assume to is big enough. */
void copy(char to[], char from[])
{
	int i;
	i = 0;
	while ((to[i] = from[i]) != '\0')
		++i;
}
