

#wget simplesim-3v0e.tgz

#wget http://www.simplescalar.com/

#wget http://www.simplescalar.com/

tar -xvf simplesim-3v0e.tgz
#tf = tarfile.open("simplesim-3v0e.tgz")
#tf.extractall()

#time.sleep(10)

tar -xvf simpletools-2v0.tgz
#tf1 = tarfile.open("simpletools-2v0.tgz")
#tf1.extractall()

#time.sleep(10)


tar -xvf simpleutils-2v0.tgz
#tf2 = tarfile.open("simpleutils-2v0.tgz")
#tf2.extractall()
#time.sleep(10)


cd binutils-2.5.2/
#with cd("~/binutils-2.5.2/"):
 #       subprocess.call("ls")
#time.sleep(10)


./configure --host=i386-*-gnu/linux --target=ssbig-na-sstrix --with-gnu-as -- with-gnu-as --with-gnu-ld --prefix=../

#time.sleep(10)

make
#time.sleep(10)

make install
#time.sleep(10)

cd ../simplesim-3.0
#time.sleep(10)

make
#time.sleep(10)

cd ../gcc-2.6.3/

./configure --host=i386-*-gnu/linux --target=ssbig-na-sstrix --with-gnu-as -- with-gnu-as --with-gnu-ld --prefix=../

make LANGUAGES=c
#time.sleep(10)

make install
#time.sleep(10)

cd ../glibc-1.09/
#time.sleep(10)

./configure --host=i386-*-gnu/linux/ssbig-na-sstrix ssbig-na-sstrix
#time.sleep(10)

make
#time.sleep(10)

make innstall
#time.sleep(10)


cd ../simplesim-3.0/
#time.sleep(10)

./sim-outorder tests/bin/test-math

#time.sleep(10)
