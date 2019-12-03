#!/bin/python3

import sys

if len(sys.argv) < 2:
    print('missing argument: filename')

filename = sys.argv[1]

print('filename: ', filename)

f = open(filename, 'r')
lines = f.readlines();
f.close()

header = lines[0]
content = lines[1:]

print('lines:')
for line in content:
    print('==============')
    fields = line.split('\t')
    for a in fields:
        print(a, end=' ')
    print('==============')
    print()

