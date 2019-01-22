# MIX Blockchain
A blockchain for the storage of semantic linked data.

Network ID: 76

Chain ID: 76

MIX Blockchain can be synchronized with either Parity or MIX Geth:

## Parity

```
parity --chain mix.json --pruning=fast --pruning-history=64 --pruning-memory=0
```

The pruning options are essential to prevent a 51% attack.

## Geth

Download [MIX Geth](https://github.com/mix-blockchain/mix-geth/releases):

You might need to make the file executable before you can run it, i.e.

```
chmod +x mix-geth-linux
./mix-geth-linux
```
