#include <stdio.h>

int main()
{
	int c, blankcount;
	blankcount = 0;
	while ((c = getchar()) != EOF) {
		if (c == ' ') {
			++blankcount;
			if (blankcount == 1) {
				putchar(c);
			}
		}
		else {
			putchar(c);
			blankcount = 0;
		}
	}
}
