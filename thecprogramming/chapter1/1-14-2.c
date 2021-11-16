#include <stdio.h>

#define MAXHIST 20
#define MAXCHAR 128

int main()
{
	int c, i, len, maxval;
	int cc[MAXCHAR];
	for (i = 0; i < 128; ++i)
		cc[i] = 0;

	while ((c = getchar()) != EOF) {
		if (c < MAXCHAR)
			++cc[c];
	}
	maxval = 0;
	for (i = 0; i < MAXCHAR; ++i)
		if (cc[i] > maxval)
			maxval = cc[i];
	for (i = 0; i < MAXCHAR; ++i) {
		if ((isprint(i)))
			printf("%d - %c - %d ", i, i, cc[i]);
		else 
			printf("%d - %d ", i, cc[i]);
		if (cc[i] > 0) {
			if ((len = cc[i] * MAXHIST/ maxval) <= 0)
				len = 1;
		}
		else
			len = 0;
		while (len > 0) {
			putchar('#');
			--len;
		}
		putchar('\n');
	}
}
