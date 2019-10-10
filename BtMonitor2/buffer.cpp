
// C++ program of implementation of gap buffer

#include <string>
using namespace std;

static int buffer[100] = { 0 };

// Function that is used to grow the gap
// at index position and return the array


void insert(int number)
{
    memmove(&buffer[0], &buffer[1], 400);

    buffer[99] = number;
}

int * get()
{
    return buffer;
}

