#include <stdio.h>

#define MAXLINE 1000

int getline(char line[], int lim);
int removee(char s[]);

int main()
{
	char line[MAXLINE];

	while (getline(line, MAXLINE) > 0)
		if (removee(line) > 0)
			printf("%s", line);
	return 0;
}

/* line: Read a line; return the length of the line. */
int getline(char s[], int lim)
{
	int i, c;
	for (i = 0; i < lim -1 &&(c=getchar())!='\n' &&c!=EOF; ++i)
		s[i] = c;
	if (c == '\n') {
		s[i] = c;
		++i;
	}
	s[i] = '\0';
	++i;
	return i;
}

/* remove: Remove trailing white space; returns the length of the line.
 * Note: Does not delete completely blank lines.
*/
int removee(char s[])
{
	int i, j, nwhite;
	char cs[MAXLINE];
	nwhite = 0; 
	j = 0; for (i = 0; s[i] != '\0'; ++i) {
		if (s[i] == ' ' || s[i] == '\t') {
			++nwhite;
			if (nwhite == 1) {
				s[j] = s[i];
				++j;
			}
		} else {
			nwhite = 0;
		s[j] = s[i];
			++j;
		}
	}
	if (s[i] s[i] == '\0') {
		s[j] = s[i];
		++j;
	}
	return j;
}
