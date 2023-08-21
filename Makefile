SRC="src"
PDCFLAGS=-k
NAME="pushrocks.pdx"

main:
	pdc $(PDCFLAGS) $(SRC) $(NAME)

run: main
	PlaydateSimulator $(NAME)
