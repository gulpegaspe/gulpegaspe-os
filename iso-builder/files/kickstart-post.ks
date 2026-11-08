%post
sed -i '/ \/ /s/^/#/' /etc/fstab
%end
