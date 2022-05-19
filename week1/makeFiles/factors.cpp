#include <iostream>
#include <math.h>
using namespace std;
void factors(int n)
{
    int i = 1;
    for (i; i <= n; i++)
    {
        if (n % i == 0)
        {
            cout << i << " ";
        }
    }
}
int main()
{
    int n;
    cin >> n;
    factors(n);
    return 0;
}