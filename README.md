# Gas Report
| src/AsciiPricks.sol:AsciiPricks contract |                 |        |        |        |        |
|------------------------------------------|-----------------|--------|--------|--------|--------|
| Deployment Cost                          | Deployment Size |        |        |        |        |
| 8068143                                  | 15854           |        |        |        |        |
| Function Name                            | min             | avg    | median | max    | #calls |
| alMint                                   | 534             | 30271  | 10012  | 80268  | 3      |
| flipSaleState                            | 5570            | 7236   | 7570   | 7570   | 6      |
| getMerkleRoot                            | 555             | 1555   | 1555   | 2555   | 2      |
| getSeed                                  | 1221            | 1776   | 1221   | 2886   | 3      |
| mint                                     | 712             | 22179  | 5137   | 77733  | 4      |
| saleIsActive                             | 853             | 1853   | 1853   | 2853   | 2      |
| setMerkleRoot                            | 5588            | 5588   | 5588   | 5588   | 1      |
| tokenURI                                 | 160719          | 160719 | 160719 | 160719 | 1      |


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
