#获取本机IP
local_ip=`ip a show dev ens33|grep -w inet|awk '{print $2}'|sed 's/\/.*//'`
command1="python parseIP.py $local_ip"
#echo $command1
#获取当前机器的名称
local_name1=`$command1`
local_name=`echo $local_name1 | tr -d "\n"`
echo $local_name
#修改当前的机器名为设定名
echo "**********************change hostname**********************"
#hostnamectl set-hostname $local_name
#拼接dns
echo "**********************cat dns**********************"
`cat dns>>/etc/hosts`
#关闭防火墙
echo "**********************close ufw**********************"
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
#配置内核参数
echo "**********************change core**********************"
`cat core >> /etc/sysctl.d/k8s.conf`
#配置yum源
echo "**********************change yum source**********************"
yum install -y wget
echo "0000000000000000000000000000000000000000"
mkdir /etc/yum.repos.d/bak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
echo "0000000000000000000000000000000000000000"
`wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo`
echo "0000000000000000000000000000000000000000"
`wget -O /etc/yum.repos.d/epel.repo http://mirrors.cloud.tencent.com/repo/epel-7.repo`
echo "0000000000000000000000000000000000000000"
yum clean all && yum makecache
#配置k8s源
echo "**********************change k8s source**********************"
`cat K8S >> /etc/yum.repos.d/kubernetes.repo`
#配置docker源
echo "**********************change docker source**********************"
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
#安装docker
echo "**********************install docker********************** "
yum install docker-ce-18.06.1.ce
systemctl enable docker && systemctl start docker
#安装相关组件
echo "**********************install k8s-let...**********************"
yum install conntrack
yum install -y kubelet-1.16.0 kubeadm-1.16.0 kubectl-1.16.0
systemctl enable kubelet
#使用$local_name判断节点类型
#master节点
#if $local_name = master
#then
echo "**********************master install**********************"
kubeadm init --kubernetes-version=1.16.0 --apiserver-advertise-address=$local_ip --image-repository registry.aliyuncs.com/google_containers --service-cidr=10.1.0.0/16 --pod-network-cidr=10.244.0.0/16 > res
#生成命令,将命令保存起来
python parseCOM.py
echo "**********************master install successs**********************"
#else
##非master节点，获取命令
# order=`python getCOM.py`
# `$order`
# echo "node install successs"
#配置kubectl
echo "*********************************kubectl*********************************"
mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config
#kubectl get nodes
#kubectl get cs
echo "*********************************fannel*********************************"
kubectl apply -f kube-flannel.yml