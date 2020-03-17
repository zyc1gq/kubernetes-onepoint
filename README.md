# kubernetes-onepoint
centos7系统一键部署kubernetes

环境说明：纯净的centos7环境,cpu核数大于2,内存大于2G,使用root账户进行操作。

功能说明：能够自动关闭防火墙，更换国内yum,docker,kubernetes源，自动配置网络dns，自动下载安装docker,kubelet,kubectl,kubeadm,并完成相关配置。

一.第一步：配置master-node相关信息  
在node_list.json文件里按照文件内的格式进行配置，格式为"ip":"name"


二.第二步：在master中运行all.sh  
首先给all.sh进行授权chmod +x all.sh；再运行./all.sh  
过程需要3-5分钟。    
完成安装后，使用kubectl get nodes进行查看。    
当前仅支持一个master几点  


三.第三步：再worker节点上运行node.sh  
首先将master中的所有文件拷贝到worker节点中(一定要master中的文件，里面配置了token相关命令)  
再worker节点中运行：chmod +x node.sh && ./node.sh  
需要等待一段时间，完成安装后使用kubectl get nodes查看节点信息  
可部署多个worker节点  
  
