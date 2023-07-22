# Gas Report
| src/AsciiPricks.sol:AsciiPricks contract |                 |        |        |        |        |
|------------------------------------------|-----------------|--------|--------|--------|--------|
| Deployment Cost                          | Deployment Size |        |        |        |        |
| 8020654                                  | 15617           |        |        |        |        |
| Function Name                            | min             | avg    | median | max    | #calls |
| alMint                                   | 534             | 30260  | 9996   | 80252  | 3      |
| balanceOf                                | 2787            | 2787   | 2787   | 2787   | 4      |
| flipSaleState                            | 5570            | 7236   | 7570   | 7570   | 6      |
| getMerkleRoot                            | 555             | 1555   | 1555   | 2555   | 2      |
| getSeed                                  | 1221            | 4030   | 5221   | 7221   | 7      |
| mint                                     | 712             | 22166  | 5137   | 77678  | 4      |
| ownerOf                                  | 3127            | 3127   | 3127   | 3127   | 4      |
| saleIsActive                             | 853             | 1853   | 1853   | 2853   | 2      |
| setMerkleRoot                            | 5588            | 5588   | 5588   | 5588   | 1      |
| tokenURI                                 | 128622          | 128622 | 128622 | 128622 | 1      |


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
