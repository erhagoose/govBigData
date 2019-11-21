# convert obj.json to .csv
# only for preview

import os
import json

def json2csv(line, fields):
    obj = json.loads(line)
    return ','.join([(str(obj[f]) if f in obj.keys() else '') for f in fields])

tar_names = {
    'profiles': ['msgBiz', 'title'],
    'posts': ['msgBiz', 'msgMid', 'msgIdx', 'likeNum', 'readNum'],
    'comments': ['contentId', 'nickName', 'likeNum']
}
for name, fields in tar_names.items():
    fn = f'data/{name}.json'
    if not os.path.exists(fn):
        continue
    with open(f'data/{name}.csv', 'w') as fout:
        print(','.join(fields), file=fout)
        with open(fn, 'r') as fin:
            for line in fin:
                print(json2csv(line, fields), file=fout)
