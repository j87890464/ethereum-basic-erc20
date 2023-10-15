## WETH contract foundry test

## Usage

### Build

```shell
$ forge build
```

### Test

Test entire weth test cases
```shell
$ forge test --mc WETHTest
```
Or test specific case via
```shell
$ forge test --mc WETHTest --mt test_Constructor
```