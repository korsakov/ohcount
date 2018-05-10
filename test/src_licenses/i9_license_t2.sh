#
#
# Copyright (C) 2008, 2009 i9 Project Contributors(1)
#     All Rights Reserved.
#
# You may only modify and redistribute this under the terms of any of the
# following licenses(2): i9 License
#
#
# (1) i9 Project Contributors are listed in the AUTHORS file and at
#     http://i9os.googlecode.com/svn/trunk/Documentation/AUTHORS - please extend this file,
#     not this notice.
# (2) Reproduced in the files in /Documentation/Licenses, and at:
#     http://i9os.googlecode.com/svn/trunk/Documentation/Licenses
# 
# As per the above licenses, removal of this notice is prohibited.
#
# -------------------------------------------------------------------------
#

cd Utilities
make -C ../BuildMk clean

make -C ../Microkernel/user/serv/sigma0 clean

make -C ../Microkernel/user/lib clean

make -C ../Microkernel/user/serv/kickstart clean

make -C ../Microkernel/user/apps/l4test clean

cd ../Microkernel/user && make clean

cd ../BuildMk && make clean
cd ../BuildL4UL && make clean

cd ../Personalities/GenodeKit/build.pistachio_x86 && make clean

cd ..

rm *~ Documentation/*~ Documentation/*/*~ */*~ */*/~


