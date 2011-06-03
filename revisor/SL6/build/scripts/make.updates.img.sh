TMPIMG=/tmp/updates.img
MNTPOINT=/tmp/rhupdates

if [ -f locations.include ] ; then
 . ./locations.include
else
  if [ -f ../locations.include ] ; then
    . ../locations.include
  fi
fi

# update image is used to override/add anaconda(installer) code
# to create/use the update image
#   you need a RHupdates directory which is a tree of anaconda code changes 
#	Defined in "./locations.include" as ANACONDA_UPDATES_DIR
# 	Default is ./anacondaupdates
#   a directory for the resultant image file
#	Defined in "./locations.include" as UPDATES_IMG_DIR
#       Default is /etc/revisor/SL6/images
#   Define the name of the resultant image file
#	Defined in "./locations.include" as UPDATES_IMG
#       Default is sl6-updates.img
#   to define this resultant directory and image file to the revisor.conf file
#       Defined in "revisor.conf" as updates_img 
#       Default for updates_img in "/etc/revisor/revisor.conf" is /etc/revisor/SL6/images/sl6-updates.img
#	Note this is per product/arch

if [  -z $ANACONDA_UPDATES_DIR ] ; then
	ANACONDA_UPDATES_DIR=./anacondaupdates
fi

if [ -z $UPDATES_IMG_DIR ] ; then
        UPDATES_IMG_DIR="/etc/revisor/SL6/images"
fi

if [ -z $UPDATES_IMG ] ; then
        UPDATES_IMG="sl6-updates.img"
fi

#Need to check that we have a $ANACONDA_UPDATES_DIR dir, if not then do not create updates.img
if [ ! -d $ANACONDA_UPDATES_DIR ] ; then
  echo "Not making a $UPDATES_IMG since there is no ANACONDA_UPDATES_DIR directory"
  exit 1
fi

IMAGESIZE=`du -s $ANACONDA_UPDATES_DIR | cut -f1`
if [ $IMAGESIZE -le 65 ] ; then
	echo "Image was too small so had to make it bigger"
	IMAGESIZE=65
fi
IMAGESIZE=`expr $IMAGESIZE + 1`
echo "IMAGESIZE IS $IMAGESIZE"
INODES=`find $RHupdates -print | wc -l`
INODES=`expr $INODES + 10`
echo "INODES is $INODES"
dd if=/dev/zero of=$TMPIMG bs=1k count=$IMAGESIZE 
/sbin/mke2fs -F -m 0 -q -N $INODES -b 1024 $TMPIMG $IMAGESIZE
rm -rf $MNTPOINT
mkdir $MNTPOINT
mount -o loop,sync -t ext2 $TMPIMG $MNTPOINT
/bin/rm -r $MNTPOINT/lost+found
(cd $ANACONDA_UPDATES_DIR ; find . | cpio -pvdum $MNTPOINT)
sync
sync
sync
df -k $MNTPOINT
df -i $MNTPOINT
umount $MNTPOINT
#CJS we need to verify that what we think we copied to the .img is really there
mount -o loop,ro -t ext2 $TMPIMG $MNTPOINT
diff -r $MNTPOINT $ANACONDA_UPDATES_DIR
if [ $? != 0 ] ; then
  echo "The newly created $TMPIMG does not match $ANACONDA_UPDATES_DIR"
  umount $MNTPOINT
  exit 1
else
  umount $MNTPOINT
fi


if [ ! -d $UPDATES_IMG_DIR ] ; then
   mkdir $UPDATES_IMG_DIR
else 
   if [ -s $UPDATES_IMG_DIR/$UPDATES_IMG ] ; then 
      echo "Copying $UPDATES_IMG_DIR/$UPDATES_IMG as $UPDATES_IMG_DIR/$UPDATES_IMG.$DATE"
      cp $UPDATES_IMG_DIR/$UPDATES_IMG $UPDATES_IMG_DIR/$UPDATES_IMG.$DATE
   fi
fi
echo "Copying $TMPIMG as $UPDATES_IMG_DIR/$UPDATES_IMG"
