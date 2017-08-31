#! /bin/bash
#the date before 30 days ago 
deldate=$(date -d '-30 day' +'%Y-%m-%d')
echo ${deldate}

#get the volumes in all instance
delvolumes=$(aws ec2 describe-instances  --query 'Reservations[*].Instances[*].[ BlockDeviceMappings[*].[Ebs.VolumeId]]' --output text)
echo ${delvolumes[*]}

for i in ${delvolumes[*]}
do
echo ${i};
#get the snap that created 30 days ago from all volumes
delsnap=$(aws ec2 describe-snapshots --owner-ids 883721749424 --filters Name=volume-id,Values=${i} Name=start-time,Values=${deldate}* --query 'Snapshots[*].SnapshotId' --output text)
if [ "${delsnap}" = '' ]; then
        echo "no snap to del in ${deldate}"
else
        echo "del snap ${delsnap} "
		#aws ec2 delete-snapshot --snapshot-id ${delsnap}

fi
done
