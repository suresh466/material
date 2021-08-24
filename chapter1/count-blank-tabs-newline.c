#include <stdio.h>

int main()
{
	int c, bl, nl, tb;
	bl = 0;
	nl = 0;
	tb = 0;
	while ((c = getchar()) != EOF)
		if(c == '\n')
			++nl;
		else if(c == '\t')
			++tb;
		else if(c == ' ')
			++bl;
	printf("blank: %d\tnewline: %d\ttb: %d\n", bl, nl, tb);
}
