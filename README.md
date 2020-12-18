# kubernetes-onepoint
centos7系统一键部署kubernetes 1.16环境

环境说明：纯净的centos7环境,cpu核数大于2,内存大于2G,使用root账户进行操作。

功能说明：能够自动关闭防火墙，更换国内yum,docker,kubernetes源，自动配置网络dns，自动下载安装docker,kubelet,kubectl,kubeadm,并完成相关配置。
## Step 1 配置文件与网卡修改 ##
1.在node_list.json文件里按照文件内的格式进行配置，格式为"ip":"name"<br>
2.再dns文件也按ip name格式填写,可参考文件中的格式。<br>
3.将all.sh中第二行的ens33修改成环境下的网卡。

## Step 2 建立master节点 ##
1.将配置好的kubernetes-onepoint/文件夹拷入master节点中。
2.首先给all.sh进行授权```chmod +x all.sh```；再运行```./all.sh```  
3.过程需要3-5分钟。    
4.完成安装后，使用```kubectl get nodes```进行查看。    
5.当前仅支持一个master节点
## Step 3 建立worker节点 ##
1.首先将master中的所有文件（kubernetes-onepoint/）拷贝到worker节点中(一定要master中的文件，里面配置了token相关命令)  
2.再worker节点中运行：```chmod +x node.sh && ./node.sh  ```
3.需要等待一段时间，完成安装后使用kubectl get nodes查看节点信息  

当前脚本支持部署单个master与多个worker节点，节点需要提前定义在dns与node_list.json文件中。 
  
