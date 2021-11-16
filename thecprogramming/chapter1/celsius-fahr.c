#include <stdio.h>

int main()
{
	float celsius, fahr;
	float lower, upper, step;
	
	lower = 0;
	upper = 300;
	step = 20;

	celsius = lower;
	printf("celsius to fahr\n");
	while (celsius <= upper) {
		fahr = (celsius*1.8) + 32.0;
		printf("%3.0f\t%6.1f\n", celsius, fahr);
		celsius = celsius + step;
	}
}
