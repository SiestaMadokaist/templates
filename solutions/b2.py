import sys

n,x = map(int,sys.stdin.readline().split())
arr = map(int,sys.stdin.readline().split())

sm=0
S=[0]*100050
for num in arr:
    y=num^x
    if y<100050 and y>=0:
        sm+=S[y]
        S[num]+=1
print sm
