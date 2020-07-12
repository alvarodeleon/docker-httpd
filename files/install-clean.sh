
yum -y --setopt=tsflags=nodocs update && \
    yum clean all

yum install -y initscripts

yum clean all