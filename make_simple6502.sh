if [ ! -d out ]; then
	mkdir out
fi

for i in simple6502; do

echo $i
ca65 -D $i msbasic.s -o out/$i.o &&
ld65 -C $i.cfg out/$i.o -o out/$i.bin -Ln out/$i.lbl

done

