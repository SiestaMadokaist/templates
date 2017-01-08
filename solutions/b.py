def main():
    memo = [ 0 for i in xrange(220000)]
    n, x = map(int, raw_input().strip().split())
    qs = map(int, raw_input().strip().split())
    s= 0
    for q in qs:
        y = q ^ x
        s += memo[y]
        memo[q] += 1
    print(s)

main()
