# Remove duplicate characters using loop

s = input("Enter string: ")
result = ""
for ch in s:
    if ch not in result:
        result += ch
print("Unique string:", result)
