#include <stdio.h>

int main() {
    int a = 10;
    int b = 20;
    int c;

    // Prompting the user to enter the value of c
    printf("Enter the value of c: ");
    scanf("%d", &c);

    // Check if c is equal to a + b
    if (c == a + b) {
        printf("Yes, c is equal to a + b\n");
    } else {
        printf("No, c is not equal to a + b\n");
    }

    return 0;
}

