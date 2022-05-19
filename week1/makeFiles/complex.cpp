#include <iostream>
using namespace std;
int main()
{
    cout << "Enter first complex number: ";
    int nw, ni, mw, mi;
    cin >> nw;
    cin >> ni;
    cout << "Enter second complex number: ";
    cin >> mw;
    cin >> mi;
    cout << "result: " << nw + mw << " " << ni + mi;
    return 0;
}