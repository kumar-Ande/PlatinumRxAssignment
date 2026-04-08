s=input()
res=""
for c in s:
    if c not in res:
        res+=c
print(res)