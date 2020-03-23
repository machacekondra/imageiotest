This is container for testing [ImageIO](https://github.com/oVirt/ovirt-imageio) without oVirt engine running.
To fake also oVirt engine you can check [fakeovirt](https://github.com/machacekondra/fakeovirt).

```bash
docker build . --tag machacekondra/imageiotest
docker run -d -p 127.0.0.1:12345:12345 machacekondra/imageiotest
curl -k https://127.0.0.1:12345/images/cirros -o cirros.img
qemu-img check cirros.img
```
