#include <stdio.h>

#define MAXHIST 20

int main()
{
	int c, i, nwhite, nother, maxval, len;
	int ndigit[10];

	nwhite = nother = 0;
	for (i = 0; i < 10; ++i)
		ndigit[i] = 0;

	while ((c = getchar()) != EOF) {
		if (c == ' ' || c == '\t' || c == '\n')
			++nwhite;
		else if (c >= '0' && c <= '9')
			++ndigit[c-'0'];
		else
			++nother;
	}
	maxval = 0;
	if (nother > maxval)
		maxval = nother;
	if (nwhite > maxval)
		maxval = nwhite;
	for (i =0; i < 10; ++i)
		if (ndigit[i] > maxval)
			maxval = ndigit[i];

	printf("Others: %d ", nother);
	if (nother > 0) {
		if ((len = nother * MAXHIST / maxval) <= 0) {
			len = 1;
		}
	} else
		len = 0;
	while (len > 0) {
		putchar('#');
		--len;
	}
	putchar('\n');
	printf("White: %3d ", nwhite);
	if (nwhite > 0) {
		if ((len = nwhite * MAXHIST / maxval) <= 0)
			len = 1;
	} else
		len = 0;
	while (len > 0) {
		putchar('#');
		--len;
	}
	putchar('\n');
	for (i = 0; i < 10; ++i){
		printf("%d %8d ", i, ndigit[i]);
		if (ndigit[i] > 0) {
			if ((len = ndigit[i] * MAXHIST / maxval) <= 0)
				len = 1;
		}
		else
			len = 0;
		while (len > 0){
			putchar('#');
			--len;
		}
		putchar('\n');
	}
}
