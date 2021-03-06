<mkconfig

MKSHELL = rc

PUBHTMFILE = `{eval '
for( i in `{goblin ls -r 100 '$PPDIR'}){
	~ $i *.htm && {echo $i | sed -e s!^'$PPDIR'!'$PUBDIR'!}
}
'}

PUBMDFILE = `{eval '
for( i in `{ goblin ls -r 100 '$PPDIR' } ) {
	~ $i *.md && {echo $i | sed -e s!^'$PPDIR'!'$PUBDIR'!}
}
'}

PUBTXTFILE = `{eval '
for( i in `{ goblin ls -r 100 '$PPDIR' } ) {
	~ $i *.txt && {echo $i | sed -e s!^'$PPDIR'!'$PUBDIR'!}
}
'}

PUBTSVFILE = `{eval '
for( i in `{ goblin ls -r 100 '$PPDIR' } ) {
	~ $i *.tsv && {echo $i | sed -e s!^'$PPDIR'!'$PUBDIR'!}
}
'}

BUILDFILE = $PUBHTMFILE $PUBMDFILE $PUBTXTFILE $PUBTSVFILE
WEBFILE = $HTMFILE

INC = `{goblin ls -r 100 inc}
TGT = $BUILDFILE

all:VQ: build
build:V: $PUBDIR $TGT

%.jpg %.png %.svg %.mp4 %.m3 %.mkv :N:

$PUBDIR:
	mkdir -p $target

$PUBDIR/%.htm : $INC $PPDIR/%.htm $PUBDIR/%.md
	mkdir -p `{dirname $target}
	$PP $PPDIR/$stem.htm > $PUBDIR/$stem.htm

$PUBDIR/%.md : $INC $PPDIR/%.md
	mkdir -p `{dirname $target}
	$PP $PPDIR/$stem.md > $PUBDIR/$stem.md

$PUBDIR/%.txt : $INC $PPDIR/%.txt
	mkdir -p `{dirname $target}
	$PP $PPDIR/$stem.txt > $PUBDIR/$stem.txt

$PUBDIR/%.tsv : $INC $PPDIR/%.tsv
	mkdir -p `{dirname $target}
	$PP $PPDIR/$stem.tsv > $PUBDIR/$stem.tsv

$PPDIR/% :N:

tree:V:
	goblin ls -r 100

run:V: clean
	goblin ls $PPDIR | entr mk	
sync:V: build
	rsync -ak $DELFLAG $PUBDIR $RPUBDIR

syncrun:VQ:
	while(true){
		sleep 1
		mk sync > /dev/null
	}

clean:V:
	rm -f $TGT

