#include<iostream>
using namespace std;

int main(int argc, char* argv[]) {

  int n = 10;

  int second_last = 1;
  int last = 1;

  cout << second_last << endl << last << endl;

  for(int i=1; i<=n; i++) {
    int next = second_last + last;
    cout << next << endl;
    second_last = last;
    last = next;        // here is the problem
  }

  return 0;
}