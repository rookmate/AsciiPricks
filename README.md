# Gas Report
| src/AsciiPricks.sol:AsciiPricks contract |                 |        |        |        |        |
|------------------------------------------|-----------------|--------|--------|--------|--------|
| Deployment Cost                          | Deployment Size |        |        |        |        |
| 3294592                                  | 14342           |        |        |        |        |
| Function Name                            | min             | avg    | median | max    | #calls |
| flipSaleState                            | 5548            | 7048   | 7548   | 7548   | 4      |
| getSeed                                  | 1177            | 2009   | 2009   | 2842   | 2      |
| mint                                     | 7316            | 65636  | 94797  | 94797  | 3      |
| alMint                                   | 10024           | 53729  | 53729  | 97435  | 2      |
| saleIsActive                             | 809             | 1809   | 1809   | 2809   | 2      |
| tokenURI                                 | 239599          | 239599 | 239599 | 239599 | 1      |

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
forge test -v --via-ir
```
