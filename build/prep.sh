echo "Distribution Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

mkdir -p $LFS/sources

for f in $(cat $DIST_ROOT/build/build_list)
do
	bn=$(basename $f)
	
	if ! test -f $LFS/sources/$bn ; then
		wget $f -O $LFS/sources/$bn
	fi

done;

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var,lib64,tools}

if ! test $(id -u builder) ; then
groupadd builder
useradd -s /bin/bash -g builder -m -k /dev/null builder
passwd builder
chown -v builder $LFS/{bin,etc,lib,sbin,usr,var,lib64,tools}

dbhome=$(eval echo "~builder")
cat > $dbhome/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > $dbhome/.bashrc << EOF
set +h
umask 022
LFS=$LFS
DIST_ROOT=$DIST_ROOT
EOF

cat >> $dbhome/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"
EOF

fi