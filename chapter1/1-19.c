#include <stdio.h>

#define MAXLINE 1000

int getline(char line[], int maxline);
void reverse(char s[]);

int main()
{
	char line[MAXLINE];
	while (getline(line, MAXLINE) > 0) {
		reverse(line);
		printf("%s", line);
	}
	return 0;
}

int getline(char s[], int lim)
{
	int i, c;
	for (i = 0; i < lim - 1 &&(c=getchar())!='\n' &&c!=EOF; ++i)
		s[i] = c;
	if (c == '\n') {
		s[i] = c;
		++i;
	}
	s[i] = '\0';
	return i;
}

void reverse(char s[])
{
	int i, j;
	char temp;

	for (i = 0; s[i] != '\0'; ++i);

	--i;
	if (s[i] == '\n')
		--i;

	j = 0;
	while (j < i) {
		temp = s[j];
		s[j] = s[i];
		s[i] = temp;
		--i;
		++j;
	}
	return;
}
