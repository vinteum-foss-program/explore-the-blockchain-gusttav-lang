# Which tx in block 257,343 spends the coinbase output of block 256,128?

# Step 1: get all transactions from block 256128
blockHash=$(bitcoin-cli getblockhash "256128")
#echo $blockHash
block=$(bitcoin-cli getblock $blockHash)
#echo $block

# Step 2: get the coinbase transaction (the first output)
coinbaseTxId=$(echo $block |  jq -r '.tx[0]')
# echo "coinbaseTxId $coinbaseTxId"
# coinbaseTx=$(./bitcoin-cli  getrawtransaction $coinbaseTxId true)
# echo $coinbaseTx

# Step 3: get all transactions from block 257343
blockHash=$(bitcoin-cli getblockhash "257343")
#echo $blockHash
block=$(bitcoin-cli getblock $blockHash)
#echo $block

# Step 4: iterate in all transactions to find the previous address as the input
numberOfTransactions=$(echo $block | jq -r '.nTx')
for i in $(seq 1 $((numberOfTransactions - 1))); do # skip the first since it is the coinbase
  txId=$(echo $block |  jq -r '.tx[$i]')
  tx=$(bitcoin-cli getrawtransaction $txId true)
  vinLength=$(echo $tx | jq -r '.vin | length')
  for j in $(seq 0 $((vinLength - 1))); do
    vinTxId=$(echo "$tx" | jq -r ".vin[$j].txid")
    if [ "$vinTxId" == "$coinbaseTxId" ]; then
      echo $txId
      exit
    fi
  done  
done
