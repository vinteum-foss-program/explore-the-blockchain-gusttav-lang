# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

# Step 1: get the transaction
tx=$(bitcoin-cli getrawtransaction "e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163" true)
#echo $tx

# Step 2: get the redeem script knowing tha the script type as "witness_v0_scripthash"
scriptHex=$(echo $tx | jq -r ".vin[0].txinwitness[2]")
script=$(bitcoin-cli decodescript $scriptHex)

# Step 3: extract all the publick keys from the asm field (compressed keys start with 02 or 03)
asm=$(echo $script | jq -r '.asm')
#echo $asm
pubkeys=($(grep -oE '\b(02|03)[0-9a-fA-F]{64}\b' <<< "$asm"))
echo $pubkeys # only the first key

# Step 4: check which pubkey has signed the script
# TODO: I stopped here, I still need to check which pubkey has signed the message. I talked to many folks
# on the Discord channel, and no one could solve how to check the signature. The problem here is the following:
# The 'verifysignature' needs 3 parameters:
# 1 - the address: We have the public key, but I'm not sure if the real address should be used. I don't think it is possible
# to create the address from the pubkey with the CLI, the 'createmultisig' will probably generate another address. A possible
# solution would be to get the previous rawtransaction and see the address there 
# 2 - The signature, this one is straightforward to get
# 3 - The message: No one in Discord seemed to understand what is necessary to construct the message with SegWit. I found
# this link, but did not try to implement it in Bash: https://bitcoin.stackexchange.com/questions/78235/what-exactly-is-hashed-and-signed-in-a-segwit-transaction

# This is what I tried to do:
# signature=$(echo $tx | jq -r ".vin[0].txinwitness[0]")
# echo $signature
# for pubkey in "${pubkeys[@]}"; do  
#   address=$(./bitcoin-cli -rpcconnect="84.247.182.145" -rpcuser="user_084" -rpcpassword="XgIcqbe5f5DG" createmultisig 1 "[\"$pubkey\"]" "bech32" | jq -r '.address')
#   echo $pubkey
#   echo $address
#   ./bitcoin-cli -rpcconnect="84.247.182.145" -rpcuser="user_084" -rpcpassword="XgIcqbe5f5DG" verifymessage $address $signature "e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
#   # if [ "$RESULT" == "true" ]; then
# done