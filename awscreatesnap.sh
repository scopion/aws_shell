#! /bin/bash
#get all volumes in br
#volumes=(`aws ec2 describe-volumes --query 'Volumes[*].{ID:VolumeId}' --output text`)
instances=$(aws ec2 describe-instances --region sa-east-1  --query 'Reservations[*].Instances[*].InstanceId' --output text)


echo 'print volumes and create snapshot'

for i in ${instances[*]}
do
#echo ${i};
#aws ec2 create-snapshot --volume-id $i --description "crontab snapshot.";
instancename=$(aws ec2 describe-instances --region sa-east-1 --instance-ids ${i}  --query 'Reservations[*].Instances[*].[Tags[*]]' --output text | grep Name | awk '{print $2}');

#instancename=$(aws ec2 describe-instances --region sa-east-1 --instance-ids ${i}  --query 'Reservations[*].Instances[*].[ BlockDeviceMappings[*].[Ebs.VolumeId], InstanceId,Tags[*]]' --output text | grep Name | awk '{print $2}');

instancevolumes=$(aws ec2 describe-instances --region sa-east-1 --instance-ids ${i}  --query 'Reservations[*].Instances[*].[ BlockDeviceMappings[*].[Ebs.VolumeId]]' --output text);

#echo $instancename ${i} ${instancevolumes[*]}

	for j in ${instancevolumes[*]}
	do
	echo "cron snapshot for ${j} in ${i} name ${instancename}.";
	#aws ec2 create-snapshot --volume-id ${j} --description "cron snapshot for ${j} in ${i} name ${instancename}."
	done

done

echo 'jobs done'
