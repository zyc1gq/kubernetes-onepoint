import json
import subprocess
import sys
import os
#read res
with open("res","r") as fp:
    res=fp.read()
com="kubeadm join"+res.split("kubeadm join")[-1]
com=com.replace("\r","")
com=com.replace("\n","")
com=com.replace("\\","")
print com
with open("commond", "w+") as fp:
    fp.write(com)

