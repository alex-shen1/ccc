doc:
	touch index.md
	cd ../..; make -s
	source-highlight -s cpp -d *.sol
	dot -Tsvg -O inheritance.dot
	/bin/mv -f inheritance.dot.svg inheritance.dot.1.svg
	source-highlight -d tokens.py
	solc --abi INFTManager.sol > INFTManager.abi
	../maketabs.py

test:
	solc ERC20.sol
	solc ERC721.sol
	