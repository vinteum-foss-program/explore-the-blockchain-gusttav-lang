# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
transactions=$(bitcoin-cli getrawtransaction "37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517" true)

#echo $transactions

#tx1=$(echo "$transactions" | jq -r .vin.[0].txid)
#tx1Witness=$(echo "$transactions" | jq -r .vin.[0].txinwitness)
#tx2=$(echo "$transactions" | jq -r .vin.[1].txid)
#tx2Witness=$(echo "$transactions" | jq -r .vin.[1].txinwitness)
#tx3=$(echo "$transactions" | jq -r .vin.[2].txid)
#tx3Witness=$(echo "$transactions" | jq -r .vin.[2].txinwitness)
#tx4=$(echo "$transactions" | jq -r .vin.[3].txid)
#tx4Witness=$(echo "$transactions" | jq -r .vin.[3].txinwitness)

tx1PubKey=$(echo "$transactions" | jq .vin.[0].txinwitness.[1])
tx2PubKey=$(echo "$transactions" | jq .vin.[1].txinwitness.[1])
tx3PubKey=$(echo "$transactions" | jq .vin.[2].txinwitness.[1])
tx4PubKey=$(echo "$transactions" | jq .vin.[3].txinwitness.[1])

#echo $tx1
#echo $tx1Witness
#echo $tx1PubKey

bitcoin-cli createmultisig 1 "[$tx1PubKey,$tx2PubKey,$tx3PubKey,$tx4PubKey]" "legacy" | jq -r .address

