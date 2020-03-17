#all k8s
import json
import subprocess
import sys

nowIP=sys.argv[1]
# print nowIP
nowIP=nowIP.replace("\r","")

with open('node_list.json','r')as fp:
    json_data = json.load(fp)
    print json_data[nowIP]
#create a dns file use node_list.json
with open('dns','w+')as fp:
    for k in json_data:
        fp.write(k+" "+json_data[k]+"\n")

