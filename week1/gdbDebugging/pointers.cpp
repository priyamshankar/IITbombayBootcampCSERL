#include <iostream>
using namespace std;

int main(int argc, char *argv[])
{

    int a = 45;
    int b = 22;
    int *p = &a;
    int *q = NULL;

    cout << *p << endl;

    p = q;
    // cout << *p << endl;  earlier value
    cout << p << endl;  //cannot print the value of null pointer because ther is no value to print

    p = &b;
    cout << *p << endl;

    return 0;
}