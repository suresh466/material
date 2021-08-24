#include <stdio.h>

#define MAXHIST 20
#define MAXWORD 11
#define IN 1
#define OUT 0

int main()
{
	int c, i, j, status, characterc, ovflow, maxval, len;
	int wl[MAXWORD];
	status = OUT;
	characterc = ovflow = 0;
	for (i = 0; i < MAXWORD; ++i)
		wl[i] = 0;

	while ((c = getchar()) != EOF) {
		if (c == ' ' || c == '\t' || c == '\n'){
			status = OUT;
			if (characterc > 0)
				if (characterc < MAXWORD)
					++wl[characterc];
				else
					++ovflow;
			characterc = 0;
		} else if (status == OUT) {
			status = IN;
			if (characterc == 0)
				characterc = 1;
		} else
			++characterc;
	}
	maxval = 0;
	for (i = 1; i < MAXWORD; ++i)
		if (wl[i] > maxval)
			maxval = wl[i];

	for (i = MAXHIST; i > 0; --i) {
		for (j = 1; j < MAXWORD; ++j)
			if (wl[j] * MAXHIST / maxval >= i)
				printf("  # ");
			else
				printf("    ");
		putchar('\n');
	}
	
	for (i = 1; i < MAXWORD; ++i)
		printf("%3d ", i);
	putchar('\n');
	for (i = 1; i < MAXWORD; ++i)
		printf("%3d ", wl[i]);
	putchar('\n');
	if (ovflow > 0)
		printf("| %d words were greater than %d |", ovflow, MAXWORD);
}
