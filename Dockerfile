FROM ovirtorg/imageio-test-fedora-31

COPY cirros.img /images/cirros.img
COPY . /app

RUN yum install -y git && \
    git clone https://github.com/oVirt/ovirt-imageio.git && \
    cd ovirt-imageio/daemon && \
    make && \
    sed -i 's/port = 0/port = 12345/g' test/conf/daemon.conf && \
    sed -i 's/host = 127.0.0.1/host = /g' test/conf/daemon.conf && \
    cp /app/* test/pki/

CMD nohup bash -c "cd ovirt-imageio/daemon && ./ovirt-imageio -c test/conf &" && sleep 3 && curl --unix-socket ovirt-imageio/daemon/test/daemon.sock -X PUT -d '{"uuid": "cirros", "size": 46137344, "url": "file:///images/cirros.img", "timeout": 30000000000000, "ops": ["read"]}' http://localhost:12345/tickets/cirros && sleep infinity
