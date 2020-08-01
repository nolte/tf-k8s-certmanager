#

``` bash
bash <(curl -s https://raw.githubusercontent.com/nolte/terraform-provider-harbor/develop/scripts/tst-00-prepare-kind.sh)
```

``` bash
cd ./examples/test/
go test --tags=integration -timeout 20m -v
```
