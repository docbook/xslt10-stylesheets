#!/usr/bin/env python

import subprocess
import xml.etree.ElementTree as ET
import sys

all = len(sys.argv) == 2 and sys.argv[-1] == 'all'

GIT_COMMIT_FIELDS = ['id', 'author_name', 'author_email', 'date', 'message', 'paths']
GIT_LOG_FORMAT = ['%H', '%an', '%ae', '%ad', '%s']
#
# git's --format specifier doesn't cover the list of files (which can be generated
# with '--name-only' and '--name-status'.
# To be able to identify that path list we inject a '001e' character at the very
# beginning of each entry. Then, the list of paths is the last chunk of each entry
# following an empty line.
GIT_LOG_FORMAT = '%x1e' + '%x1f'.join(GIT_LOG_FORMAT)
command = ['git', 'log', '--format=%s' % GIT_LOG_FORMAT, '--name-only']
if not all:
    # Determine the last release tag and limit history to then.
    release = ['git', 'describe', '--tags', '--match', 'release/*', '--abbrev=0', '--always']
    try:
        out = subprocess.check_output(release, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        print >> sys.stderr, 'Error executing "{}": {}'.format(' '.join(e.cmd), e.output)
        sys.exit(-1)
    out = out.strip()
    command.append('%s..HEAD'%out.decode(encoding='UTF-8'))
out = subprocess.check_output(command)
out = out.decode(encoding='UTF-8')
entries = out.strip('\n\x1e').split('\x1e')
entries = [row.strip().split('\x1f') for row in entries]
# separate paths from message
for entry in entries:
    t = entry[-1].rsplit('\n\n', 1)
    entry[-1] = t[0]
    entry.append(len(t) == 2 and t[1].split('\n') or '')
entries = [dict(zip(GIT_COMMIT_FIELDS, entry)) for entry in entries]

builder = ET.TreeBuilder()
builder.start('log', {})
for e in entries:
    if not e['id']:
        continue
    builder.start('logentry', {'revision':e['id']})
    builder.start('author', {})
    builder.data(e['author_name'])
    builder.end('author')
    builder.start('date', {})
    builder.data(e['date'])
    builder.end('date')
    builder.start('msg', {})
    builder.data(e['message'])
    builder.end('msg')
    builder.start('paths', {})
    for p in e['paths']:
        builder.start('path', {})
        builder.data(p)
        builder.end('path')
    builder.end('paths')
    builder.end('logentry')
builder.end('log')
root = builder.close()
print(ET.tostring(root, encoding='utf-8'))
