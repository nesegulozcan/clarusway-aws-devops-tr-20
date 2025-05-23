# Hands-on EC2-04 (Version 2.0.0) : Extending and Partitioning EBS Volumes

Purpose of the this hands-on training is to teach the students how to add or attach an EBS (Elastic Block Storage) volume on an AWS instance, how to extend and resize volumes, and how to create partitions in volumes on running Amazon Linux 2023 EC2 instances.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- understand what is the difference between root volume and EBS Volume.

- list volumes to show current status of primary (root) and additional volumes

- demonstrate their knowledge on how to create EBS volume.

- create mounting point on EC2 instances.

- partition volume on EC2 instances.

- resize the volume or partitions on the new EBS volumes.

- understand how to auto-mount EBS volumes and partitions after reboots.

## Outline
- 

- Part 1 - Mount and Extend EBS Volume without Partitioning

- Part 2 - Extend the Root Volume

- Part 3 - Auto-mount EBS Volumes and Partitions on Reboot

![EBS Volumes](./ebs_backed_instance.png)

# PART 1 - EXTEND EBS VOLUME WITHOUT PARTITIONING

- launch an instance from aws console in "us-east-1a" AZ.
- check volumes which volumes attached to instance. 
- only root volume should be listed
```
lsblk
```
## Section 0 - Create new Volume 

- create a new volume in the same AZ "us-east-1" with the instance from AWS console "5 GB" for this demo.
- attach the new volume from aws console Action >>>> Attach Volume

- Select instance we created before
- Choose  "/dev/sdf "  as volume name but don't forget it will be seen in instance as "/dev/xvdf"
- Connect to EC2 with SSH
- then list  the block storages again.

```
lsblk
```
- root volume and secondary volume should be listed

## Section 1 - Mounting Volume

- check the root volume format
```
sudo file -s /dev/xvda1
```
- check if the attached volume is already formatted or not and has data on it.
```
sudo file -s /dev/xvdf
```
- if not formatted, format the new volume
```
sudo mkfs -t ext4 /dev/xvdf
```
- check the format of the volume again after formatting
```
sudo file -s /dev/xvdf
```
- create a mounting point path for new volume (volume-1)
```
sudo mkdir /mnt/mp1
```
- mount the new volume to the mounting point path
```
sudo mount /dev/xvdf /mnt/mp1/
```
- check if the attached volume is mounted to the mounting point path
```
lsblk
```
- show the available space, on the mounting point path
```
df -h
```
- check if there is data on it or not.
```
ls  /mnt/mp1/
```
- if there is no data on it, create a new file to show persistence in later steps

```
cd /mnt/mp1
sudo touch hello.txt
ls
```
## Section 2: Enlarge the new volume (volume-1) in AWS console and modify from terminal

- modify the new volume in aws console, and enlarge capacity from 5GB to 6GB .
- check if the attached volume is showing the new capacity
```
lsblk
```
- show the real capacity used currently at mounting path, old capacity should be shown.
```
df -h
```
- resize the file system on the new volume to cover all available space.
```
sudo resize2fs /dev/xvdf
```
- show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
```
df -h
```
- show that the data still persists on the newly enlarged volume.
```
ls /mnt/mp1/
```

# PART 2 - EXTEND ROOT VOLUME

- Check file system of the root volume's partition.
```
sudo file -s /dev/xvda1
```

- Go to Volumes, select instance's root volume and modify it (increase capacity 8 GB >> 12 GB).

- List block devices (lsblk) and file system disk space usage (df) of the instance again.

- Root volume should be listed as increased but partition and file system should be listed same as before.
```
lsblk
df -h
```
- Extend partition 1 on the modified volume and occupy all newly available space.
```
sudo growpart /dev/xvda 1
```
- Resize the xfs file system on the extended partition to cover all available space.

```
sudo xfs_growfs /dev/xvda1
```
- List block devices (lsblk) and file system disk space usage (df) of the instance again.
- Partition and file system should be extended.
```
lsblk
df -h
```

# PART 3 - AUTOMOUNT EBS VOLUMES AND PARTITIONS ON REBOOT


- show that mounting point path will be gone when instance rebooted 
```
sudo reboot now
```

- show the new volume is still attached, but not mounted
```
lsblk
```
sudo cat /etc/fstab
´´´
- back up the /etc/fstab file.
```
sudo cp /etc/fstab /etc/fstab.bak
```

- open /etc/fstab file and 
```
sudo nano /etc/fstab 
```

- add the following info to the existing.(UUID's can also be used)
```
/dev/xvdf       mnt/mp1   ext4    defaults,nofail        0       0

```
- CTRL+X and Y to save

- reboot and show that configuration exists (NOTE)
```
sudo reboot now
```

- list volumes to show current status, all volumes and partitions should be listed
```
lsblk
```

- show the used and available capacities related with volumes and partitions
```
df -h
```

- if there is data on it, check if the data still persists.
```
ls  /mnt/mp1/
```

### Mounting a Disk in Linux:


# 1. Editing /etc/fstab (Persistent Mounting)
✅ Type: Persistent
✅ Effect: The disk is automatically mounted every time the system starts.
✅ No need to manually run the mount command.

🔹 Edit the /etc/fstab file:

```bash
sudo nano /etc/fstab

🔹 Add the following line:

```bash
/dev/xvdf       /mnt/mp1   ext4    defaults,nofail        0       0
´´´
```

# 2. Using mount Command for Temporary Mounting

✅ Type: Temporary
✅ Effect: The disk is immediately available after mounting.
❌ However, it will NOT remain mounted after a reboot!
✅ Steps:

🔹 Manually mount the disk:

```bash

sudo mount /dev/xvdf /mnt/mp1/

df -h

