FROM centos
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
SHELL ["/bin/bash","-c"]
RUN echo $'[repo] \n\
name=kubernetes \n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 \n\
enabled=1 \n\
gpgcheck=1 >> /etc/yum.repos.d/kubernetes.repo \n\
repo_gpgcheck=1 >> /etc/yum.repos.d/kubernetes.repo \n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/kubernetes.repo

RUN yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

                
RUN mkdir /root/jenkins
RUN yum repolist
RUN mkdir /root/.kube
COPY ca.crt /root/
COPY client.key /root/
COPY client.crt /root/
COPY config /root/.kube/

RUN mkdir -p /var/run/sshd

RUN yum install -y java-11-openjdk.x86_64
RUN yum install openssh-server sudo -y
RUN yum install openssh-clients -y
RUN ssh-keygen -A
ADD ./sshd_config /etc/ssh/sshd_config
RUN echo root:jenkins | chpasswd
CMD ["/usr/sbin/sshd","-D"] 
RUN chmod -R 777 /root/jenkins
COPY php.yml /root

