#include <stdio.h>

#define MAXLINE 10

int getline(char line[], int maxline);
void copy(char to[], char from[]);

int main()
{
	int i, len, max;
	char line[MAXLINE], longest[MAXLINE];

	max = 0;
	while ((len = getline(line, MAXLINE)) > 0)
		if (len > max) {
			max = len;
			copy(longest, line);
		}
	if (max > 0)
		printf("Longest line length: %d, line: %s\n", max, longest);
	return 0;
}

/* getline: Read a line into s, return length. */
int getline(char s[], int lim)
{
	int c, i, j;
	j = 0;
	for (i = 0; (c=getchar())!='\n' &&c!=EOF; ++i)
		if (i < lim -2) {
			s[j] = c;
			++j;
		}
	if (c == '\n') {
		s[j] = c;
		++i;
		++j;
	}
	s[j] = '\0';
	return i;
}

/* copy: Copy string 'from' into 'to'; assume to is big enough. */
void copy(char to[], char from[])
{
	int i;
	i = 0;
	while ((to[i] = from[i]) != '\0')
		++i;
}
