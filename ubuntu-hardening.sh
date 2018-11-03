#!/bin/bash
# Copyright (c) 2015-2016 Ben Hall
# All rights reserved.
#
# Name: ubuntu-hardening-script
# Version: 1.0.3
# PLAT:  linux-64
# PLAT-Version: linux-14.04

echo "Basic Ubuntu Hardening Script v.1.0.3 for Ubuntu 14.04"
echo "Created by Ben Hall"
echo "Note: Designed for CyberPatriots! Any use within the CyberPatriots competition will disqualify you!"
echo

read -p "Begin script? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then

  #ssh
  sudo sed -i 's/.*PermitRootLogin.*//' /etc/ssh/sshd_config
  sudo echo "PermitRootLogin no" >> /etc/ssh/sshd_config
  sudo sed -i 's/.*PermitEmptyPasswords.*//' /etc/ssh/sshd_config
  sudo echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

  #ufw
  sudo ufw enable

  #media files
  sudo find /home -iname "*.mp3" -delete
  sudo find /home -iname "*.jpg" -delete
  sudo find /home -iname "*.png" -delete
  sudo find /home -iname "*.mp4" -delete

  #users
  sudo sed -i 's/pam.unix.so/pam_unix.so remember=5 difok=3 retry=3 minlen=8 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1/' /etc/pam.d/common-password
  sudo sed -i 's/PASS_MAX_DAYS*/#PASS_MAX_DAYS 90/' /etc/login.defs
  sudo sed -i 's/PASS_MIN_DAYS*/#PASS_MIN_DAYS 14/' /etc/login.defs
  sudo sed -i 's/PASS_WARN_AGE*/#PASS_WARN_AGE 7/' /etc/login.defs
  sudo echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
  sudo passwd -l root

  #network protection
  sudo echo "nospoof on" >> /etc/host.conf
  sudo sysctl -w net.ipv4.conf.all.rp_filter=1
  sudo sysctl -w net.ipv4.conf.default.rp_filter=1
  sudo sysctl -w net.ipv4.ip_forward=0
  sudo sysctl -w net.ipv4.tcp_syncookies=1
  sudo sysctl -w net.ipv4.tcp_max_syn_backlog=2048
  sudo sysctl -w net.ipv4.tcp_synack_retries=2
  sudo sysctl -w net.ipv4.tcp_syn_retries=5
  sudo sysctl -p

fi

echo "Ubuntu Hardening Script finished!"
echo -n "Press any button to exit."
echo
