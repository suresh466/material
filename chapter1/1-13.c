#include <stdio.h>

#define MAXHIST 20
#define IN 1
#define OUT 0
#define MAXWORD 11

int main()
{
	int c, i, count, maxval, len, ovflow, state;
	int wl[MAXWORD];

	count = ovflow = 0;
	for (i = 0; i < MAXWORD; ++i)
		wl[i] = 0;

	while((c = getchar()) != EOF) {
		if (c == ' ' || c == '\t' || c == '\n') {
			state = OUT;
			if (count > 0) {
				if (count < MAXWORD)
					++wl[count];
				else
					++ovflow;
				count = 0;
			}
		} else if (state == OUT){
			state = IN;
			count = 1;
		}
		else
			++count;
	}
	maxval = 0;
	for (i = 1; i < MAXWORD; ++i)
		if (wl[i] > maxval)
			maxval = wl[i];

	for (i = 1; i < MAXWORD; ++i){
		printf("%5d %5d ", i, wl[i]);
		if (wl[i] > 0) {
			if ((len = wl[i] * MAXHIST / maxval) <= 0)
				len = 1;
		} else
			len = 0;

		while (len > 0) {
			putchar('#');
			--len;
		}
		putchar('\n');
	}
	printf("| %d | words are longer than 10 characters", ovflow);
}
