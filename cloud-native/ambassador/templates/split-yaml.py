#!/usr/bin/env python3

import sys
import yaml

for data in yaml.safe_load_all(sys.stdin):
    if data != None:
        with open(data["metadata"]["name"]+".yaml","w") as output:
            yaml.dump(data, output)
