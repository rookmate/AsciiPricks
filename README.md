# Gas Report
| src/AsciiPricks.sol:AsciiPricks contract |                 |        |        |        |         |
|------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                          | Deployment Size |        |        |        |         |
| 7972092                                  | 15361           |        |        |        |         |
| Function Name                            | min             | avg    | median | max    | # calls |
| alMint                                   | 527             | 30259  | 9985   | 80265  | 3       |
| balanceOf                                | 2780            | 2780   | 2780   | 2780   | 4       |
| flipSaleState                            | 5563            | 7229   | 7563   | 7563   | 6       |
| getMerkleRoot                            | 548             | 1548   | 1548   | 2548   | 2       |
| getSeed                                  | 1214            | 4023   | 5214   | 7214   | 7       |
| mint                                     | 705             | 22165  | 5130   | 77695  | 4       |
| ownerOf                                  | 3123            | 3123   | 3123   | 3123   | 4       |
| saleIsActive                             | 846             | 1846   | 1846   | 2846   | 2       |
| setMerkleRoot                            | 5581            | 5581   | 5581   | 5581   | 1       |
| tokenURI                                 | 128654          | 128654 | 128654 | 128654 | 1       |


# How to build the contract

## Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
```

## Update Foundry

```bash
foundryup
```

## Clone repo, build and run the tests

```bash
git clone git@github.com:rookmate/AsciiPricks.git
cd asskeydicks
forge test -v
```
