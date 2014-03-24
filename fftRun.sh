SIZES="64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 232144 524288 1048576"
for i in $SIZES; do
	echo Size $i
	echo -n $i ''>> data
	./fft.rb `echo $i` | echo `awk '{print $3}'` ''>> data
done
