FROM ovirtorg/imageio-test-fedora-31

COPY cirros.img /images/cirros.img
COPY invalid.img /images/invalid.img
COPY daemon.conf /conf/daemon.conf
COPY . /app

RUN yum install -y git && \
    git clone https://github.com/oVirt/ovirt-imageio.git && \
    cd ovirt-imageio/daemon && \
    make && \
    cp /conf/daemon.conf /ovirt-imageio/daemon/test/conf.d/daemon.conf && \
    mkdir -p /var/log/ovirt-imageio/ && \
    touch /var/log/ovirt-imageio/daemon.log && \
    cp /app/* test/pki/

CMD nohup bash -c "cd ovirt-imageio/daemon && ./ovirt-imageio -c test &" && \
    sleep 3 && \
    curl --unix-socket /ovirt-imageio/daemon/test/daemon.sock -X PUT -d '{"uuid": "cirros", "size": 46137344, "url": "file:///images/cirros.img", "timeout": 30000000000000, "ops": ["read"]}' http://localhost:12345/tickets/cirros && \
    curl --unix-socket /ovirt-imageio/daemon/test/daemon.sock -X PUT -d '{"uuid": "invalid", "size": 4096, "url": "file:///images/invalid.img", "timeout": 30000000000000, "ops": ["read"]}' http://localhost:12345/tickets/invalid && \
    sleep infinity
