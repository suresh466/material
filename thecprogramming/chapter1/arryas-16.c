#include <stdio.h>

int main()
{
	int c, i, nwhite, nother;
	int ndigit[10];

	nwhite = nother = 0;
	for (i = 0; i <= 9; ++i)
		ndigit[i] = 0;

	while ((c = getchar()) != EOF) {
		if (c > '0' &c < '9')
			++ndigit[c-'0'];
		else if (c == ' ' || c == '\n' || c == '\t')
			++nwhite;
		else
			++nother;
	}
	printf("Digits");
	for (i = 0; i <= 9; ++i)
		printf(" %d", ndigit[i]);
	printf(", White: %d, Other:%d\n", nwhite, nother);
}
