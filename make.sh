if [ ! -d out-orig ]; then
	mkdir out-orig
fi

for i in cbmbasic1 cbmbasic2 kbdbasic osi kb9 applesoft microtan aim65 sym1 w65c816sxb; do

echo $i
ca65 -D $i msbasic.s -o out-orig/$i.o &&
ld65 -C $i.cfg out-orig/$i.o -o out-orig/$i.bin -Ln out-orig/$i.lbl

done

