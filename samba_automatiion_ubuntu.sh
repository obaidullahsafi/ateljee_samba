#!/bin/bash

#Add users
echo "Adding users"
sudo useradd -m -p 123456 -s /bin/bash dzengiz > /dev/null
sudo useradd -m -p 123456 -s /bin/bash patrick > /dev/null
sudo useradd -m -p 123456 -s /bin/bash solaiman > /dev/null
sudo useradd -m -p 123456 -s /bin/bash mariette > /dev/null
sudo useradd -m -p 123456 -s /bin/bash koen > /dev/null
sudo useradd -m -p 123456 -s /bin/bash kadrie > /dev/null
sudo useradd -m -p 123456 -s /bin/bash niels > /dev/null
sudo useradd -m -p 123456 -s /bin/bash jimmy > /dev/null
sudo useradd -m -p 123456 -s /bin/bash johan > /dev/null
sudo useradd -m -p 123456 -s /bin/bash michel > /dev/null
sudo useradd -m -p 123456 -s /bin/bash mikail > /dev/null
sudo useradd -m -p 123456 -s /bin/bash miriama > /dev/null
sudo useradd -m -p 123456 -s /bin/bash obaidullah > /dev/null

#Creating samba password
echo "Samba password creation"
echo -ne "123456\n123456" | smbpasswd -a dzengiz > /dev/null
echo -ne "123456\n123456" | smbpasswd -a patrick > /dev/null
echo -ne "123456\n123456" | smbpasswd -a solaiman > /dev/null
echo -ne "123456\n123456" | smbpasswd -a mariette > /dev/null
echo -ne "123456\n123456" | smbpasswd -a koen > /dev/null
echo -ne "123456\n123456" | smbpasswd -a kadrie > /dev/null
echo -ne "123456\n123456" | smbpasswd -a niels > /dev/null
echo -ne "123456\n123456" | smbpasswd -a jimmy > /dev/null
echo -ne "123456\n123456" | smbpasswd -a johan > /dev/null
echo -ne "123456\n123456" | smbpasswd -a michel > /dev/null
echo -ne "123456\n123456" | smbpasswd -a mikail > /dev/null
echo -ne "123456\n123456" | smbpasswd -a miriama > /dev/null
echo -ne "123456\n123456" | smbpasswd -a obaidullah > /dev/null

# Creating users groups
echo "Creating users groups"
sudo groupadd public > /dev/null
sudo groupadd R_workshops > /dev/null
sudo groupadd RW_workshops > /dev/null
sudo groupadd R_DTP > /dev/null
sudo groupadd RW_DTP > /dev/null
sudo groupadd admin > /dev/null

#Adding users to Admin group
echo "Adding users to Admin group"
usermod obaidullah -aG admin > /dev/null
usermod dzengiz -aG admin > /dev/null
usermod patrick -aG admin > /dev/null

#Adding users to public group
echo "Adding users to public group"
usermod dzengiz -aG public > /dev/null
usermod patrick -aG public > /dev/null
usermod solaiman -aG public > /dev/null
usermod mariette -aG public > /dev/null
usermod koen -aG public > /dev/null
usermod kadrie -aG public > /dev/null
usermod niels -aG public > /dev/null
usermod jimmy -aG public > /dev/null
usermod johan -aG public > /dev/null
usermod michel -aG public > /dev/null
usermod mikail -aG public > /dev/null
usermod miriama -aG public > /dev/null
usermod obaidullah -aG public > /dev/null

echo "Adding users to R_workshops group"
usermod solaiman -aG R_workshops > /dev/null
usermod mariette -aG R_workshops > /dev/null
usermod koen -aG R_workshops > /dev/null
usermod kadrie -aG R_workshops > /dev/null
usermod niels -aG R_workshops > /dev/null
usermod johan -aG R_workshops > /dev/null
usermod mikail -aG R_workshops > /dev/null
usermod miriama -aG R_workshops > /dev/null
usermod obaidullah -aG R_workshops > /dev/null

echo "Adding users to RW_workshops group"
usermod dzengiz -aG RW_workshops > /dev/null
usermod patrick -aG RW_workshops > /dev/null
usermod jimmy -aG RW_workshops > /dev/null
usermod michel -aG RW_workshops > /dev/null

echo "Adding users to R_DTP group"
usermod dzengiz -aG R_DTP > /dev/null
usermod solaiman -aG R_DTP > /dev/null
usermod mariette -aG R_DTP > /dev/null
usermod koen -aG R_DTP > /dev/null
usermod kadrie -aG R_DTP > /dev/null
usermod niels -aG R_DTP > /dev/null
usermod jimmy -aG R_DTP > /dev/null
usermod johan -aG R_DTP > /dev/null
usermod michel -aG R_DTP > /dev/null
usermod mikail -aG R_DTP > /dev/null
usermod miriama -aG R_DTP > /dev/null
usermod obaidullah -aG R_DTP > /dev/null

echo "Adding users to RW_DTP group"
usermod patrick -aG RW_DTP > /dev/null

#Permission and ownership
echo "Setting permission and ownership"
sudo chmod -R 0770 /srv/shares/DTP > /dev/null
sudo chown -R root:RW_DTP /srv/shares/DTP > /dev/null

#Creation of smb.conf
echo "Creating smb.conf file"
echo "... removing old samba config"
sudo rm -rf smb.conf

echo "... setting up new samba config"
cat > /etc/samba/smb.conf << EOF
[global]
        workgroup = SAMBA
        security = user

        passdb backend = tdbsam
        netbios name = files

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

[homes]
        comment = Home Directories
        browseable = Yes
        writable = Yes
        valid users = %S

[public]
        comment = Secure File Server Share
        path =  /srv/shares/public
        valid users = @public
        guest ok = no
        writable = yes
        browsable = yes

        force directory mode = 770
        force create mode = 770
        force group = public

[workshops]
        comment = Secure File Server Share
        path =  /srv/shares/workshops
        valid users = @R_workshops
        write list = @admin, @RW_workshops
        guest ok = no
        writable = no
        browsable = yes

        force directory mode = 770
        force create mode = 770

        force group = RW_workshops

[DTP]
        comment = Secure File Server Share
        path =  /srv/shares/DTP
        valid users = @R_DTP
        write list = @admin, @RW_DTP
        guest ok = no
        writable = no
        browsable = yes

        force directory mode = 770
        force create mode = 770
        force group = RW_DTP
EOF

#Stop and start samba
echo "Stop and start samba"
sudo service smbd restart > /dev/null

echo "#################################"
echo "#### User shares are now set ####"
echo "#################################"
