#获取本机IP
local_ip=`ip a show dev ens33|grep -w inet|awk '{print $2}'|sed 's/\/.*//'`
command1="python parseIP.py $local_ip"
#echo $command1
#获取当前机器的名称
local_name=`$command1`
echo $local_name
#修改当前的机器名为设定名
hostnamectl set-hostname $local_name
#拼接dns
cat dns>>/ect/hosts
#关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
#配置内核参数
cat core >> /etc/sysctl.d/k8s.conf
#配置yum源
yum install -y wget
mkdir /etc/yum.repos.d/bak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.cloud.tencent.com/repo/epel-7.repo
yum clean all && yum makecache
#配置k8s源
cat K8S >> /etc/yum.repos.d/kubernetes.repo
#配置docker源
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
#安装docker
yum install -y docker-ce-18.06.1.ce-3.el7
systemctl enable docker && systemctl start docker
#安装相关组件
yum install -y kubelet-1.16.0 kubeadm-1.16.0 kubectl-1.16.0
systemctl enable kubelet
#使用$local_name判断节点类型
#master节点
if $local_name = master
then
 res=`kubeadm init --kubernetes-version=1.16.0 --apiserver-advertise-address=10.10.10.10 --image-repository registry.aliyuncs.com/google_containers --service-cidr=10.1.0.0/16 --pod-network-cidr=10.244.0.0/16`
#生成命令,将命令保存起来
# python parseCOM.py $res
 echo "master install successs"
else
#非master节点，获取命令
 order=`python getCOM.py`
 `$order`
 echo "node install successs"