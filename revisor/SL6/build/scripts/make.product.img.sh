TMPIMG=/tmp/product.img
MNTPOINT=/tmp/productimg

if [ -f locations.include ] ; then
 . ./locations.include
else
  if [ -f ../locations.include ] ; then
    . ../locations.include
  fi
fi

# Product image is used to override/add installclasses
# to use the productimage
#   you need a installclasses directory with installclass.py 's
#       Defined in "./locations.include" as PRODUCT_INPUT_DIR
#       Default is ./product
#   a directory for the resultant image file
#       Defined in "./locations.include" as PRODUCT_IMG_DIR
#       Default is /etc/revisor/SL6/images
#   Define the name of the resultant image file
#       Defined in "./locations.include" as PRODUCT_IMG
#       Default is sl6-product.img
#   to define this resultant directory and image file to the revisor.conf file
#       Defined in "revisor.conf" as product_img
#       Default for product_img in "/etc/revisor/revisor.conf" is /etc/revisor/SL6/images/sl6-product.img
#       Note this is per product/arch

if [  -z $PRODUCT_INPUT_DIR ] ; then
	PRODUCT_INPUT_DIR=./product
fi

if [ -z $PRODUCT_IMG_DIR ] ; then
        PRODUCT_IMG_DIR="/etc/revisor/SL6/images"
fi

if [ -z $PRODUCT_IMG ] ; then
        PRODUCT_IMG="sl6-product.img"
fi

if [ ! -d $PRODUCT_INPUT_DIR ] ; then
  echo "You do not have $PRODUCT_INPUT_DIR, so skipping creation of $PRODUCT_IMG"
  exit 1
else
  echo "You have $PRODUCT_INPUT_DIR so creating $PRODUCT_IMG"
fi

IMAGESIZE=`du -s $PRODUCT_INPUT_DIR | cut -f1`
if [ $IMAGESIZE -le 65 ] ; then
	echo "Image was too small so had to make it bigger"
	IMAGESIZE=65
fi
echo $IMAGESIZE
dd if=/dev/zero of=$TMPIMG bs=1k count=$IMAGESIZE 
/sbin/mke2fs -F -q -i 1024 -b 1024 $TMPIMG $IMAGESIZE
if [ -d $MNTPOINT ] ; then
   rm -rf $MNTPOINT
fi
mkdir $MNTPOINT
mount -o loop,sync -t ext2 $TMPIMG $MNTPOINT
/bin/rm -r $MNTPOINT/lost+found
(cd $PRODUCT_INPUT_DIR ; find . | cpio -pvdum $MNTPOINT)
sync
sync
sync
umount $MNTPOINT
mount -o loop,sync -t ext2 $TMPIMG $MNTPOINT
sync
sync
sync
umount $MNTPOINT
#CJS we need to verify that what we think we copied to the .img is really there
echo "Verifying that the image was made correctly"
mount -o loop,ro -t ext2 $TMPIMG $MNTPOINT 
diff -r $MNTPOINT $PRODUCT_INPUT_DIR 
if [ $? != 0 ] ; then
     echo "The newly created $TMPIMG does not match $PRODUCT_INPUT_DIR"
     umount $MNTPOINT
     exit 1
fi
umount $MNTPOINT
if [ ! -d $PRODUCT_IMG_DIR ] ; then
   mkdir $PRODUCT_IMG_DIR
else 
   if [ -s $PRODUCT_IMG_DIR/$PRODUCT_IMG ] ; then 
      echo "Copying $PRODUCT_IMG_DIR/$PRODUCT_IMG as $PRODUCT_IMG_DIR/$PRODUCT_IMG.$DATE"
      cp $PRODUCT_IMG_DIR/$PRODUCT_IMG $PRODUCT_IMG_DIR/$PRODUCT_IMG.$DATE
   fi
fi
echo "Copying $TMPIMG as $PRODUCT_IMG_DIR/$PRODUCT_IMG"
