# Only one single output remains unspent from block 123,321. What address was it sent to?

# Step 1: get all transactions from block 123321
blockHash=$(bitcoin-cli getblockhash "123321")
#echo $blockHash
block=$(bitcoin-cli getblock $blockHash)
#echo $block

# Step 2: iterate through all transactions to get the outputs:
numberOfTransactions=$(echo $block | jq -r .nTx)
for i in $(seq 0 $((numberOfTransactions - 1))); do
  txId=$(echo $block |  jq -r ".tx[$i]")
  tx=$(bitcoin-cli getrawtransaction $txId true)
  voutLength=$(echo $tx | jq -r '.vout | length')
  for j in $(seq 0 $((voutLength - 1))); do
    # if it is unspent, log it and exit 
    txout=$(bitcoin-cli gettxout $txId 0 false)
    address=$(echo $txout | jq -r '.scriptPubKey.address')
    if [[ -n "$address" ]]; then
      echo $address
      exit
    fi
  done
done