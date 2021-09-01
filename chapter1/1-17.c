#include <stdio.h>

#define MAXLINE 1000
#define LONGLINE 80

int getline(char line[], int limit);

int main ()
{
	int len;
	char line[MAXLINE];

	while ((len = getline(line, MAXLINE)) > 0)
		if (len > LONGLINE)
			printf("%s", line);
	return 0;
}

/* getline: Read a line into 'line'; return length. */
int getline(char line[], int lim)
{
	int i, c;
	for (i = 0; i < lim-1 &&(c=getchar())!='\n' &&c!=EOF; ++i)
		line[i] = c;
	if (c == '\n')
	{
		line[i] = c;
		++i;
	}
	line[i] = '\0';
	return i;
}
