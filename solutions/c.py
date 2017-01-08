class Vote:
    def __init__(self, qs):
        self.qs = qs
        self.rcount = sum(1 for x in qs if x == "R")
        self.dcount = sum(1 for x in qs if x == "D")
        self.r = 0
        self.d = 0

    def run(self):
        new_qs = []
        for q in self.qs:
            if(q == "D"):
                if(self.d == 0):
                    self.r += 1
                    new_qs.append(q)
                elif(self.d > 0):
                    self.d -= 1
                    self.dcount -= 1
            elif(q == "R"):
                if(self.r == 0):
                    self.d += 1
                    new_qs.append(q)
                elif(self.r > 0):
                    self.r -= 1
                    self.rcount -= 1
        self.qs = new_qs
    def not_finished(self):
        assert self.rcount >= 0
        assert self.dcount >= 0
        if(self.rcount == 0): return False
        if(self.dcount == 0): return False
        return True


import random
def rand():
    if(random.random() > 0.5): return "R"
    return "D"

# tests = "".join([rand() for _ in xrange(200000)])
# n = raw_input()
# tests = raw_input()
v = Vote("DRDRRR")
while(v.not_finished()):
    v.run()
print v.qs[0]
