# Gas Report
| src/AsciiPricks.sol:AsciiPricks contract |                 |        |        |        |        |
|------------------------------------------|-----------------|--------|--------|--------|--------|
| Deployment Cost                          | Deployment Size |        |        |        |        |
| 3469211                                  | 15498           |        |        |        |        |
| Function Name                            | min             | avg    | median | max    | #calls |
| founderMint                              | 979             | 436997 | 2979   | 1307035| 3      |
| alMint                                   | 534             | 35975  | 10012  | 97380  | 3      |
| mint                                     | 712             | 40135  | 7431   | 94845  | 5      |
| flipSaleState                            | 5570            | 7284   | 7570   | 7570   | 7      |
| getSeed                                  | 1243            | 2159   | 2075   | 3243   | 4      |
| tokenURI                                 | 186603          | 186603 | 186603 | 186603 | 1      |
| getMerkleRoot                            | 555             | 1555   | 1555   | 2555   | 2      |
| setMerkleRoot                            | 5588            | 5588   | 5588   | 5588   | 1      |


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
